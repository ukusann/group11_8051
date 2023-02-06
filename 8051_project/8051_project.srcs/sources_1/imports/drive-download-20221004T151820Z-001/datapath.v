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
`define OP_MOV_DD  8'h85

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
//`define JNB  3'd1;
//`define JB   3'd2;
//`define JNC  3'd3;
//`define JC   3'd4;
//`define CJNE 3'd5; 

`define JNB  3'b001
`define JB   3'b010
`define JNC  3'b011
`define JC   3'b100
`define CJNE 3'b101

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
/*
* Control Signal:
    Fetch signals:
    - hit
    - en_ir_op
    - PCload
    Decode signals:
    - mov
    - alu
    - Jmux (uses PCload too)
    - call
    - Rn_load
    - A_load
    - BIT_load
    
*/



module datapath(clk, rst, hit, PCload, en_ir_op, mov, alu, Rn_load, A_load, B_load, BIT_load, Jmux, call, IR_op, endOP); 
// --------------------------------------------------
// BEGIN Defines declarations:
    
	input  wire clk;
	input  wire rst;
	input  wire hit;
	input  wire PCload;
	input  wire en_ir_op;
	input  wire [2:0]mov;
	input  wire alu;
	input  wire Rn_load;
	input  wire A_load;
	input  wire B_load;
	input  wire BIT_load;
	input  wire [2:0]Jmux;
    input  wire [1:0]call;
    
	output wire IR_op;
	output wire endOP;
	
	
// END OF Variables declarations:
// --------------------------------------------------
// 8051 Registers:
//    psw
reg co;
reg [1:0] RS;
reg overf, underf;
wire ov;

// SFR Registers 
wire [7:0] A;
wire [7:0] B;
reg  [7:0] Rn [0:7];
wire [7:0] PSW;
wire [7:0] P0;
wire [7:0] SP;
wire [7:0] TMOD;
wire [7:0] DPL;
wire [7:0] DPH;
wire [7:0] TL0;
wire [7:0] TL1;
wire [7:0] TH0;
wire [7:0] TH1;
wire [7:0] IE; 
wire [7:0] IP;
wire [7:0] TCON;

// Reg File:

wire [ 7:0] r1;         // first register
wire [ 7:0] r2;          // second register
wire        cpl_b;      // register bit cpl (1 bit)
wire [ 7:0] cond;       // branch condition (8 bit)
wire        cond_b;     // branch condition (1 bit)
wire [ 7:0] offset8;    // jump offset (8 bit)
wire [10:0] addr11;     // addr acall (11 bit)
wire [15:0] addr16;     // addr lcall (11 bit)
wire [ 7:0] pc;

      
// ----------------------------------------------------------------------------------------------------------------
// load Registers:
wire [7:0] R[0:7];
wire Reg;
wire [7:0] acc; 
reg bit_brch;

assign R[0] = R0;
assign R[1] = R1;
assign R[2] = R2;
assign R[3] = R3;
assign R[4] = R4;
assign R[5] = R5;
assign R[6] = R6;
assign R[7] = R7;

wire valid_insr_en = hit & en_ir_op;

// Load Register:
assign Reg = (~Rn_load || ~valid_insr_en || rst)? 8'h0: 
             (IR_op == `OP_INC || IR_op == `OP_DEC || IR_op == `OP_MOV_R)? R[r1] : R[r2];

// Load Acumulater:
assign acc = (~A_load || ~valid_insr_en || rst)? 8'h0 : A;
assign A = (A_load && alu)? acc: A;           // only update the acuumulator when used in an operation. 


// ----------------------------------------------------------------------------------------------------------------
// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  MOV  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
`define MOV_AR 2'b01
`define MOV_R  2'b10
`define MOV_B  2'b11


wire [7:0] addr;
wire [7:0] data_bus_in;
wire [7:0] data_bus_out;
wire read;
wire write;
wire R_save;
wire direct, addressable_b, is_regist;
reg rd, wr, address, dir; 
reg [7:0]data;


assign read    = rd | (IR_op == `OP_MOV_R) ; 
assign write   = wr; 
assign addr    = address; 
assign data_bus_in = data; 

assign direct = dir;
// Mov op:
assign A   = ( (mov == `MOV_AR) && A_load && Rn_load )? Reg : A;    // mov A Rn 
assign Reg = ( (mov == `MOV_R ) && Rn_load )? r2: Reg;              // mov Rn #data

// Mov bit_adress, #data

assign R_save = (mov == `MOV_R) && (op == `DEC) && (op == `INC) && Reg != R[r1];

always @(posedge clk )begin
    if(rst) begin
        rd   <= 1'b0;
        wr   <= 1'b0;
        data <= 8'h0;
        address <= 8'h0;
    end 
    if ( R_save )begin // Saves the register
        data    <= Reg;
        address <= r1;
        dir     <= 1'b0;
        wr      <= 1'b1;
    end
        
end

// assign 

 RAM ram(clk, rst, write, read, direct, addressable_b , bit_address, addr, is_regist,
         data_bus, A, P0, SP, TMOD, DPL, DPH, TL0, TL1, TH0, TH1, IE, IP, PSW, TCON,
         A, P0, SP, TMOD, DPL, DPH, TL0, TL1, TH0, TH1, IE, IP, PSW, TCON, 
          R0, R1, R2, R3, R4, R5, R6, R7, data_bus);
// ----------------------------------------------------------------------------------------------------------------
// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  ALU  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
wire [3:0] operation;
wire imm;
wire cpl_b;


assign op = (IR_op == `OP_ADD_D || IR_op == `OP_ADD_R)? `ADD :
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


// ----------------------------------------------------------------------------------------------------------------
// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  BRANCH  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


wire jnb, jb, jnc, jc, cjne; 
wire [15:0]pc_offset; 

// Conditions
assign jnb  = ~cond_b     & (Jmux ==  `JNB );
assign jb   =  cond_b     & (Jmux ==   `JB );
assign jnc  = ~co         & (Jmux ==  `JNC );
assign jc   = ~co         & (Jmux ==   `JC );
assign cjne = (acc != r2) & (Jmux == `CJNE );

// ----------------------------------------------------------------------------------------------------------------
// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<><<<<<<  CALL  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
`define CALL_1  3'b001  
`define CALL_2  3'b011
`define RET_1   3'b101
`define RET_2   3'b111

reg [7:0]pstack;


assign SP = pstack;
 
always @(posedge clk && call != 2'b00)begin
    pstack = pstack + 8'h0;
end


// ----------------------------------------------------------------------------------------------------------------
// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  others  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
assign ov  = rst? 1'b0 : overf|underf;



//====================================================
//====================================================

// update flags
assign PSW = rst? 8'h0 : {co, 1'b0, 1'b0, RS[1] ,RS[0], ov, 1'b0, p};



ALU ALU( alu, imm, clk, rst, valid_insr_en, op, r1, r2, cpl_b, co, acc , B   ,Reg, acc, B, Reg,  overf, underf, co, p);

instrutionFetch fetch( clk, rst, hit, en_ir_op, pc_offset, endOp, (jnb & jb & jnc & jc & cjne & PC_load),
                 IR_op, r1, r2, cpl_b, cond, cond_b, offset8, addr11, addr16, pc);    
endmodule