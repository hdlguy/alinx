//
module top (
    input   logic           clkin200_p, clkin200_n,
    //
    output  logic           led,
    //
    output  logic           fan_pwm,
    //
    input   logic           eth_mii_tx_clk,
    output  logic [3:0]     eth_mii_txd,
    output  logic           eth_mii_tx_ctl,
    
    input   logic           eth_mii_rx_clk,
    input   logic [3:0]     eth_mii_rxd,
    input   logic           eth_mii_rx_ctl,

    output  logic           eth_mii_rst_n    
);

    // let us use the 200MHz differential clock
    logic clkin200, clk200;
    IBUFDS IBUFDS_inst (.O(clkin200 ), .I(clkin200_p),  .IB(clkin200_n));
    BUFG BUFG_inst (.O(clk200), .I(clkin200));
    
    logic clk300_int, clk300, clk125_int, clk125, clk125_90_int, clk125_90;
    MMCME3_BASE #(
          .BANDWIDTH("OPTIMIZED"),    // Jitter programming (HIGH, LOW, OPTIMIZED)
          .CLKFBOUT_MULT_F(5.0),      // 5*200=1000MHz
          .CLKFBOUT_PHASE(0.0),       // Phase offset in degrees of CLKFB (-360.000-360.000)
          .CLKIN1_PERIOD(5.000),      // 200MHz
          .CLKOUT0_DUTY_CYCLE(0.5),
          .CLKOUT1_DUTY_CYCLE(0.5),
          .CLKOUT2_DUTY_CYCLE(0.5),
          .CLKOUT3_DUTY_CYCLE(0.5),
          .CLKOUT4_DUTY_CYCLE(0.5),
          .CLKOUT5_DUTY_CYCLE(0.5),
          .CLKOUT6_DUTY_CYCLE(0.5),
          .CLKOUT0_PHASE(0.0),
          .CLKOUT1_PHASE(0.0),
          .CLKOUT2_PHASE(90.0), //
          .CLKOUT3_PHASE(0.0),
          .CLKOUT4_PHASE(0.0),
          .CLKOUT5_PHASE(0.0),
          .CLKOUT6_PHASE(0.0),
          .CLKOUT0_DIVIDE_F(26*0.125),   // 1000/(26*0.125) = 307.6923076923077
          .CLKOUT1_DIVIDE(8),
          .CLKOUT2_DIVIDE(8),
          .CLKOUT3_DIVIDE(1),
          .CLKOUT4_DIVIDE(1),
          .CLKOUT5_DIVIDE(1),
          .CLKOUT6_DIVIDE(1),
          .CLKOUT4_CASCADE("FALSE"),  // Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
          .DIVCLK_DIVIDE(1),          // Master division value (1-106)
          .IS_CLKFBIN_INVERTED(1'b0), // Optional inversion for CLKFBIN
          .IS_CLKIN1_INVERTED(1'b0),  // Optional inversion for CLKIN1
          .IS_PWRDWN_INVERTED(1'b0),  // Optional inversion for PWRDWN
          .IS_RST_INVERTED(1'b0),     // Optional inversion for RST
          .REF_JITTER1(0.0),          // Reference input jitter in UI (0.000-0.999)
          .STARTUP_WAIT("FALSE")      // Delays DONE until MMCM is locked (FALSE, TRUE)
    ) MMCME3_BASE_inst (
          .CLKOUT0(clk300_int),  // 300MHz
          .CLKOUT0B(),
          .CLKOUT1(clk125_int),  // 125MHz
          .CLKOUT1B(),
          .CLKOUT2(clk125_90_int),  // 125MHz, 90 degrees
          .CLKOUT2B(),
          .CLKOUT3(),  
          .CLKOUT3B(),
          .CLKOUT4(),  
          .CLKOUT5(),  
          .CLKOUT6(),  
          .CLKFBOUT(mmcm_clkfb),   // 1-bit output: Feedback clock
          .CLKFBOUTB(), // 1-bit output: Inverted CLKFBOUT
          .LOCKED(),       // 1-bit output: LOCK
          .CLKIN1(clk200),       // 1-bit input: Clock
          .PWRDWN(1'b0),       // 1-bit input: Power-down
          .RST(1'b0),             // 1-bit input: Reset
          .CLKFBIN(mmcm_clkfb)      // 1-bit input: Feedback clock
    );    
    
    BUFG BUFG_300    (.O(clk300), .I(clk300_int));
    BUFG BUFG_125    (.O(clk125), .I(clk125_int));
    BUFG BUFG_125_90 (.O(clk125_90), .I(clk125_90_int));            
    

    logic[26:0] led_count;
    logic[7:0] reset_count=-1;
    logic reset = 1;
    always_ff @(posedge clk125) begin
        led_count <= led_count + 1;
        led <= led_count[25];
        fan_pwm <= led_count[17] & led_count[16] & led_count[15];
        if (reset_count != 0) begin
            reset_count <= reset_count - 1;
            reset <= 1;
        end else begin
            reset <= 0;
        end
    end

    fpga_core #(
        .TARGET("XILINX")
    ) core_inst (
        // * Clock: 125MHz
        .clk(clk125),
        .clk90(clk125_90),
        .rst(reset),  // * Synchronous reset
        // * GPIO
        .btnu(0),
        .btnl(0),
        .btnd(0),
        .btnr(0),
        .btnc(0),
        .sw(0),
        .led(),
        // * Ethernet: 1000BASE-T RGMII
        .phy_rx_clk(phy_rx_clk),
        .phy_rxd(phy_rxd_delay),
        .phy_rx_ctl(phy_rx_ctl_delay),
        .phy_tx_clk(phy_tx_clk),
        .phy_txd(phy_txd),
        .phy_tx_ctl(phy_tx_ctl),
        .phy_reset_n(phy_reset_n),
        .phy_int_n(phy_int_n),
        // * UART: 115200 bps, 8N1
        .uart_rxd(uart_rxd_int),
        .uart_txd(uart_txd),
        .uart_rts(uart_rts),
        .uart_cts(uart_cts_int)
    );

endmodule

/*   
*/