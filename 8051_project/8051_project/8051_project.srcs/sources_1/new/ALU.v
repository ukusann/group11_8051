`timescale 1ns / 1ps

`define OP_ADD_DIRECT   8'h25
`define OP_ADD_REG      8'h28
`define OP_SUB_DIRECT   8'h95
`define OP_SUB_REG      8'h98
`define OP_DEC          8'h18
`define OP_INC          8'h08
`define OP_XOR_DIRECT   8'h68
`define OP_XOR_REG      8'h62
`define OP_AND_DIRECT   8'h58
`define OP_AND_REG      8'h52
`define OP_OR_DIRECT    8'h48
`define OP_OR_REG       8'h42
`define OP_CPL_BIT      8'hB2
`define OP_CPL_A        8'hF4
`define OP_SETB         8'hD2
`define OP_CLR          8'hE4
`define OP_RL           8'h23
`define OP_RR           8'h03

`define MSB_8           8'h07

//_______________________________________________________________________
// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  ALU  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
module ALU( clk, rst, valid_insr_en, IR_op, rd, rs, cpl_b );
    
    input wire clk, rst;
    input wire valid_insr_en;          // enable instrution register load
    input wire [ `MSB_8:0] IR_op;      // Instrution
    input wire [ `MSB_8:0] rd;         // first register
    input wire [ `MSB_8:0] rs;         // second register
    input wire             cpl_b;      // register bit cpl (1 bit) 
    
    
    
    reg [`MSB_8:0]a, b;    // temp accumulators
    
    // Immediate operand
    
    // Operand selection
    
    
    addSub adder(op, ci, a, b, result, co, underf, overf);
    RlRr shift(op, a, result);
    xorAndOr logic(op, a, b, result, p);
    cpl cpl(a, result, mode, bit);
    clrSet clrSetBit(b, result, op);

endmodule
