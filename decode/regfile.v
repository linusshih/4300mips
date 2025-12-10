`timescale 1ns / 1ps

module regfile(
    input wire clk, rst, regwrite, 
    input wire [4:0] rs, rt, rd,
    input wire [31:0] writedata,
    output reg [31:0] A_readdat1, B_readdat2   
);

    reg [31:0] REG [0:31];
    
    initial begin
        REG[0] = 32'h002300AA;
        REG[1] = 32'h10654321;
        REG[2] = 32'h00100022;
        REG[3] = 32'h8C123456;
        REG[4] = 32'h8F123456;
        REG[5] = 32'hAD654321;
        REG[6] = 32'h60000066;
        REG[7] = 32'h13012345;
        REG[8] = 32'hAC654321;
        REG[9] = 32'h12012345;
    end
    
    always @(posedge clk) begin
        if (rst) begin
            A_readdat1 <= 32'b0;
            B_readdat2 <= 32'b0;
        end
        else begin
            if (regwrite) begin
            //overwrite the value location rd within reg with writedata
                REG[rd] <= writedata;
            end
            else begin
                //set A_readdat1 to the value at location rs within REG
                A_readdat1 <= REG[rs];
                //set B_readdat2 to the value at location rt within REG
                B_readdat2 <= REG[rt];
            end 
        end
    end
    
endmodule
