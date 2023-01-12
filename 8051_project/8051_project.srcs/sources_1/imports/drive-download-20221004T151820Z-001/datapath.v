`timescale 1ns / 1ps
// --------------------------------------------------
// BEGIN Defines declarations:
`define START   3'b000
`define FETCH   3'b001
`define DECODE  3'b010
`define JNZ     3'b110
`define HALT    3'b111

`define DISABLE 1'b0
`define ENABLE  1'b1

// ALU operations
`define NO_OP 4'h0
`define ADD   4'hC
`define SUBB  4'h1
`define ANL   4'h2
`define ORL   4'h3
`define XRL   4'h4
`define RL    4'h5
`define RR    4'h6
`define SETB  4'h7
`define CLR   4'h8
`define CPL   4'h9
`define INC   4'hA
`define DEC   4'hB

// MOV
`define OP_MOV_A   8'hF6
`define OP_MOV_R   8'hF5
`define OP_MOV_B   8'h85

// ALU
`define OP_ADD_D   8'h25
`define OP_ADD_R   8'h28
`define OP_SUB_D   8'h95
`define OP_SUB_R   8'h98
`define OP_DEC     8'h18
`define OP_INC     8'h08
`define OP_XOR_D   8'h68
`define OP_XOR_R   8'h62
`define OP_AND_D   8'h58
`define OP_AND_R   8'h52
`define OP_OR_D    8'h48
`define OP_OR_R    8'h42
`define OP_CPL_B   8'hB2
`define OP_CPL_A   8'hF4
`define OP_SETB    8'hD2
`define OP_CLR     8'hE4
`define OP_RL      8'h23
`define OP_RR      8'h03

// BRANCH
`define JNB  3'd1;
`define JB   3'd2;
`define JNC  3'd3;
`define JC   3'd4;
`define CJNE 3'd5; 

`define OP_ACALL        8'h11
`define OP_LCALL        8'h12
`define OP_JNB          8'h30
`define OP_JB           8'h20
`define OP_JC           8'h40
`define OP_CJNE         8'hB5

`define MSB_8  8'h7
`define MSB_11 8'hB
`define MSB_15 8'hE
`define MSB_16 8'hF

// END OF Defines declarations:
// --------------------------------------------------   

//====================================================
//====================================================

module datapath(clk, rst, hit, PCload, en_ir_op, alu, Rn_load, A_load, B_load, BIT_load, Jmux, IR_op); 
// --------------------------------------------------
// BEGIN Defines declarations:
    
	input  wire clk;
	input  wire rst;
	input  wire hit;
	input  wire PCload;
	input  wire en_ir_op;
	input  wire alu;
	input  wire Rn_load;
	input  wire A_load;
	input  wire B_load;
	input  wire BIT_load;
	input  wire [2:0]Jmux;
	
	output wire IR_op;
	
	
// END OF Variables declarations:
// --------------------------------------------------
// 8051 Registers:
//    psw
reg co;
reg [1:0] RS;
reg overf, underf;
wire ov;

// SFR Registers 
wire [`MSB_8:0] A;
wire [`MSB_8:0] B;
reg  [`MSB_8:0] Rn [0:7];
wire [`MSB_8:0] PSW;
wire [`MSB_8:0] P0;
wire [`MSB_8:0] SP;
wire [`MSB_8:0] TMOD;
wire [`MSB_8:0] DPL;
wire [`MSB_8:0] DPH;
wire [`MSB_8:0] TL0;
wire [`MSB_8:0] TL1;
wire [`MSB_8:0] TH0;
wire [`MSB_8:0] TH1;
wire [`MSB_8:0] IE; 
wire [`MSB_8:0] IP;
wire [`MSB_8:0] TCON;

// Reg File:

wire [ `MSB_8:0] rd;         // first register
wire [ `MSB_8:0] rs;          // second register
wire             cpl_b;      // register bit cpl (1 bit)
wire [ `MSB_8:0] cond;       // branch condition (8 bit)
wire             cond_b;     // branch condition (1 bit)
wire [ `MSB_8:0] offset8;    // jump offset (8 bit)
wire [`MSB_15:0] offset15;   // jump offset (15 bit)
wire [`MSB_11:0] addr11;     // addr acall (11 bit)
wire [`MSB_16:0] addr16;     // addr lcall (11 bit)


