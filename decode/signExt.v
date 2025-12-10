`timescale 1ns / 1ps

module signExt(
    input wire [15:0] immediate,
    output wire [31:0] extended
);

    assign extended = {{16{immediate[15]}}, immediate};
endmodule
