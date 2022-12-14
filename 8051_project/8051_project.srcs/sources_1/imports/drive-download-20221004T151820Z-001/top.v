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
	.clk(clk),
    .rst(rst),
    .hit(hit), 
    .en_ir_op(en_ir_op)
);
endmodule
