`timescale 1ns / 1ps

module vinstru_tb ();

    localparam int Wdata = 8;
    localparam int Wdepth = 2**10;
    
    logic               enable;
    logic[31:0]         pulse_period;
    logic[15:0]         pulse_width;
    logic[15:0]         pulse_amplitude;
    logic[15:0]         noise_amplitude;
    logic[15:0]         filter_bandwidth;
    logic               tvalid, tlast;
    logic[Wdata-1:0]    tdata;

    localparam time clk_period = 10; logic clk=0; always #(clk_period/2) clk=~clk;

    vinstru #(.Wdata(Wdata), .Wdepth(Wdepth)) uut (.*);
    
    initial begin
    
        enable = 0;
        pulse_period = 10000-1;
        pulse_width = 1000;
        pulse_amplitude = 30000;
        noise_amplitude = 10;
        filter_bandwidth = 0;
        #(clk_period*1000);
        
        enable = 1;
        
    end

endmodule



/*

*/
