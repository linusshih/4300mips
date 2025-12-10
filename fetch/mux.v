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
