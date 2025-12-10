`timescale 1ns / 1ps
/*
MIPS ALU
Performs arithmetic and logical operations based on 3-bit ALU control.
Zero output is asserted when result = 0.
*/

module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [2:0]  control,
    output reg  [31:0] result,
    output wire        zero
);

    // ALU operation codes (match alu_control)
    localparam ALU_AND = 3'b000;
    localparam ALU_OR  = 3'b001;
    localparam ALU_ADD = 3'b010;
    localparam ALU_X   = 3'b011;     // unused/don't care
    localparam ALU_SUB = 3'b110;
    localparam ALU_SLT = 3'b111;

    always @(*) begin
        case (control)

            ALU_AND: result = a & b;
            ALU_OR:  result = a | b;
            ALU_ADD: result = a + b;
            ALU_SUB: result = a - b;

            // Proper signed SLT (set-on-less-than)
            ALU_SLT: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;

            default: result = 32'hXXXXXXXX;
        endcase
    end

    // Zero flag
    assign zero = (result == 32'd0);

endmodule
