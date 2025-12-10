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

 
    wire [31:0] read_in;

 
    assign PCSrc = Branch & Zero;
    
    data_memory dm (
        .clk       (clk),
        .addr      (ALUResult),
        .write_data(WriteData),
        .memwrite  (MemWrite),
        .memread   (MemRead),
        .read_data (read_in)
    );


    wire regwrite_wb;
    wire memtoreg_wb;

    mem_wb memwb (
        .clk          (clk),
        .WBControl    (WBControl),     
        .ReadData_in  (read_in),
        .ALUResult_in (ALUResult),
        .WriteReg_in  (WriteReg),

        .regwrite     (regwrite_wb),   
        .memtoreg     (memtoreg_wb),   
        .ReadData_out (ReadData)
        .ALUResult_out(ALUResult_out),
        .WriteReg_out (WriteReg_out)
    );


    assign WBControl_out = {memtoreg_wb, regwrite_wb};

endmodule


module data_memory(
    input  wire        clk,
    input  wire [31:0] addr,        
    input  wire [31:0] write_data,  
    input  wire        memwrite,    
    input  wire        memread,     
    output reg  [31:0] read_data    
);

    // simple 256 x 32-bit data memory
    reg [31:0] data_mem [0:255];

    integer i;
    initial begin
        data_mem[0] = 32'b00000000000000000000000000000000;
        data_mem[1] = 32'b00000000000000000000000000000001;
        data_mem[2] = 32'b00000000000000000000000000000010;
        data_mem[3] = 32'b00000000000000000000000000000011;
        data_mem[4] = 32'b00000000000000000000000000000100;
        data_mem[5] = 32'b00000000000000000000000000000101;

        for (i = 6; i < 256; i = i + 1)
            data_mem[i] = 32'h0;
    end

    always @(posedge clk) begin
        if (memwrite)
            data_mem[addr[9:2]] <= write_data;  
    end

    always @(*) begin
        if (memread)
            read_data = data_mem[addr[9:2]];
        else
            read_data = 32'b0;
    end

endmodule


module mem_wb(
    input  wire        clk,
    input  wire [1:0]  WBControl,      
    input  wire [31:0] ReadData_in,    
    input  wire [31:0] ALUResult_in,   
    input  wire [4:0]  WriteReg_in,    

    output reg         regwrite,       
    output reg         memtoreg,       
    output reg [31:0]  ReadData_out,   
    output reg [31:0]  ALUResult_out,  
    output reg [4:0]   WriteReg_out    
)

    always @(posedge clk) begi
        memtoreg      <= WBControl[1]; 
        regwrite      <= WBControl[0]; 
        ReadData_out  <= ReadData_in;
        ALUResult_out <= ALUResult_in;
        WriteReg_out  <= WriteReg_in;
    end

endmodule
