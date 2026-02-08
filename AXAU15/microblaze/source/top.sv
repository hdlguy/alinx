
module top (
    // 200MHz lvds clock
    input  logic       sysclk_n,
    input  logic       sysclk_p,
    //
    output  logic[1:0]  led,
    //
    input   logic       resetn,
    input   logic       usb_uart_rxd,
    output  logic       usb_uart_txd
);

//    logic clk, sysclk;
//    IBUFDS IBUFDS_sysclk (.O(sysclk), .I(sysclk_p), .IB(sysclk_n));
//    BUFG BUFG_sysclk (.O(clk), .I(sysclk));
    

    logic         axi_aclk;
    logic         axi_aresetn;
    
    logic [15:0] regfile_addr;  
    logic regfile_clk;           
    logic [127:0] regfile_din;   
    logic [127:0] regfile_dout;  
    logic regfile_en;             
    logic regfile_rst;           
    logic [15:0] regfile_we;      
    

    system system_i (
        .sysclk_clk_n       (sysclk_n),
        .sysclk_clk_p       (sysclk_p),
        .resetn             (resetn),
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
        .usb_uart_rxd       (usb_uart_rxd),
        .usb_uart_txd       (usb_uart_txd)       
    );

    // This register file gives software contol over unit under test (UUT).
    localparam int Naddr = 4;
    localparam int Nregs = 2**Naddr;
    logic [Nregs-1:0][31:0] slv_reg, slv_read;

    assign slv_read[0] = 32'hdeadbeef;
    assign slv_read[1] = 32'h76543210;
    
    assign led         = slv_reg[2][1:0];
    assign slv_read[2] = slv_reg[2];
    
    assign slv_read[Nregs-1:3] = slv_reg[Nregs-1:3];

    logic[Nregs-1:0][31:0]  reg_val, pul_val, read_val;
    mem_regfile #(
       .Naddr       (Naddr),
       .init_reg    (0)
    ) uut (
       .clk         (regfile_clk),
       .addr        (regfile_addr[Naddr+2-1:2]),
       .wr_data     (regfile_din),
       .rd_data     (regfile_dout),
       .en          (regfile_en),
       .we          (regfile_we),
       //
       .reg_val     (reg_val),
       .pul_val     (pul_val),
       .read_val    (read_val)
    );





endmodule

