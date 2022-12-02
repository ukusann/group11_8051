`timescale 1ns / 1ps
// --------------------------------------------------
// BEGIN Defines declarations:
`define START   3'b000
`define FETCH   3'b001
`define DECODE  3'b010
`define INPUT   3'b011
`define OUTPUT  3'b100
`define DEC     3'b101
`define JNZ     3'b110
`define HALT    3'b111

`define DISABLE 1'b0
`define ENABLE  1'b1

// END OF Defines declarations:
// --------------------------------------------------   

//====================================================
//====================================================

module datapath(
// --------------------------------------------------
// BEGIN Defines declarations:    
	input clock,
	input reset,
	
	input wire PCload,
    input wire IRload,
    input wire Aload,
    input wire Add,
    input wire Sub,
    input wire Dec,
    input wire Inc,
    input wire Xor,
    input wire And,
    input wire Or,
    input wire Cpl_1,
    input wire Cpl_8,
    input wire Rr,
    input wire Rl,

    output wire [23:0] PC,
    output wire [24:0] IR
);
// END OF Variables declarations:
// --------------------------------------------------
RAM RAM(
    .clock(clock),    
    .reset(reset),
    .wr(wr),          
    .rd(rd),          
    .addr(addr),      
    .data_in(data_in),   
    .data_out(data_out),  
    .A(A),
    .P0(P0),
    .SP(SP),
    .TMOD(TMOD),
    .DPL(DPL),
    .DPH(DPH),
    .TL0(TL0),
    .TL1(TL1),
    .TH0(TH0),
    .TH1(TH1),
    .IE(IE),
    .IP(IP),
    .PSW(PSW),
    .TCON(TCON)   
);

ALU ALU(
    .clock(clock),    
    .reset(reset),
    .Add(Add),
    .Sub(Sub),
    .Dec(Dec),
    .Inc(Inc),
    .Xor(Xor),
    .And(And),
    .Or(Or),
    .Cpl_1(Cpl_1),
    .Cpl_8(Cpl_8),
    .Rr(Rr),
    .Rl(Rl)
    );
//====================================================
//====================================================

endmodule