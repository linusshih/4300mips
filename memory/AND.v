`timescale 1ns / 1ps


module AND(
    input wire A,
    input wire B,
    output wire Y
);
    assign Y = A & B;
endmodule
