`timescale 1ns / 1ps
/*
ALU Control Unit
Determines the 3-bit ALU control signal from:
- aluop (from main control unit)
- funct  (for R-type)
*/

module alu_control(
    input  wire [5:0] funct,
    input  wire [1:0] aluop,
    output reg  [2:0] select
);

    // ALUOp encodings (from main control unit)
    localparam Rtype  = 2'b10;    // use funct field
    localparam LW_SW  = 2'b00;    // load/store ? add
    localparam BEQ    = 2'b01;    // beq ? subtract
    localparam UNKNOWN= 2'b11;    // invalid / don't care

    // ALU control outputs
    localparam ALU_AND = 3'b000;
    localparam ALU_OR  = 3'b001;
    localparam ALU_ADD = 3'b010;
    localparam ALU_SUB = 3'b110;
    localparam ALU_SLT = 3'b111;
    localparam ALU_X   = 3'b011;   // undefined operation

    // R-type funct field encodings
    localparam FUNCT_ADD = 6'b100000;
    localparam FUNCT_SUB = 6'b100010;
    localparam FUNCT_AND = 6'b100100;
    localparam FUNCT_OR  = 6'b100101;
    localparam FUNCT_SLT = 6'b101010;

    always @(*) begin
        case (aluop)

            // R-type ? decode using funct field
            Rtype: begin
                case (funct)
                    FUNCT_ADD: select = ALU_ADD;
                    FUNCT_SUB: select = ALU_SUB;
                    FUNCT_AND: select = ALU_AND;
                    FUNCT_OR:  select = ALU_OR;
                    FUNCT_SLT: select = ALU_SLT;
                    default:    select = ALU_X;
                endcase
            end

            // LW, SW
            LW_SW: select = ALU_ADD;

            // BEQ
            BEQ:   select = ALU_SUB;

            // Unknown ALUOp ? don't care operation
            UNKNOWN: select = ALU_X;

            // Safety default
            default: select = ALU_X;
        endcase
    end
endmodule
