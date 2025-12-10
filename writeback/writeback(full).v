`timescale 1ns / 1ps

module writeback(
    input  wire [1:0] mem_wb,          // {MemToReg, RegWrite}
    input  wire [31:0] read_data,
    input  wire [31:0] alu_result,
    output wire [31:0] writedata
);
    // mem_wb[1] = MemToReg
    wbmux muxwb(
        .a(read_data),
        .b(alu_result),
        .sel(mem_wb[1]),
        .y(writedata)
    );
endmodule

module wbmux(
    input  wire [31:0] a,   
    input  wire [31:0] b,   
    input  wire sel,
    output wire [31:0] y
);
    assign y = sel ? a : b;
endmodule

