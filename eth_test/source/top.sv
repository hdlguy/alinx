//
module top (
    input   logic           clkin200_p, clkin200_n,
    //
    output  logic           led,
    //
    output  logic           fan_pwm,
    //
    output  logic           eth_mii_tx_clk,
    output  logic [3:0]     eth_mii_txd,
    output  logic           eth_mii_tx_ctl,
    
    input   logic           eth_mii_rx_clk,
    input   logic [3:0]     eth_mii_rxd,
    input   logic           eth_mii_rx_ctl,

    output  logic           eth_mii_rst_n    
);

    logic clk125, clk125_90, locked;
    clkgen clkgen_inst (.clkin200_p(clkin200_p), .clkin200_n(clkin200_n), .clk125(clk125), .clk125_90(clk125_90), .locked(locked));

    logic[26:0] led_count=0;
    logic[7:0] reset_count=-1;
    logic reset = 1;
    always_ff @(posedge clk125) begin
        led_count <= led_count + 1;
        led <= led_count[25];
        fan_pwm <= led_count[17] & led_count[16] & led_count[15];
        if (~locked) begin
            reset_count <= -1;
            reset <= 1;
        end else begin
            if (reset_count != 0) begin
                reset_count <= reset_count - 1;
                reset <= 1;
            end else begin
                reset <= 0;
            end
        end
    end

    fpga_core #(
        .TARGET("XILINX")
    ) core_inst (
        // * Clock: 125MHz
        .clk(clk125),
        .clk90(clk125_90),
        .rst(reset),
        // * GPIO
        .btnu(0),
        .btnl(0),
        .btnd(0),
        .btnr(0),
        .btnc(0),
        .sw(0),
        .led(),
        // * Ethernet: 1000BASE-T RGMII
        .phy_rx_clk     (eth_mii_rx_clk),
        .phy_rxd        (eth_mii_rxd),
        .phy_rx_ctl     (eth_mii_rx_ctl),
        .phy_tx_clk     (eth_mii_tx_clk),
        .phy_txd        (eth_mii_txd),
        .phy_tx_ctl     (eth_mii_tx_ctl),
        .phy_reset_n    (eth_mii_rst_n),
        .phy_int_n      (1'b0),
        // * UART: 115200 bps, 8N1
        .uart_rxd(uart_rxd_int),
        .uart_txd(uart_txd),
        .uart_rts(uart_rts),
        .uart_cts(uart_cts_int)
    );

endmodule

/*   
*/
