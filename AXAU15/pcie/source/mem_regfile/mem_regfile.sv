// This module implements a register file to be controlled by an AXI Bram Controller.
// The bram controller goes inside the IPI block diagram so that addresses are reported in the XSA file.
// This module is instantiated in the Verilog code so that two dimensional arrays can be used in the application interface.
//
module mem_regfile #(
    parameter int                       Naddr = 4,      // register address (not byte address) 
    parameter int                       Nregs = 2**Naddr,
    parameter logic[Nregs-1:0][31:0]    init_reg = 0
) (
    // interface to bram controller
    input   logic                   clk,
    input   logic[Naddr-1:0]        addr,
    input   logic[31:0]             wr_data,
    output  logic[31:0]             rd_data,
    input   logic                   en,
    input   logic                   rst,
    input   logic[3:0]              we,
    // interface to application
    output  logic[Nregs-1:0][31:0]  reg_val,    // current register value
    output  logic[Nregs-1:0][31:0]  pul_val,    // single cycle pulse for any bits written as 1. (self-clearing)
    input   logic[Nregs-1:0][31:0]  read_val    // array of values that can be read back.
);


    logic[Nregs-1:0][31:0] reg_val_int = init_reg;
    logic[Nregs-1:0][31:0] pul_val_int = 0;
    always_ff @(posedge clk) begin

        if (rst) begin
            reg_val_int <= init_reg;
            pul_val_int <= 0;
        end else begin
            // read
            if (en) begin
                rd_data <= read_val[addr];
            end
            // write
            if ((we[0]) && (en)) reg_val_int[addr][ 7: 0] <= wr_data[ 7: 0];
            if ((we[1]) && (en)) reg_val_int[addr][15: 8] <= wr_data[15: 8];
            if ((we[2]) && (en)) reg_val_int[addr][23:16] <= wr_data[23:16];
            if ((we[3]) && (en)) reg_val_int[addr][31:24] <= wr_data[31:24];
            // pulse
            if ((we[0]) && (en)) begin pul_val_int[addr][ 7: 0] <= wr_data[ 7: 0]; end else begin pul_val_int[addr][ 7: 0] <= 0; end
            if ((we[1]) && (en)) begin pul_val_int[addr][15: 8] <= wr_data[15: 8]; end else begin pul_val_int[addr][15: 8] <= 0; end
            if ((we[2]) && (en)) begin pul_val_int[addr][23:16] <= wr_data[23:16]; end else begin pul_val_int[addr][23:16] <= 0; end
            if ((we[3]) && (en)) begin pul_val_int[addr][31:24] <= wr_data[31:24]; end else begin pul_val_int[addr][31:24] <= 0; end
        end
    
    end

    assign reg_val = reg_val_int;
    assign pul_val = pul_val_int;


endmodule

