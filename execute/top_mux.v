`timescale 1ns / 1ps
/*
Implements a multiplexer that selects from two 32-bit inputs, a and b, based on sel.
Used in the Execute stage to choose between register data and sign-extended immediate.
Its output goes into the ALU as input "b".
*/
module top_mux(
    output wire [31:0] y,   // Output of multiplexer
    input  wire [31:0] a,   // Input when sel = 1
    input  wire [31:0] b,   // Input when sel = 0
    input  wire sel         // Select signal
);

    assign y = sel ? a : b;

endmodule
