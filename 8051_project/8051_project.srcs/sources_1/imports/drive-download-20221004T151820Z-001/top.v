`timescale 1ns / 1ps

module top(
	input  wire clk,
	input  wire rst,
	input  wire hit,
	input  wire PCload,
	input  wire en_ir_op,
	input  wire [2:0]mov,
	input  wire alu,
	input  wire Rn_load,
	input  wire A_load,
	input  wire B_load,
	input  wire BIT_load,
	input  wire [2:0]Jmux,
    input  wire [1:0]call,
    
	output wire IR_op,
	output wire endOP

);

// ctrlunit ctrl_unit(
// 	.clock		(clock),
// 	.reset		(reset),
// 	.cond_A		(cond_A),
// 	.IR_op		(IR_op),
// 	.PCload		(PCload),
// 	.IRload		(IRload),
// 	.INmux		(INmux),
// 	.Aload		(Aload),
// 	.JNZmux		(JNZmux),
// 	.Halt		(Halt),
// 	.Out_enable (Out_enable)
// 


datapath data_path(clk, rst, hit, PCload, en_ir_op, mov, alu, Rn_load, A_load, B_load, BIT_load, Jmux, call, IR_op, endOP); 
endmodule
