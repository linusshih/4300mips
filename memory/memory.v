`timescale 1ns / 1ps

module memory(
    input  wire        clk,
    input  wire [31:0] ALUResult,
    input  wire [31:0] WriteData,
    input  wire [4:0]  WriteReg,
    input  wire [1:0]  WBControl,
    input  wire        MemWrite,
    input  wire        MemRead,
    input  wire        Branch,
    input  wire        Zero,

    output wire [31:0] ReadData,
    output wire [31:0] ALUResult_out,
    output wire [4:0]  WriteReg_out,
    output wire [1:0]  WBControl_out,
    output wire        PCSrc
);

    // Internal wire for data read from memory
    wire [31:0] read_in;

    // AND gate for branch logic
    AND andmem (
        .A(Branch),
        .B(Zero),
        .Y(PCSrc)
    );

    // Data memory
    data_memory dm (
        .clk(clk),
        .addr(ALUResult),
        .write_data(WriteData),
        .memwrite(MemWrite),
        .memread(MemRead),
        .read_data(read_in)
    );

    // MEM/WB latch
    mem_wb memwb (
        .clk(clk),
        .WBControl(WBControl),
        .ReadData_in(read_in),
        .ALUResult_in(ALUResult),
        .WriteReg_in(WriteReg),
        .regwrite(WBControl_out[1]),    // MSB of WBControl
        .memtoreg(WBControl_out[0]),    // LSB of WBControl
        .ReadData_out(ReadData),
        .ALUResult_out(ALUResult_out),
        .WriteReg_out(WriteReg_out)
    );

endmodule
