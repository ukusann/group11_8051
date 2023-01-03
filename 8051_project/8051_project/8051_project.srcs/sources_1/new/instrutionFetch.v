`timescale 1ns / 1ps
 
 `define MSB_8  8'h7
 `define MSB_11 8'hB
 `define MSB_15 8'hE
 `define MSB_16 8'hF

 // 24 bits
 // 0000 0000 | 0000 0000 | 0000 0000 |
 //     IS         rd           rs      
 
     /*__________________________________
    rr     ->  -- | op  |  rd   | rs   |   
    ri     ->  -- | op  | rd    | imm  |
    br8    ->  -- | op  | cond  |offset|
    br1    ->  -- | op  |-----|b|offset|
    acall  ->  -- | op|||addr8+3|      |
    lcall  ->  -- | op  |    addr 16   |
    ____________________________________*/
 
 
 module instrutionFetch( clk, rst, hit, en_ir_op, pc, IR_op, rd, rs, cpl_b, cond, cond_b, offset8, offset15, addr11, addr16);
    
    input wire clk;
    input wire rst;
    input wire hit;          // 
    input wire en_ir_op;     // enable instrution register
    input wire pc;           // program counter
    
    output wire [ `MSB_8:0] IR_op;      // Instrution
    output wire [ `MSB_8:0] rd;         // first register
    output wire [ `MSB_8:0] rs;         // second register
    output wire             cpl_b;      // register bit cpl (1 bit)
    output wire [ `MSB_8:0] cond;       // branch condition (8 bit)
    output wire             cond_b;     // branch condition (1 bit)
    output wire [ `MSB_8:0] offset8;    // jump offset (8 bit)
    output wire [`MSB_15:0] offset15;   // jump offset (15 bit)
    output wire [`MSB_11:0] addr11;     // addr acall (11 bit)
    output wire [`MSB_16:0] addr16;     // addr lcall (11 bit)
    
    wire [23:0] insr;                   // Instrution register
    ROM code(pc, insr);
    
    assign IR_op    = insr [23:16];  
    assign rd       = insr [15: 8];
    assign rs       = insr [ 7: 0];
    assign cpl_b    = insr [  16 ];
    assign cond_b   = insr [  16 ];
    assign cond     = insr [15: 8];
    assign offset8  = insr [ 7: 0];
    assign offset15 = insr [ 7: 0];  
    assign addr11   = insr [18: 8];  // op[2] + op[1] + op[0] + insr [15: 8] (acall) 
    assign addr16   = insr [ 7: 0];
    
    
 
 endmodule