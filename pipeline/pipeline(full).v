`timescale 1ns / 1ps

module pipeline(
    input  wire        clk,
    input  wire        reset,
    output wire [31:0] r1,
    output wire [31:0] r2,
    output wire [31:0] r3,
    
    //dbug
    output wire [31:0] dbg_ifid_instr,
    output wire [1:0]  dbg_idex_wb,
    output wire [1:0]  dbg_exmem_wb,
    output wire [1:0]  dbg_memwb_wb,
    output wire        dbg_wb_regwrite,
    output wire [4:0]  dbg_wb_dest,
    output wire [31:0] dbg_wb_data
);


    wire [31:0] r1t, r2t, r3t;

    // IF/ID
    wire [31:0] ifidinstr, ifidnpc;
    wire        exmempc;
    wire [31:0] exmemnpc;

    fetch fetch1 (
        .clk          (clk),
        .rst          (reset),
        .ex_mem_pc_src(exmempc),  
        .ex_mem_npc   (exmemnpc), 
        .if_id_instr  (ifidinstr),
        .if_id_npc    (ifidnpc)
    );


    wire [1:0]  idexwb;
    wire [2:0]  idexmem;
    wire [3:0]  idexex;
    wire [31:0] idexnpc;
    wire [31:0] read1, read2, signext;
    wire [4:0]  exinstr2016, exinstr1511;


    wire [31:0] wbmux;         
    wire [1:0]  memwbout;      
    wire [4:0]  memwbwrite;    

   
    decode decode1 (
        .clk                   (clk),
        .rst                   (reset),
        .wb_reg_write          (memwbout[0]),   
        .wb_write_reg_location (memwbwrite),
        .mem_wb_write_data     (wbmux),
        .if_id_instr           (ifidinstr),
        .if_id_npc             (ifidnpc),
        .id_ex_wb              (idexwb),
        .id_ex_mem             (idexmem),
        .id_ex_execute         (idexex),
        .id_ex_npc             (idexnpc),
        .id_ex_readdat1        (read1),
        .id_ex_readdat2        (read2),
        .id_ex_sign_ext        (signext),
        .id_ex_instr_bits_20_16(exinstr2016),
        .id_ex_instr_bits_15_11(exinstr1511),
        .r1                    (r1t),
        .r2                    (r2t),
        .r3                    (r3t)
    );

    assign r1 = r1t;
    assign r2 = r2t;
    assign r3 = r3t;

    wire       RegDst  = idexex[3];
    wire       ALUSrc  = idexex[2];
    wire [1:0] ALUOp   = idexex[1:0];

    wire       zero;
    wire [31:0] aluresult, r2out;
    wire [4:0]  mout;
    wire [1:0]  idexwbout;   
    wire        ex_branch;
    wire        ex_memread;
    wire        ex_memwrite;

    execute execute1 (
        .clk            (clk),
        .reset          (reset),
        .wb_ctl         (idexwb),
        .m_ctl          (idexmem),
        .regdst         (RegDst),
        .alusrc         (ALUSrc),
        .aluop          (ALUOp),
        .npcout         (idexnpc),
        .rdata1         (read1),
        .rdata2         (read2),
        .s_extendout    (signext),
        .instrout_2016  (exinstr2016),
        .instrout_1511  (exinstr1511),
        .funct          (ifidinstr[5:0]),  

        .wb_ctlout      (idexwbout),     
        .branch         (ex_branch),
        .memread        (ex_memread),
        .memwrite       (ex_memwrite),
        .EX_MEM_NPC     (exmemnpc),        
        .zero           (zero),
        .alu_result     (aluresult),
        .rdata2out      (r2out),
        .five_bit_muxout(mout)
    );

    wire [31:0] readout, aluout;

    memory memory1 (
        .clk           (clk),
        .ALUResult     (aluresult),
        .WriteData     (r2out),
        .WriteReg      (mout),
        .WBControl     (idexwbout),
        .MemWrite      (ex_memwrite),
        .MemRead       (ex_memread),
        .Branch        (ex_branch),
        .Zero          (zero),

        .ReadData      (readout),
        .ALUResult_out (aluout),
        .WriteReg_out  (memwbwrite),
        .WBControl_out (memwbout),  
        .PCSrc         (exmempc)
    );

    writeback writeback1 (
        .mem_wb    (memwbout),  
        .read_data (readout),
        .alu_result(aluout),
        .writedata (wbmux)
    );

    assign dbg_ifid_instr  = ifidinstr;
    assign dbg_idex_wb     = idexwb;
    assign dbg_exmem_wb    = idexwbout;
    assign dbg_memwb_wb    = memwbout;
    assign dbg_wb_regwrite = memwbout[0];
    assign dbg_wb_dest     = memwbwrite;
    assign dbg_wb_data     = wbmux;


    assign dbg_rf_regwrite = memwbout[0];   
    assign dbg_rf_rd       = memwbwrite;    
    assign dbg_rf_wdata    = wbmux;         

endmodule
