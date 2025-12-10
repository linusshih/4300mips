`timescale 1ns / 1ps
/*
 Execute stage for MIPS pipeline (EX)
 - This module is combinational logic + an EX/MEM pipeline register (ex_mem).
 - Assumes the submodules have the conventional ports shown below.
*/

module EXECUTE(
    input  wire        clk,            // clock for EX/MEM register (added)
    input  wire        reset,          // synchronous reset for EX/MEM (added)

    // control signals coming from ID/EX
    input  wire [1:0]  wb_ctl,         // writeback control (to EX/MEM register)
    input  wire [2:0]  m_ctl,          // memory control (to EX/MEM register)
    input  wire        regdst,         // choose rd or rt for destination register
    input  wire        alusrc,         // choose immediate (sign-extend) or rt for ALU b input
    input  wire [1:0]  aluop,          // ALU operation (to ALU control)

    // datapath inputs
    input  wire [31:0] npcout,         // PC+4 from ID/EX (for branch target adder)
    input  wire [31:0] rdata1,         // register file read data 1
    input  wire [31:0] rdata2,         // register file read data 2
    input  wire [31:0] s_extendout,    // sign-extended immediate (32-bit)
    input  wire [4:0]  instrout_2016,  // rt field (bits 20:16)
    input  wire [4:0]  instrout_1511,  // rd field (bits 15:11)
    input  wire [5:0]  funct,          // funct field (bits 5:0) for R-type ALU control

    // outputs (these come from EX/MEM register outputs)
    output wire [1:0]  wb_ctlout,      // writeback control forwarded to EX/MEM
    output wire        branch,
    output wire        memread,
    output wire        memwrite,
    output wire [31:0] EX_MEM_NPC,     // branch target (PC + sign_ext_imm<<2)
    output wire        zero,
    output wire [31:0] alu_result,
    output wire [31:0] rdata2out,      // forwarded rdata2 (for store)
    output wire [4:0]  five_bit_muxout // destination register (rt or rd)
);

// Internal wires
wire [31:0] shifted_imm;   // immediate << 2 for branch target
wire [31:0] adder_out;     // PC + (imm << 2)
wire [31:0] b_input;       // ALU second operand (either rdata2 or sign-ext immed)
wire [31:0] aluout;
wire [4:0]  reg_mux_out;
wire [2:0]  alu_ctrl;
wire        aluzero;

// shift left 2 the sign-extended immediate to form branch offset
assign shifted_imm = s_extendout << 2;

// adder: branch target = npcout + (immediate << 2)
adder adder3 (
    .add_in1(npcout),
    .add_in2(shifted_imm),
    .add_out(adder_out)
);

// destination register mux: if regdst == 1 choose rd (instr[15:11]), else choose rt (instr[20:16])
// I use named ports below to avoid ambiguity; if your bottom_mux has a different port naming adapt accordingly.
bottom_mux bottom_mux3 (
    .a(instrout_2016),   // typical naming: rt = bits 20:16
    .b(instrout_1511),   // rd = bits 15:11
    .sel(regdst),
    .y(reg_mux_out)
);

// ALU control: use the actual funct field (not bits of the sign-extended immediate)
alu_control alu_control3 (
    .funct(funct),
    .aluop(aluop),
    .select(alu_ctrl)
);

// ALU input mux: if alusrc == 1 choose sign-extended immediate, else choose rdata2
// Naming here assumes top_mux has ports (a = rdata2, b = s_extendout, sel, y)
top_mux top_mux3 (
    .a(rdata2),
    .b(s_extendout),
    .sel(alusrc),
    .y(b_input)
);

// ALU: perform operation determined by alu_ctrl
alu alu3 (
    .a(rdata1),
    .b(b_input),
    .control(alu_ctrl),
    .result(aluout),
    .zero(aluzero)
);

// EX/MEM pipeline register: capture control and datapath outputs
// The port names here assume ex_mem expects *_in inputs plus clk/reset and produces control outputs.
// If your ex_mem uses different port names, adapt but keep semantics the same.
ex_mem ex_mem3 (
    .clk(clk),
    .reset(reset),

    // inputs from EX stage
    .ctlwb_in(wb_ctl),
    .ctlm_in(m_ctl),
    .adder_in(adder_out),
    .zero_in(aluzero),
    .alu_in(aluout),
    .rdata2_in(rdata2),
    .mux_in(reg_mux_out),

    // outputs (registered) forwarded to MEM stage and beyond
    .ctlwb_out(wb_ctlout),
    .branch(branch),
    .memread(memread),
    .memwrite(memwrite),
    .add_result(EX_MEM_NPC),
    .zero(zero),
    .alu_result(alu_result),
    .rdata2_out(rdata2out),
    .five_bit_muxout(five_bit_muxout)
);

endmodule
