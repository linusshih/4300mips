`timescale 1ns / 1ps
/*
EX/MEM pipeline register
Stores the outputs of the Execute stage into the MEM stage.
*/

module ex_mem(
    input  wire        clk,
    input  wire        reset,

    // incoming control and datapath signals from EXECUTE
    input  wire [1:0]  ctlwb_in,
    input  wire [2:0]  ctlm_in,
    input  wire [31:0] adder_in,
    input  wire        zero_in,
    input  wire [31:0] alu_in,
    input  wire [31:0] rdata2_in,
    input  wire [4:0]  mux_in,

    // registered outputs to MEM stage
    output reg [1:0]   ctlwb_out,
    output reg         branch,
    output reg         memread,
    output reg         memwrite,
    output reg [31:0]  add_result,
    output reg         zero,
    output reg [31:0]  alu_result,
    output reg [31:0]  rdata2_out,
    output reg [4:0]   five_bit_muxout
);

    // synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            ctlwb_out      <= 0;
            branch         <= 0;
            memread        <= 0;
            memwrite       <= 0;
            add_result     <= 0;
            zero           <= 0;
            alu_result     <= 0;
            rdata2_out     <= 0;
            five_bit_muxout<= 0;
        end 
        else begin
            ctlwb_out      <= ctlwb_in;
            branch         <= ctlm_in[2];
            memread        <= ctlm_in[1];
            memwrite       <= ctlm_in[0];
            add_result     <= adder_in;
            zero           <= zero_in;
            alu_result     <= alu_in;
            rdata2_out     <= rdata2_in;
            five_bit_muxout<= mux_in;
        end
    end
endmodule
