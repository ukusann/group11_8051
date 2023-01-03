`timescale 1ns / 1ps

module tb_tob_1;

	// Inputs
	reg clock;
	reg reset;
	reg [7:0] A_input;

	// Outputs
	wire Halt;
	wire [7:0] AOutPut;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clock(clock), 
		.reset(reset), 
		.A_input(A_input),
		.Halt(Halt),
		.AOutPut(AOutPut)
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		reset = 1;
	    A_input = 8'b00000011;
		
		// Wait 100 ns for global reset to finish
		#30;
		reset = 0;
		
        
		// Add stimulus here
        //#7570 $finish;
	end

always #5 clock = ~clock;
//always #25 A_input = A_input+ 1'b1;
endmodule

