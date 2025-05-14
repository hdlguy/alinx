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
    output  logic               tvalid,
    output  logic[Wdata-1:0]    tdata,
    output  logic               tlast
);

    // make a periodic pulse
    logic[31:0] period_count=-1;
    logic period_tc=0;
    always_ff @(posedge clk) begin
        if (enable) begin
            if (period_count == 0) begin
                period_count <= pulse_period;
                period_tc <= 1;
            end else begin
                period_count <= period_count - 1;
                period_tc <= 0;
            end
        end else begin
            period_count <= pulse_period;
            period_tc <= 0;
        end   
    end
    
    
    // generate pulse
    logic[15:0] pulse_count=-1;  
    logic[15:0] pulse=0;  
    always_ff @(posedge clk) begin
    
        if (enable) begin
        
            if (period_tc) begin
                pulse_count <= pulse_width;
            end else begin
                if (pulse_count == 0) begin
                    pulse <= 0;
                end else begin
                    pulse_count <= pulse_count - 1;
                    pulse <= pulse_amplitude;
                end
            end
            
        end else begin
        
            pulse_count <= pulse_width;
            pulse <= 0;
            
        end
        
    end        

endmodule

