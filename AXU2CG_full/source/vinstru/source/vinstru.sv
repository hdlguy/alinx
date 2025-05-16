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

    logic trigger, source_dv_out;
    logic[17:0] source_d_out;
    vsource vsource_inst (
        .clk(clk),
        .enable(enable),
        .pulse_period(pulse_period),
        .pulse_width(pulse_width),
        .pulse_amplitude(pulse_amplitude),
        .noise_amplitude(noise_amplitude),
        .trig_out(trigger),
        .dv_out(source_dv_out),
        .d_out(source_d_out)
    );

endmodule


/*
    localparam int frame_length = 1024;

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
*/



