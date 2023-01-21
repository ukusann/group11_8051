`timescale 1ns / 1ps

`include "define_lib.vh"

module tb_tob_1;

	//------Inputs------
	reg alu_flag, imm;
    reg clk, rst;
    reg valid_insr_en;          // enable instrution register load
    reg [ `MSB_4:0] op;         // operation
    reg [ `MSB_8:0] rd;         // first register
    reg [ `MSB_8:0] rs;         // second register
    reg cpl_b;                  // register bit cpl (1 bit) 
    reg ci;
    
    reg [`MSB_8:0] A_in;
    reg [`MSB_8:0] B_in;
    reg [`MSB_8:0] Reg_in;

	//--------Outputs-------
	wire [`MSB_8:0] A_out;
    wire [`MSB_8:0] B_out;
    wire [`MSB_8:0] Reg_out;    
    
    wire overf;
    wire underf;
    wire co;
    wire p;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.alu_flag		(alu_flag),
		.imm			(imm),
		.clk			(clk),
		.rst			(rst),
		.valid_insr_en	(valid_insr_en),
		.op				(op),
		.rd				(rd),
		.rs				(rs),
		.cpl_b			(cpl_b),
		.ci				(ci),
		.A_in			(A_in),
		.B_in			(B_in),
		.Reg_in			(Reg_in),
		.A_out			(A_out),
		.B_out			(B_out),
		.Reg_out		(Reg_out),
		.overf			(overf),
		.underf			(underf),
		.co				(co),
		.p 				(p)
	); 

	initial begin
		// Initialize Inputs
		alu_flag 		= 1;
		imm 			= 1;
    	clk			    = 0;
		rst			    = 1;
    	valid_insr_en	= 1;        
    	op 				= `ADD;         
    	rd				= `A_ADDR;          
    	rs				= 8'h08;          
    	cpl_b			= 0;                  
    	ci				= 0;
		A_in			= 8'h44;
		B_in			= 8'h07;
		Reg_in			= 8'h09;
		
		// Wait 100 ns for global rst to finish
		#10;
		rst = 0;
		
        
		// Add stimulus here
        //#7570 $finish;
	end

always #5 clk = ~clk;
//always #25 A_input = A_input+ 1'b1;
endmodule

