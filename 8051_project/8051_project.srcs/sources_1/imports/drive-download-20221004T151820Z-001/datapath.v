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
	
	/*****input for bitstream test*****/
	//input [3:0] A_input,

	//--------------------------------
	
	/*****input for simulation*****/
	input [7:0] A_input,

	input wire PCload,
	input wire IRload,
	input wire INmux,
	input wire Aload,
	input wire JNZmux,
	input wire Out_enable,
	
	output wire cond_A,
	output wire [2:0] IR_op,

	/*****output for bitstream test*****/
	//output [2:0] AOutPut

	//--------------------------------
	
	/*****output for simulation*****/
	output [7:0] AOutPut
	
	
	
);
// END OF Variables declarations:
// --------------------------------------------------

//====================================================
//====================================================

// --------------------------------------------------
// BEGIN Signals:
	
	reg [7:0] A;            // Acumulator
	reg [7:0] IR;           // Instruction Register
	reg [7:0] A_output;     // Acumulater Output
	reg [7:0] mem[0:15];    // ROM: 16 location x 8 bits
	reg [3:0] PC;           // Program Counter (4 bits)
	
// END OF Signal:
// -------------------------------------------------- 
   
//===================================================
//===================================================

// --------------------------------------------------
// BEGIN Initial varibles :
	initial
	begin
		A        = 8'b00000101;
		IR       = 8'b00000000;
		A_output = 8'b00000000;
		PC       = 4'b0000;

		mem[0]	 = 8'b01100000; // Input de A
		mem[1]	 = 8'b10100000;	// dec A
		mem[2]	 = 8'b11000001;	// jnz PC = 1
		mem[3]	 = 8'b01100000; // Input de A
		mem[4]	 = 8'b11000101;	// jnz PC = 5
		mem[5]	 = 8'b10100000; // dec A 
		mem[6]	 = 8'b10000000; // output A
		mem[7]	 = 8'b11100000; // halt
		mem[8]	 = 8'b10100000;
		mem[9]	 = 8'b10100000;
		mem[10]	 = 8'b10100000;
		mem[11]	 = 8'b10100000;
		mem[12]	 = 8'b10100000;
		mem[13]	 = 8'b10100000;
		mem[14]	 = 8'b10100000;
		mem[15]	 = 8'b10100000;
	end        
// END OF Initial varibles:
// --------------------------------------------------

//===================================================
//===================================================   

// --------------------------------------------------
// BEGIN Update outputs :
	assign cond_A  = (A != 4'b0000) ? 1'b1:1'b0;
	
	assign IR_op   = IR[7:5];
	
	assign AOutPut = A_output;

// END OF Update outputs:
// --------------------------------------------------

//===================================================
//=================================================== 
//===================================================
//=================================================== 

// --------------------------------------------------
// BEGIN Datapath :

//---------------------------------------------------   
always @ (posedge clock)
begin
	/**** op IR = mem[PC] ****/
	if (IRload == `ENABLE && PCload == `ENABLE && Aload == `DISABLE)
			IR 		<= mem[PC];
end
//_______________________________________________________________________________

//--------------------------------------------------- 
always @ (posedge clock)
begin
	/**** op PC = PC +1 or PC = IR[3:0] ****/
	if (PCload == `ENABLE && (Aload | JNZmux) == `DISABLE) 
		PC <= PC +4'b0001; // if A = 0
	else if (PCload == `ENABLE && Aload == `DISABLE && JNZmux == `ENABLE)
		PC <= IR[3:0]; // if A != 0
end
//_______________________________________________________________________________

//--------------------------------------------------- 
always @ (posedge clock)
begin
	/**** op A = A - 1 ****/
	if( (IRload | PCload | INmux) == `DISABLE && Aload == `ENABLE)
		A <= A - 8'b00000001;
	
	/**** op A Output A ****/
	if( (IRload | PCload | Aload) == `DISABLE && Out_enable == `ENABLE)
		A_output <= A;

	/**** op Input A ****/
	if( (IRload | PCload) == `DISABLE && (Aload & INmux) == `ENABLE)
		A <= A_input;
end
//_______________________________________________________________________________

// END OF Data Path:
// --------------------------------------------------

//===================================================
//===================================================
endmodule