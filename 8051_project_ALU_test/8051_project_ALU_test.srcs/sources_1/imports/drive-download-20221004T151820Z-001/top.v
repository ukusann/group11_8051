`timescale 1ns / 1ps

module top(
	input wire alu_flag, imm,
    input wire clk, rst,
    input wire valid_insr_en,          // enable instrution register load
    input wire [3:0] op,         // operation
    input wire [7:0] rd,         // first register
    input wire [7:0] rs,         // second register
    input wire cpl_b,                  // register bit cpl (1 bit) 
    input wire ci,
    
    input wire [7:0] A_in,
    input wire [7:0] B_in,
    input wire [7:0] Reg_in,


    output wire [7:0] A_out,
    output wire [7:0] B_out,
    output wire [7:0] Reg_out,    
    
    output wire overf,
    output wire underf,
    output wire co,
    output wire p

    );


ALU alu( alu_flag, imm, clk, rst, valid_insr_en, op, rd, rs, cpl_b, ci,
            A_in, B_in, Reg_in, A_out, B_out, Reg_out, overf, underf,
            co, p);
endmodule
