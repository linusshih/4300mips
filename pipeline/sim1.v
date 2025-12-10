`timescale 1ns / 1ps

module pipeline_tb;

    reg clk, reset;
    wire [31:0] r1, r2, r3;



    // existing pipeline debug wires
    wire [31:0] dbg_ifid_instr;
    wire [1:0]  dbg_idex_wb, dbg_exmem_wb, dbg_memwb_wb;
    wire        dbg_wb_regwrite;
    wire [4:0]  dbg_wb_dest;
    wire [31:0] dbg_wb_data;

    pipeline dut (
        .clk(clk),
        .reset(reset),
        .r1(r1),
        .r2(r2),
        .r3(r3),

        // existing debug ports
        .dbg_ifid_instr (dbg_ifid_instr),
        .dbg_idex_wb    (dbg_idex_wb),
        .dbg_exmem_wb   (dbg_exmem_wb),
        .dbg_memwb_wb   (dbg_memwb_wb),
        .dbg_wb_regwrite(dbg_wb_regwrite),
        .dbg_wb_dest    (dbg_wb_dest),
        .dbg_wb_data    (dbg_wb_data)
    );

    // clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns period
    end

    // reset and run
    initial begin
        reset = 1;
        #20;         // hold reset
        reset = 0;
        #240;        // ~24 cycles
        $finish;
    end

endmodule
