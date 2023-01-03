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

module datapath(clk, rst, hit, en_ir_op); 
// --------------------------------------------------
// BEGIN Defines declarations:
    
	input wire clk;
	input wire rst;
	input wire hit;
	input wire en_ir_op;
	
	
// END OF Variables declarations:
// --------------------------------------------------

wire valid_insr_en = hit & en_ir_op;

instrutionFetch(clk, rst, hit, en_ir_op, pc, IR_op, rd, rs, cond, cond_b, offset8, offset15, addr11, addr16);
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

ALU ALU( clk, rst, hit, en_ir_op, IR_op, rd, rs, cpl_b );
//====================================================
//====================================================

endmodule