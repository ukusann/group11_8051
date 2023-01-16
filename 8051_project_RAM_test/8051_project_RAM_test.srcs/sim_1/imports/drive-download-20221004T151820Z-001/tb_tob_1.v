`timescale 1ns / 1ps

`include "define_lib.vh"

module tb_tob_1;

	//------Inputs------
	reg clock;
	reg reset;
	reg wr;
	reg rd;
	reg direct;
	reg addressable_b;
	reg [3:0] bit_address;
	reg [7:0] addr;
	reg is_regist;
	
	reg [7:0] data_bus_in;   // 8 bits word
    
    reg [7:0] A_in;
    reg [7:0] P0_in;
    reg [7:0] SP_in;
    reg [7:0] TMOD_in;
    reg [7:0] DPL_in;
    reg [7:0] DPH_in;
    reg [7:0] TL0_in;
    reg [7:0] TL1_in;
    reg [7:0] TH0_in;
    reg [7:0] TH1_in;

    reg [7:0] IE_in;
    reg [7:0] IP_in;
    reg [7:0] PSW_in;
    reg [7:0] TCON_in;

	//--------Outputs-------
	wire [7:0] A_out;
    wire [7:0] P0_out;
    wire [7:0] SP_out;
    wire [7:0] TMOD_out;
    wire [7:0] DPL_out;
    wire [7:0] DPH_out;
    wire [7:0] TL0_out;
    wire [7:0] TL1_out;
    wire [7:0] TH0_out;
    wire [7:0] TH1_out;

    wire [7:0] IE_out;
    wire [7:0] IP_out;
    wire [7:0] PSW_out;
    wire [7:0] TCON_out;

	wire [7:0] R0;
	wire [7:0] R1;
	wire [7:0] R2;
	wire [7:0] R3;
	wire [7:0] R4;
	wire [7:0] R5;
	wire [7:0] R6;
	wire [7:0] R7;
    wire [7:0] data_bus_out;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clock			(clock),
		.reset			(reset),
		.wr				(wr),
		.rd				(rd),
		.direct			(direct),
		.addressable_b	(addressable_b),
		.bit_address	(bit_address),
		.addr			(addr),
		.is_regist		(is_regist),
		.data_bus_in	(data_bus_in),
		.A_in 			(A_in),
		.P0_in 			(P0_in),
		.SP_in 			(SP_in),
		.TMOD_in 		(TMOD_in),
		.DPL_in 		(DPL_in),
		.DPH_in 		(DPH_in),
		.TL0_in 		(TL0_in),
		.TL1_in 		(TL1_in),
		.TH0_in 		(TH0_in),
		.TH1_in 		(TH1_in),
		.IE_in			(IE_in),
		.IP_in			(IP_in),
		.PSW_in			(PSW_in),
		.TCON_in		(TCON_in),
		.A_out 			(A_out),
		.P0_out			(P0_out),
		.SP_out 		(SP_out),
		.TMOD_out		(TMOD_out),
		.DPL_out 		(DPL_out),
		.DPH_out 		(DPH_out),
		.TL0_out 		(TL0_out),
		.TL1_out 		(TL1_out),
		.TH0_out 		(TH0_out),
		.TH1_out 		(TH1_out),
		.IE_out			(IE_out),
		.IP_out			(IP_out),
		.PSW_out		(PSW_out),
		.TCON_out		(TCON_out),
		.R0				(R0),
		.R1				(R1),
		.R2				(R2),
		.R3				(R3),
		.R4				(R4),
		.R5				(R5),
		.R6				(R6),
		.R7				(R7),
		.data_bus_out	(data_bus_out)
	); 

	initial begin
		// Initialize Inputs
		clock			= 0;
		reset			= 1;
	    wr				= 1;
		rd				= 0;
		direct			= 0;
		addressable_b 	= 0;
		bit_address	= 4'h3;
		addr			= 8'h74;
		is_regist		= 0;

		data_bus_in		= 8'h10;
		A_in			= 8'h44;
		P0_in			= 8'h07;
		SP_in			= 8'h07;
		TMOD_in			= 8'h0;
		DPL_in			= 8'h0;
		DPH_in			= 8'h0;
		TL0_in			= 8'h0;
		TL1_in			= 8'h0;
		TH0_in			= 8'h0;
		TH1_in			= 8'h0;
		IE_in           = 8'h0;
        IP_in           = 8'h0;      
        PSW_in          = 8'h0;
        TCON_in         = 8'h0; 
		// Wait 100 ns for global reset to finish
		#10;
		reset = 0;
		#10;
		wr 		= 0;
		rd 		= 1;
		#10;
        
		// Add stimulus here
        //#7570 $finish;
	end

always #5 clock = ~clock;
//always #25 A_input = A_input+ 1'b1;
endmodule