instrutionFetch( clk, rst, hit, en_ir_op, branch, pc, IR_op, rd, rs, cond, cond_b, offset8, offset15, offsetNE, addr11, addr16);

// ----------------------------------------------------------------------------------------------------------------
// load Registers:
reg [7:0] Reg; 
reg bit_brch;

always @(posedge clk) begin

    if (rst) begin
        Reg <= Rn[0];
    end
        
    if (Rn_load & valid_insr_en) begin
        if(IR_op == `OP_INC || IR_op == `OP_DEC )
            Reg <= Rn[rd];
        else
            Reg <= Rn[rs];
    end
      
end

// ----------------------------------------------------------------------------------------------------------------
// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  MOV  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
wire [`MSB_8:0] addr;
wire [`MSB_8:0] data_bus;
wire read;
wire wr;

assign addr = (IR_op == `OP_MOV_A || IR_op == `OP_MOV_R || IR_op == `OP_MOV_B)? rs: 8'h00;

// assign 

// RAM ram(clk, rst, wr, read, direct, addr, data_bus, A, P0, SP, TMOD, DPL, DPH, TL0, TL1, TH0, TH1, IE, IP, PSW, TCON, Rn);


// ----------------------------------------------------------------------------------------------------------------
// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  ALU  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
wire [3:0] operation;
wire imm;
wire cpl_b;


assign operation = (IR_op == `OP_ADD_D || IR_op == `OP_ADD_R)? `ADD :
                   (IR_op == `OP_SUB_D || IR_op == `OP_SUB_R)? `SUBB : 
                   (IR_op == `OP_DEC)                        ? `DEC :
                   (IR_op == `OP_INC)                        ? `INC :
                   (IR_op == `OP_XOR_D || IR_op == `OP_XOR_R)? `XRL :
                   (IR_op == `OP_AND_D || IR_op == `OP_AND_R)? `ANL :                    
                   (IR_op == `OP_OR_D  || IR_op == `OP_OR_R )? `XRL :
                   (IR_op == `OP_CPL_B || IR_op == `OP_CPL_A)? `CPL : 
                   (IR_op == `OP_SETB)                       ? `SETB :
                   (IR_op == `OP_CLR)                        ? `CLR :
                   (IR_op == `OP_RL)                         ? `RL :
                   (IR_op == `OP_RR)                         ? `RR : `NO_OP;                    

assign cpl_b = (IR_op == `OP_CPL_B )? 1'b1: 1'b0;

assign imm   = (IR_op == `OP_ADD_D || IR_op == `OP_SUB_D || IR_op == `OP_XOR_D || IR_op == `OP_AND_D || IR_op == `OP_OR_D)? 1'b1: 1'b0; 

ALU ALU( alu, imm, clk, rst, valid_insr_en, operation, rd, rs, cpl_b, A, B, overf, underf,PSW[7], co, p);

// ----------------------------------------------------------------------------------------------------------------
// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  BRANCH  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
wire jnb, jb, jnc, jc, cjne;  


// Conditions
assign cjne = (( A == rs) & Jmux[`CJNE]);
assign {jnc, jc} = { Jmux[`JNC] & ~BIT_load & ~bit_brch , Jmux[`JC] & ~BIT_load & bit_brch};
assign {jnb, jb} = { Jmux[`JNB] & ~BIT_load &  ~PSW[7]  , Jmux[`JB] & ~BIT_load & PSW[7]};

always @(posedge clk) begin
     
    if (jnc | jc | jb | jnb | cjne);
end 

// ----------------------------------------------------------------------------------------------------------------
// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  others  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
assign ov  = rst? 0 : overf|underf;

wire valid_insr_en = hit & en_ir_op;

//====================================================
//====================================================

// update flags
assign PSW = rst? 0 : {co, 0, 0, RS[1] ,RS[0], ov, 0, p};


endmodule