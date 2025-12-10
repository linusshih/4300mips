// executeTB.v

`timescale 1ns / 1ps

module sim1;

    reg clk;
    reg reset;

    // control signals (match EXECUTE.v)
    reg [1:0] wb_ctl;
    reg [2:0] m_ctl;
    reg regdst;
    reg alusrc;
    reg [1:0] aluop;

    // datapath inputs
    reg [31:0] npcout;
    reg [31:0] rdata1;
    reg [31:0] rdata2;
    reg [31:0] s_extendout;
    reg [4:0]  instrout_2016;
    reg [4:0]  instrout_1511;
    reg [5:0]  funct;

    // outputs
    wire [1:0] wb_ctlout;
    wire branch;
    wire memread;
    wire memwrite;
    wire [31:0] EX_MEM_NPC;
    wire zero;
    wire [31:0] alu_result;
    wire [31:0] rdata2out;
    wire [4:0]  five_bit_muxout;

    // Instantiate UUT
    EXECUTE uut (
        .clk(clk),
        .reset(reset),

        .wb_ctl(wb_ctl),
        .m_ctl(m_ctl),
        .regdst(regdst),
        .alusrc(alusrc),
        .aluop(aluop),

        .npcout(npcout),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .s_extendout(s_extendout),
        .instrout_2016(instrout_2016),
        .instrout_1511(instrout_1511),
        .funct(funct),

        .wb_ctlout(wb_ctlout),
        .branch(branch),
        .memread(memread),
        .memwrite(memwrite),
        .EX_MEM_NPC(EX_MEM_NPC),
        .zero(zero),
        .alu_result(alu_result),
        .rdata2out(rdata2out),
        .five_bit_muxout(five_bit_muxout)
    );

    // Clock generator
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Reset sequence
        reset = 1;
        #12 reset = 0;

        // Initialize valid EXECUTE inputs
        wb_ctl = 2'b10;
        m_ctl  = 3'b001;
        npcout = 32'd100;
        rdata1 = 32'd10;
        rdata2 = 32'd20;
        s_extendout = 32'd4;
        instrout_2016 = 5'd5;
        instrout_1511 = 5'd10;
        aluop = 2'b10;       // R-type
        funct = 6'b100000;   // ADD
        alusrc = 1;          // use immediate
        regdst = 1;          // choose rd

        #15;

        // Change inputs for another test
        alusrc = 0;          // now use rdata2
        regdst = 0;          // choose rt
        s_extendout = 32'd8;
        aluop = 2'b01;       // BEQ -> SUB
        funct = 6'b100010;   // SUB

        #20;

        $stop;
    end

endmodule
