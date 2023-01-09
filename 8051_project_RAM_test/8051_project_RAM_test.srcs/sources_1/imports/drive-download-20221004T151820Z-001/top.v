`timescale 1ns / 1ps

module top(
	//inputs
    input clock,
    input reset,    
	input wire wr,                      // write flag
    input wire rd,                      // read flag
    input wire direct,                  // acess the memory directly
    input wire addressable_b,           // access the bit directly
    input wire [3:0] rd_bit_address,    // address of bit to be read
    input wire [7:0] addr,              // memory address
    input is_regist,

	input wire [7:0] data_bus_in,   // 8 bits word
    
    input wire [7:0] A_in,
    input wire [7:0] P0_in,
    input wire [7:0] SP_in,
    input wire [7:0] TMOD_in,
    input wire [7:0] DPL_in,
    input wire [7:0] DPH_in,
    input wire [7:0] TL0_in,
    input wire [7:0] TL1_in,
    input wire [7:0] TH0_in,
    input wire [7:0] TH1_in,

    input wire [7:0] IE_in,
    input wire [7:0] IP_in,
    input wire [7:0] PSW_in,
    input wire [7:0] TCON_in,   
    
	// output
    output wire [7:0] A_out,
    output wire [7:0] P0_out,
    output wire [7:0] SP_out,
    output wire [7:0] TMOD_out,
    output wire [7:0] DPL_out,
    output wire [7:0] DPH_out,
    output wire [7:0] TL0_out,
    output wire [7:0] TL1_out,
    output wire [7:0] TH0_out,
    output wire [7:0] TH1_out,

    output wire [7:0] IE_out,
    output wire [7:0] IP_out,
    output wire [7:0] PSW_out,
    output wire [7:0] TCON_out,

    output wire [7:0] R0,
    output wire [7:0] R1,
    output wire [7:0] R2,
    output wire [7:0] R3,
    output wire [7:0] R4,
    output wire [7:0] R5,
    output wire [7:0] R6,
    output wire [7:0] R7,
    output wire [7:0] data_bus_out  

    );



RAM ram(clock, reset, wr, rd, direct, addressable_b, rd_bit_address,
            addr, is_regist, data_bus_in, A_in, P0_in, SP_in, TMOD_in,
            DPL_in, DPH_in, TL0_in, TL1_in, TH0_in, TH1_in, IE_in,
            IP_in, PSW_in, TCON_in, A_out, P0_out, SP_out, TMOD_out,
            DPL_out, DPH_out, TL0_out, TL1_out, TH0_out, TH1_out,
            IE_out, IP_out, PSW_out, TCON_out, R0, R1, R2, R3, R4, 
            R5, R6, R7, data_bus_out); 

endmodule
