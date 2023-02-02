`timescale 1ns / 1ps

`include "define_lib.vh"

module tb_tob_1;

	//------Inputs------
	reg clk;
    reg rst;
    reg hit;          
    reg en_ir_op;     // enable instrution register
    reg branch;
    reg [15:0] pc_in;  

	//--------Outputs-------
    wire [ 7:0]  IR_op;      // Instrution
    wire [ 7:0]  rd;         // first register
    wire [ 7:0]  rs;         // second register
    wire         cpl_b;      // register bit cpl (1 bit)
    wire [ 7:0]  cond;       // branch condition (8 bit)
    wire         cond_b;     // branch condition (1 bit)
    wire [ 7:0]  offset8;    // jump offset (8 bit)
    wire [10:0]  addr11;     // addr acall (11 bit)
    wire [15:0]  addr16;     // addr lcall (11 bit)
    wire [15:0]  pc_out;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk			(clk),
		.rst			(rst),
		.hit			(hit),
		.en_ir_op		(en_ir_op),
		.branch			(branch),
		.pc_in			(pc_in),
		.IR_op			(IR_op),
		.rd				(rd),
		.rs				(rs),
		.cpl_b			(cpl_b),
		.cond			(cond),
		.cond_b			(cond_b),
		.offset8		(offset8),
		.addr11			(addr11),
		.addr16			(addr16),
		.pc_out			(pc_out)
	); 

	initial begin
		// Initialize Inputs
    	clk			= 0;
		rst			= 1;
    	hit 		= 0;
		en_ir_op 	= 1'b1;
		branch 		= 0;
		pc_in		= 16'h0000;;        
		
		// Wait 100 ns for global rst to finish
		#10;
		rst = 0;
		en_ir_op = 1'b1;
		
		
        
		// Add stimulus here
        //#7570 $finish;
	end

always #5 clk = ~clk;
//always #25 A_input = A_input+ 1'b1;
endmodule

