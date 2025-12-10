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
