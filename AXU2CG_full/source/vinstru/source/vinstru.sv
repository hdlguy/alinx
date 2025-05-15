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
                    pulse <= $signed(pulse_amplitude);
                end
            end
            
        end else begin
        
            pulse_count <= pulse_width;
            pulse <= 0;
            
        end
        
    end        
    
    // format short; clear; N=32; W=0.25; Bc=18; b=fir1(N,W,"low"); cq=round(b*(2.0^(Bc-1))); for i=1:N+1 printf("%d, ",cq(i)) endfor; printf("\n");
    logic[39:0] m_axis_data_tdata;
    fir_core your_instance_name (.aclk(clk), .s_axis_data_tvalid(1'b1), .s_axis_data_tready(), .s_axis_data_tdata(pulse), .m_axis_data_tvalid(), .m_axis_data_tdata(m_axis_data_tdata));
    logic[15:0] fir_data;
    assign fir_data = m_axis_data_tdata[17+:16];




endmodule


//    // iir filter
//    localparam int  Ncint  = 3;
//    localparam int  Ncwidth = 18;
//    localparam int  Ncfrac = Ncwidth - Ncint;
//    localparam int  Nsos = 5;
//    localparam real coeff[0:Nsos-1][0:5] =  '{
//        '{ +0.002563476562, +0.005401611328, +0.002838134766, +1.000000000000, -1.803985595703, +0.813781738281 },
//        '{ +0.002563476562, +0.005279541016, +0.002716064453, +1.000000000000, -1.818359375000, +0.828460693359 },
//        '{ +0.002563476562, +0.005126953125, +0.002563476562, +1.000000000000, -1.852111816406, +0.862365722656 },
//        '{ +0.002563476562, +0.004974365234, +0.002410888672, +1.000000000000, -1.899139404297, +0.909576416016 },
//        '{ +0.002563476562, +0.004882812500, +0.002319335938, +1.000000000000, -1.957031250000, +0.967803955078 }
//    };
//    logic[17:0] filt_dout;
//    iir_filter #(.Ncint(Ncint), .Ncfrac(Ncfrac), .Nsos(Nsos), .coeff(coeff)) filter_inst (.clk(clk), .dv_in(1'b1), .d_in(pulse), .dv_out(), .d_out(filt_dout));


