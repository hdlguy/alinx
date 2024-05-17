
module top (
    // 200MHz lvds clock
    input  logic       sysclk_n,
    input  logic       sysclk_p,
    //
    output  logic[1:0]  led,
    //
    input   logic       resetn,
    input   logic       usb_uart_rxd,
    output  logic       usb_uart_txd,
    //
    output              ddr4_act_n,
    output logic[16:0]  ddr4_adr,
    output logic[1:0]   ddr4_ba,
    output logic[0:0]   ddr4_bg,
    output logic[0:0]   ddr4_ck_c,
    output logic[0:0]   ddr4_ck_t,
    output logic[0:0]   ddr4_cke,
    output logic[0:0]   ddr4_cs_n,
    inout  logic[1:0]   ddr4_dm_n,
    inout  logic[15:0]  ddr4_dq,
    inout  logic[1:0]   ddr4_dqs_c,
    inout  logic[1:0]   ddr4_dqs_t,
    output logic[0:0]   ddr4_odt,
    output              ddr4_reset_n        
);

//    logic clk, sysclk;
//    IBUFDS IBUFDS_sysclk (.O(sysclk), .I(sysclk_p), .IB(sysclk_n));
//    BUFG BUFG_sysclk (.O(clk), .I(sysclk));
    
    logic [31:0]  M00_AXI_araddr;
    logic [2:0]   M00_AXI_arprot;
    logic         M00_AXI_arready;
    logic         M00_AXI_arvalid;
    logic [31:0]  M00_AXI_awaddr;
    logic [2:0]   M00_AXI_awprot;
    logic         M00_AXI_awready;
    logic         M00_AXI_awvalid;
    logic         M00_AXI_bready;
    logic [1:0]   M00_AXI_bresp;
    logic         M00_AXI_bvalid;
    logic [31:0]  M00_AXI_rdata;
    logic         M00_AXI_rready;
    logic [1:0]   M00_AXI_rresp;
    logic         M00_AXI_rvalid;
    logic [31:0]  M00_AXI_wdata;
    logic         M00_AXI_wready;
    logic [3:0]   M00_AXI_wstrb;
    logic         M00_AXI_wvalid;
    logic         axi_aclk;
    logic         axi_aresetn;

    system system_i (
        .sysclk_clk_n       (sysclk_n),
        .sysclk_clk_p       (sysclk_p),
        .resetn             (resetn),
        //
        .M00_AXI_araddr     (M00_AXI_araddr),
        .M00_AXI_arprot     (M00_AXI_arprot),
        .M00_AXI_arready    (M00_AXI_arready),
        .M00_AXI_arvalid    (M00_AXI_arvalid),
        .M00_AXI_awaddr     (M00_AXI_awaddr),
        .M00_AXI_awprot     (M00_AXI_awprot),
        .M00_AXI_awready    (M00_AXI_awready),
        .M00_AXI_awvalid    (M00_AXI_awvalid),
        .M00_AXI_bready     (M00_AXI_bready),
        .M00_AXI_bresp      (M00_AXI_bresp),
        .M00_AXI_bvalid     (M00_AXI_bvalid),
        .M00_AXI_rdata      (M00_AXI_rdata),
        .M00_AXI_rready     (M00_AXI_rready),
        .M00_AXI_rresp      (M00_AXI_rresp),
        .M00_AXI_rvalid     (M00_AXI_rvalid),
        .M00_AXI_wdata      (M00_AXI_wdata),
        .M00_AXI_wready     (M00_AXI_wready),
        .M00_AXI_wstrb      (M00_AXI_wstrb),
        .M00_AXI_wvalid     (M00_AXI_wvalid),
        .axi_aclk           (axi_aclk),
        .axi_aresetn        (axi_aresetn),
        //
        .usb_uart_rxd       (usb_uart_rxd),
        .usb_uart_txd       (usb_uart_txd),
        //
        .ddr4_act_n         (ddr4_act_n),
        .ddr4_adr           (ddr4_adr),
        .ddr4_ba            (ddr4_ba),
        .ddr4_bg            (ddr4_bg),
        .ddr4_ck_c          (ddr4_ck_c),
        .ddr4_ck_t          (ddr4_ck_t),
        .ddr4_cke           (ddr4_cke),
        .ddr4_cs_n          (ddr4_cs_n),
        .ddr4_dm_n          (ddr4_dm_n),
        .ddr4_dq            (ddr4_dq),
        .ddr4_dqs_c         (ddr4_dqs_c),
        .ddr4_dqs_t         (ddr4_dqs_t),
        .ddr4_odt           (ddr4_odt),
        .ddr4_reset_n       (ddr4_reset_n)        
    );

    // This register file gives software contol over unit under test (UUT).
    localparam int Nregs = 16;
    logic [Nregs-1:0][31:0] slv_reg, slv_read;

    assign slv_read[0] = 32'hdeadbeef;
    assign slv_read[1] = 32'h76543210;
    
    assign led         = slv_reg[2][1:0];
    assign slv_read[2] = slv_reg[2];
    
    assign slv_read[Nregs-1:3] = slv_reg[Nregs-1:3];

	axi_regfile_v1_0_S00_AXI #	(
		.C_S_AXI_DATA_WIDTH(32),
		.C_S_AXI_ADDR_WIDTH(6) // 16 32 bit registers.
	) axi_regfile_inst (
        // register interface
        .slv_read(slv_read), 
        .slv_reg (slv_reg),  
        // axi interface
		.S_AXI_ACLK    (axi_aclk),
		.S_AXI_ARESETN (axi_aresetn),
        //
		.S_AXI_ARADDR  (M00_AXI_araddr ),
		.S_AXI_ARPROT  (M00_AXI_arprot ),
		.S_AXI_ARREADY (M00_AXI_arready),
		.S_AXI_ARVALID (M00_AXI_arvalid),
		.S_AXI_AWADDR  (M00_AXI_awaddr ),
		.S_AXI_AWPROT  (M00_AXI_awprot ),
		.S_AXI_AWREADY (M00_AXI_awready),
		.S_AXI_AWVALID (M00_AXI_awvalid),
		.S_AXI_BREADY  (M00_AXI_bready ),
		.S_AXI_BRESP   (M00_AXI_bresp  ),
		.S_AXI_BVALID  (M00_AXI_bvalid ),
		.S_AXI_RDATA   (M00_AXI_rdata  ),
		.S_AXI_RREADY  (M00_AXI_rready ),
		.S_AXI_RRESP   (M00_AXI_rresp  ),
		.S_AXI_RVALID  (M00_AXI_rvalid ),
		.S_AXI_WDATA   (M00_AXI_wdata  ),
		.S_AXI_WREADY  (M00_AXI_wready ),
		.S_AXI_WSTRB   (M00_AXI_wstrb  ),
		.S_AXI_WVALID  (M00_AXI_wvalid )
	);

endmodule

