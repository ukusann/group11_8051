`timescale 1ns / 1ps

module top(
	input wire clk,
    input wire rst,
    input wire hit,          
    input wire en_ir_op,     // enable instrution register
    input wire branch,
    input wire [15:0] pc_in,        // program counter

    output wire [ 7:0]   IR_op,      // Instrution
    output wire [ 7:0]   rd,         // first register
    output wire [ 7:0]   rs,         // second register
    output wire         cpl_b,      // register bit cpl (1 bit)
    output wire [ 7:0]   cond,       // branch condition (8 bit)
    output wire         cond_b,     // branch condition (1 bit)
    output wire [ 7:0]   offset8,    // jump offset (8 bit)
    output wire [10:0]   addr11,     // addr acall (11 bit)
    output wire [15:0]   addr16,      // addr lcall (16 bit)
    output wire [15:0]  pc_out

);


instrutionFetch fetch( clk, rst, hit, en_ir_op, branch, pc_in, IR_op, rd, rs, 
                        cpl_b, cond, cond_b, offset8, addr11, addr16, pc_out);
endmodule
