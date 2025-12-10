`timescale 1ns / 1ps

module fetch(
    input wire clk,
    input wire rst,
    input wire ex_mem_pc_src,
    input wire [31:0] ex_mem_npc,
    output wire [31:0] if_id_instr,
    output wire [31:0] if_id_npc
);

    wire [31:0] pc_out, pc_mux, next_pc, instr_data;

    mux m0(.a_true(ex_mem_npc), .b_false(next_pc), .sel(ex_mem_pc_src), .y(pc_mux));
    pc pc0(.clk(clk), .rst(rst), .pc_in(pc_mux), .pc_out(pc_out));
    incrementer in0(.clk(clk), .rst(rst), .pcin(pc_out), .pcout(next_pc));
    instrMem inMem0(.clk(clk), .rst(rst), .addr(pc_out), .data(instr_data));
    ifIdLatch ifIdLatch0(.clk(clk), .rst(rst), .pc_in(pc_out), .instr_in(instr_data), .pc_out(if_id_npc), .instr_out(if_id_instr));

endmodule


module ifIdLatch(
    input wire clk,
    input wire rst,
    input wire [31:0] pc_in,
    input wire [31:0] instr_in,
    output reg [31:0] pc_out,
    output reg [31:0] instr_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin  
            pc_out <= 32'b0;
            instr_out <= 32'b0;
        end else begin
            pc_out <= pc_in;
            instr_out <= instr_in;
        end
    end
endmodule

module mux (
    input wire [31:0] a_true,
    input wire [31:0] b_false,
    input wire sel,
    output reg [31:0] y
);
    always @(*) begin
        if (sel)
            y = a_true;
        else
            y = b_false;
    end
endmodule

module pc (
    input wire clk,
    input wire rst,
    input wire [31:0] pc_in,
    output reg [31:0] pc_out
);
    always @(posedge clk) begin
        if (rst)
            pc_out <= 32'b0;
        else
            pc_out <= pc_in;
    end
endmodule

module incrementer ( //(adder)
    input wire clk,
    input wire rst,
    input wire [31:0] pcin,
    output reg [31:0] pcout
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            pcout <= 32'b0;
        else
            pcout <= pcin + 32'd4;
    end
endmodule

module instrMem (
    input wire clk,
    input wire rst,
    input wire [31:0] addr,
    output reg [31:0] data
);
    //reg [31:0] mem [0:(2**32)-1];
    reg [31:0] mem [0:31];

    initial begin
        mem[0]  = 32'b10001100000000010000000000000001;
        mem[1]  = 32'b10001100000000100000000000000010;
        mem[2]  = 32'b10001100000000110000000000000011;
        mem[3]  = 32'b10000000000000000000000000000000;
        mem[4]  = 32'b10000000000000000000000000000000;
        mem[5]  = 32'b00000000001000100000100000100000;
        mem[6]  = 32'b10000000000000000000000000000000;
        mem[7]  = 32'b10000000000000000000000000000000;
        mem[8]  = 32'b10000000000000000000000000000000;
        mem[9]  = 32'b00000000001000110000100000100000;
        mem[10] = 32'b10000000000000000000000000000000;
        mem[11] = 32'b10000000000000000000000000000000;
        mem[12] = 32'b10000000000000000000000000000000;
        mem[13] = 32'b00000000001000010000100000100000;
        mem[14] = 32'b10000000000000000000000000000000;
        mem[15] = 32'b10000000000000000000000000000000;
        mem[16] = 32'b10000000000000000000000000000000;
        mem[17] = 32'b10000000000000000000000000000000;
        mem[18] = 32'b00000000001000000000100000100000;
        mem[19] = 32'b10000000000000000000000000000000;
        mem[20] = 32'b10000000000000000000000000000000;
        mem[21] = 32'b10000000000000000000000000000000;
        mem[22] = 32'b10000000000000000000000000000000;
        mem[23] = 32'b10000000000000000000000000000000;
    end

    always @(*) begin
        data = mem[addr[31:2]];
    end
endmodule

