//
module vinstru (
    //
    input   logic               clk,
    input   logic               enable,
    //
    input   logic               run,
    output  logic               done,
    //
    input   logic[31:0]         pulse_period,
    input   logic[15:0]         pulse_width,
    input   logic[15:0]         pulse_amplitude,
    input   logic[15:0]         noise_amplitude,
    input   logic[15:0]         filter_bandwidth,
    //
    output  logic               tvalid,
    output  logic[31:0]         tdata,
    output  logic               tlast
);

    localparam int frame_length = 1024;

    // make 1/8 heartbeat so we can use the iir_filter
    logic heartbeat=0;
    logic[2:0] heart_count=0;
    always_ff @(posedge clk) begin
        heart_count <= heart_count - 1;
        heartbeat <= (0 == heart_count);
    end


    // make a periodic pulse
    logic[31:0] period_count=-1;
    logic period_tc=0;
    always_ff @(posedge clk) begin
        if (enable) begin
            if (heartbeat) begin
                if (period_count == 0) begin
                    period_count <= pulse_period;
                    period_tc <= 1;
                end else begin
                    period_count <= period_count - 1;
                    period_tc <= 0;
                end
            end
        end else begin
            period_count <= pulse_period;
            period_tc <= 0;
        end   
    end
    
    
    // generate pulse
    logic[15:0] pulse_count=-1;  
    logic[17:0] pulse=0;  
    always_ff @(posedge clk) begin
    
        if (enable) begin
        
            if (heartbeat) begin        
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
            end
            
        end else begin
        
            pulse_count <= pulse_width;
            pulse <= 0;
            
        end
        
    end

    
    // generate noise
    logic[7:0] del_reset = 8'hff;
    always_ff @(posedge clk) del_reset <= {1'b0, del_reset[7:1]};
    logic noise_dv_out;
    logic[15:0] noise_data_out;
    gng #( .INIT_Z1(64'd5030521883283424767), .INIT_Z2(64'd18445829279364155008), .INIT_Z3(64'd18436106298727503359))
        u_gng (.clk(clk), .rstn(~del_reset[0]), .ce(heartbeat), .valid_out(noise_dv_out), .data_out(noise_data_out));
        
        
    // sum pulse and noise
    logic[17:0] sum_data=0;
    always_ff @(posedge clk) begin
        if (noise_dv_out) sum_data <= $signed(pulse) + $signed(noise_data_out)*8;
    end
            
   
    // iir filter
    localparam int  Ncint  = 3;
    localparam int  Ncwidth = 18;
    localparam int  Ncfrac = Ncwidth - Ncint;
    localparam int  Nsos = 5;
    localparam real coeff[0:Nsos-1][0:5] =  '{
        '{ +0.002563476562, +0.005401611328, +0.002838134766, +1.000000000000, -1.803985595703, +0.813781738281 },
        '{ +0.002563476562, +0.005279541016, +0.002716064453, +1.000000000000, -1.818359375000, +0.828460693359 },
        '{ +0.002563476562, +0.005126953125, +0.002563476562, +1.000000000000, -1.852111816406, +0.862365722656 },
        '{ +0.002563476562, +0.004974365234, +0.002410888672, +1.000000000000, -1.899139404297, +0.909576416016 },
        '{ +0.002563476562, +0.004882812500, +0.002319335938, +1.000000000000, -1.957031250000, +0.967803955078 }
    };
    logic[17:0] filt_d_out;
    logic filt_dv_out;
    iir_filter #(.Ncint(Ncint), .Ncfrac(Ncfrac), .Nsos(Nsos), .coeff(coeff)) filter_inst (.clk(clk), .dv_in(heartbeat), .d_in(sum_data), .dv_out(filt_dv_out), .d_out(filt_d_out));


    // generate output frame
    logic[3:0] state=0, next_state;
    logic[15:0] data_count=0;
    logic data_count_clear, frame_enable;
    always_comb begin

        // defaults
        next_state = state;
        done = 0;
        data_count_clear = 0;
        frame_enable = 0;

        case (state)

            0: begin
                next_state = 1;
            end

            1: begin
                data_count_clear = 1;
                if (run) begin
                    next_state = 2;
                end
            end

            2: begin
                frame_enable = 1;
                if (data_count == frane_length) begin
                    next_state = 3;
                end
            end

            3: begin
                next_state = 4;
            end

            4: begin
                done = 1;
                if (~run) begin
                    next_state = 5;
                end
            end

            5: begin
                next_state = 1;
            end

            default: begin
                next_state = 0;
            end

        endcase

    end
    
    always_ff @(posedge clk) state <= next_state;

    assign tvalid = filt_dv_out & frame_enable;
    assign tdata  = $signed(filt_d_out);


    // count the data words
    always_ff @(posedge clk) begin
        if (data_count_clear) begin
            data_count <= 0;
        end else begin
            if (filt_dv_out) begin
                data_count <= data_count + 1;
            end
        end
    end

endmodule




