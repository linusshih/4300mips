`timescale 1ns / 1ps

module sim1;

   // Inputs
    reg clk;
    reg rst;
    reg ex_mem_pc_src;
    reg [31:0] ex_mem_npc;

    wire [31:0] if_id_instr;
    wire [31:0] if_id_npc;

  
    fetch dut(
        .clk(clk),
        .rst(rst),
        .ex_mem_pc_src(ex_mem_pc_src),
        .ex_mem_npc(ex_mem_npc),
        .if_id_instr(if_id_instr),
        .if_id_npc(if_id_npc)
    );
    initial clk = 0;
    always #5 clk = ~clk;
    initial begin
        rst = 1;
        ex_mem_pc_src = 0;
        ex_mem_npc = 32'b0;

        #15; 
        rst = 0;

        #200;
        
        ex_mem_npc = 32'h00000004;
        ex_mem_pc_src = 1;
        #20
        ex_mem_pc_src = 0;
        
        
    end

endmodule
