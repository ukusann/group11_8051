`timescale 1ns / 1ps

module top(
    input clock,
    input reset,
    output Halt,
    
	/*****input for bitstream test*****/
	//input [3:0] A_input,

	//--------------------------------
	
	/*****input for simulation*****/
	input [7:0] A_input,
    

	/*****output for bitstream test*****/
	//output [2:0] AOutPut

	//--------------------------------
	
	/*****output for simulation*****/
	output [7:0] AOutPut

    );

	wire[2:0] IR_op;


ctrlunit ctrl_unit(
	.clock		(clock),
	.reset		(reset),
	.cond_A		(cond_A),
	.IR_op		(IR_op),
	.PCload		(PCload),
	.IRload		(IRload),
	.INmux		(INmux),
	.Aload		(Aload),
	.JNZmux		(JNZmux),
	.Halt		(Halt),
	.Out_enable (Out_enable)
);

datapath data_path(
	.clock		(clock),
    .reset		(reset),
    .A_input	(A_input),
	.PCload		(PCload),
    .IRload		(IRload),
    .INmux		(INmux),
	.Aload		(Aload),
	.JNZmux		(JNZmux),
	.cond_A		(cond_A),
	.IR_op		(IR_op),
	.AOutPut	(AOutPut),
	.Out_enable (Out_enable)
);
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
endmodule
