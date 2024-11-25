`timescale 0.1ns / 1ps

module top_tb ();

    logic           clkin200_p, clkin200_n;
    logic           led;
    logic           fan_pwm;
    logic           eth_mii_tx_clk;
    logic [3:0]     eth_mii_txd;
    logic           eth_mii_tx_ctl;
    logic           eth_mii_rx_clk;
    logic [3:0]     eth_mii_rxd;
    logic           eth_mii_rx_ctl;
    logic           eth_mii_rst_n;  

    logic clk = 0; localparam time clk_period = 50; always #(clk_period/2) clk = ~clk; // 100ps increments
    assign clkin200_p =  clk;
    assign clkin200_n = ~clk;
    
    assign eth_mii_rx_clk = eth_mii_tx_clk;

    top uut (.*);

endmodule

/*
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
*/


