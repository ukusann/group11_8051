`timescale 1ns / 1ps

`include "define_lib.vh"

module tb_tob_1;

	// Inputs
	reg clk;
	reg rst;
	reg hit;
	reg PCload;
	reg en_ir_op;
	reg [2:0]mov;
	reg alu;
	reg Rn_load;
	reg A_load;
	reg B_load;
	reg BIT_load;
	reg [2:0]Jmux;
    reg [1:0]call;

	// Outputs
	wire IR_op;
	wire endOP;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk			(clk),
		.rst			(rst),
		.hit			(hit),
		.PCload			(PCload),
		.en_ir_op		(en_ir_op),
		.mov			(mov),
		.alu			(alu),
		.Rn_load		(Rn_load),
		.A_load			(A_load),
		.B_load			(B_load),
		.BIT_load		(BIT_load),
		.Jmux			(Jmux),
		.call			(call),
		.IR_op			(IR_op),
		.endOP			(endOP),
	);

	initial begin
		// Initialize Inputs
		clk 		= 0;
		rst 		= 1;
	    hit 		= 0;
		PCload		= 1;
		en_ir_op	= 1;
		mov			= 2'b01;
	 	alu			= 1;
	 	Rn_load		= 1;
	 	A_load		= 1;
	 	B_load		= 0;
	 	BIT_load	= 0;
	 	Jmux		= 3'b001;
     	call 		= 2'b00;


		// Wait 100 ns for global reset to finish
		#30;
		rst = 0;
		
        
		// Add stimulus here
        //#7570 $finish;
	end

always #5 clk = ~clk;
//always #25 A_input = A_input+ 1'b1;
endmodule

