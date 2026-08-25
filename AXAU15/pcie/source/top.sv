
module top (
    // 200MHz system clock
    input   logic       sysclk_p,
    input   logic       sysclk_n,
    //
    output  logic[1:0]  led,
    //
    input  logic[3:0]  pcie_mgt_rxn,
    input  logic[3:0]  pcie_mgt_rxp,
    output logic[3:0]  pcie_mgt_txn,
    output logic[3:0]  pcie_mgt_txp,
    input  logic       pcie_perstn,
    input  logic       pcie_refclk_n,
    input  logic       pcie_refclk_p
);
    
    
    logic         axi_aclk;
    logic         axi_aresetn;
    
    logic[27:0] led_count;
    always_ff @(posedge axi_aclk) begin
        led_count <= led_count + 1;
        led <= led_count[27:26];
    end

    logic [15:0]    regfile_addr;
    logic           regfile_clk;
    logic [31:0]    regfile_din;
    logic [31:0]    regfile_dout;
    logic           regfile_en;
    logic           regfile_rst;
    logic [3:0]     regfile_we;          

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
        .pcie_mgt_rxn       (pcie_mgt_rxn),
        .pcie_mgt_rxp       (pcie_mgt_rxp),
        .pcie_mgt_txn       (pcie_mgt_txn),
        .pcie_mgt_txp       (pcie_mgt_txp),
        .pcie_perstn        (pcie_perstn),
        .pcie_ref_clk_n     (pcie_refclk_n),
        .pcie_ref_clk_p     (pcie_refclk_p)
    );

    // This register file gives software contol over unit under test (UUT).
    localparam int Nregs = 16;
    logic [Nregs-1:0][31:0] slv_reg, slv_read;

    assign slv_read[0] = 32'hdeadbeef;
    assign slv_read[1] = 32'h76543210;
    
    assign slv_read[2] = slv_reg[2];
    
    assign slv_read[Nregs-1:3] = slv_reg[Nregs-1:3];

    mem_regfile #(
       .Naddr($clog2(Nregs))
    ) regfile_inst (
        .clk        (regfile_clk),
        .addr       (regfile_addr[$clog2(Nregs)+1:2]),
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
endmodule

/*
    mem_regfile #(
       .Naddr($clog2(Nregs))
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
*/
