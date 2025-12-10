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
);

    always @(posedge clk) begin
        memtoreg      <= WBControl[1]; 
        regwrite      <= WBControl[0]; 
        ReadData_out  <= ReadData_in;
        ALUResult_out <= ALUResult_in;
        WriteReg_out  <= WriteReg_in;
    end

endmodule
