//
module top (
    output  logic           pl_led1,
    output  logic           fan_pwm,
    input   logic           clkin200_p,
    input   logic           clkin200_n,
    //
    input   logic           uart_rxd,
    output  logic           uart_txd        
);
    
    logic [11:0]    regfile_addr;
    logic           regfile_clk;
    logic [31:0]    regfile_din;
    logic [31:0]    regfile_dout;
    logic           regfile_en;
    logic           regfile_rst;
    logic [3:0]     regfile_we;          

    logic           axi_aclk;
    logic [0:0]     axi_aresetn;
    

    system system_i (
        //
        .regfile_addr       (regfile_addr),
        .regfile_clk        (regfile_clk),
        .regfile_din        (regfile_din),
        .regfile_dout       (regfile_dout),
        .regfile_en         (regfile_en),
        .regfile_rst        (regfile_rst),
        .regfile_we         (regfile_we),  
        //
        .axi_aclk           (axi_aclk),
        .axi_aresetn        (axi_aresetn),
        //
        .uart_rxd(uart_rxd),
        .uart_txd(uart_txd)        
    );
    
    // This register file gives software contol over unit under test (UUT).
    localparam int Nregs = 16;
    logic [Nregs-1:0][31:0] slv_reg, slv_read;

    assign slv_read[0] = 32'hdeadbeef;
    assign slv_read[1] = 32'h76543210;
    
    assign slv_read[2] = slv_reg[2];
    
    assign slv_read[Nregs-1:3] = slv_reg[Nregs-1:3];
    
    mem_regfile #(
       .Naddr(4)  // 16 registers
    ) uut (
        .clk        (regfile_clk),
        .addr       (regfile_addr[5:2]),
        .wr_data    (regfile_din),
        .rd_data    (regfile_dout),
        .en         (regfile_en),
        .reset      (regfile_rst),
        .we         (regfile_we),
        //
        .reg_val    (slv_reg),
        .pul_val    (),
        .read_val   (slv_read)
    );
    
	
	logic[26:0] led_count;
    always_ff @(posedge axi_aclk) begin
        led_count <= led_count + 1;
	    pl_led1 <= led_count[26];
	    fan_pwm <= led_count[17] & led_count[16] & led_count[15];
	end

    top_ila top_ila_inst (.clk(axi_aclk), .probe0(led_count)); // 27

    // let us use the 200MHz differential clock
    logic clkin200, clk200;
    IBUFDS IBUFDS_inst (.O(clkin200 ), .I(clkin200_p),  .IB(clkin200_n));
    BUFG BUFG_inst (.O(clk200), .I(clkin200));
    
	logic[26:0] clk200_count;
    always_ff @(posedge clk200) clk200_count <= clk200_count + 1;
    top_ila clk200_ila_inst (.clk(clk200), .probe0(clk200_count)); // 27    
    
endmodule
    
