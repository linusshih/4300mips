`timescale 1ns / 1ps
/*
Implements a multiplexer that selects from two inputs (5 bits), a and b, based 
on the sel input. 
Its inputs are instrout_1511 and instrout_2016 from ID/EX latch, and regdst.
The output is muxout, which is sent to EX/MEM latch. 
*/
module bottom_mux(
    output wire [4:0] y,   // Output of multiplexer
    input  wire [4:0] a,   // Input 1 (when sel = 1)
    input  wire [4:0] b,   // Input 0 (when sel = 0)
    input  wire sel        // Select input
);

    assign y = sel ? a : b;

endmodule
