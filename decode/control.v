`timescale 1ns / 1ps

module control(
    input wire clk, rst,
    input wire [5:0] opcode,
    output reg [1:0] wb,
    output reg [2:0] mem,
    output reg [3:0] ex
);
    parameter RTYPE = 6'b000000;
    parameter LW = 6'b100011; //load word
    parameter SW = 6'b101011; //store word
    parameter BEQ = 6'b000100; //branch equal 
    parameter NOP = 6'b100000; //no op
    
    initial begin
        wb = 2'd0;
        mem = 3'd0;
        ex = 4'd0;
    end
    
    always @(posedge clk) begin
        if (rst) begin
            wb <= 2'd0;
            mem <= 3'd0;
            ex <= 4'd0;
        end
        case (opcode)
            RTYPE: begin
                wb <= 2'b10;
                mem <= 3'b000;
                ex <= 4'b1100;
            end
            
            LW: begin
                wb <= 2'b11;
                mem <= 3'b010;
                ex <= 4'b0001;
            end
            
            SW: begin
                wb <= 2'b00;
                mem <= 3'b001;
                ex <= 4'b0001;
            end
            
            BEQ: begin
                wb <= 2'b00;
                mem <= 3'b100;
                ex <= 4'b0100;
            end
            
            default: begin 
                wb <= 2'b0;
                mem <= 3'b0;
                ex <= 4'b0;
            end
        endcase
    end
endmodule
