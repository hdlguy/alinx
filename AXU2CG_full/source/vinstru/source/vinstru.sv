//
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
    logic[31:0] period_count=-1;
    logic period_tc=0;
    always_ff @(posedge clk) begin
        if (0 == enable) begin
            period_count <= pulse_period;
            period_tc <= 0;
        end else begin
            if (period_count == 0) begin
                period_count <= pulse_period;
                period_tc <= 1;
            end else begin
                period_count <= period_count - 1;
                period_tc <= 0;
            end
        end   
    end

endmodule

