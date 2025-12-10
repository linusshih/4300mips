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
