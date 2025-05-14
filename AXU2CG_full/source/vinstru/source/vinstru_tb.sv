`timescale 1ns / 1ps

module vinstru_tb ();

    localparam int Wdata = 8;
    localparam int Wdepth = 2**10;
    
    input   logic               enable;
    input   logic[31:0]         pulse_period;
    input   logic[15:0]         pulse_width;
    input   logic[15:0]         pulse_amplitude;
    input   logic[15:0]         noise_amplitude;
    input   logic[15:0]         filter_bandwidth;
    output  logic               dv_out;
    output  logic[Wdata-1:0]    d_out;

    localparam time clk_period = 10; logic clk=0; always #(clk_period/2) clk=~clk;

    vinstru #(.Wdata(Wdata), .Wdepth(Wdepth)) uut (.*);

endmodule



/*
module vinstru #(
    parameter int Wdata = 8,
    parameter int Wdepth = 2**10
) (
    //
    input   logic               clk,
    input   logic               enable,
    //
    input   logic[31:0]         pulse_period,
    input   logic[15:0]         pulse_width,
    input   logic[15:0]         pulse_amplitude,
    input   logic[15:0]         noise_amplitude,
    input   logic[15:0]         filter_bandwidth,
    //
    output  logic               dv_out,
    output  logic[Wdata-1:0]    d_out
);

    // make a periodic pulse
*/
