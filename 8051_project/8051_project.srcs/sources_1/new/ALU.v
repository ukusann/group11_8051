`timescale 1ns / 1ps
`define EN_ 1'b1

`define NO_OP 4'h0
`define ADD   4'hC
`define SUBB  4'h1
`define ANL   4'h2
`define ORL   4'h3
`define XRL   4'h4
`define RL    4'h5
`define RR    4'h6
`define SETB  4'h7
`define CLR   4'h8
`define CPL   4'h9
`define INC   4'hA
`define DEC   4'hB

`define MSB_4           8'h03
`define MSB_8           8'h07

`define A_ADDR          8'hE0    // accumulator


//_______________________________________________________________________
// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  ALU  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
module ALU( alu, imm, clk, rst, valid_insr_en, op, rd, rs, cpl_b, A, B, Reg, overf, underf,ci, co, p);
    
    input wire alu, imm;
    input wire clk, rst;
    input wire valid_insr_en;          // enable instrution register load
    input wire [ `MSB_4:0] op;         // operation
    input wire [ `MSB_8:0] rd;         // first register
    input wire [ `MSB_8:0] rs;         // second register
    input wire             cpl_b;      // register bit cpl (1 bit) 
    input                  ci;
    
    inout       [`MSB_8:0] A;
    inout       [`MSB_8:0] B;
    inout       [`MSB_8:0] Reg;
    
    output            overf;
    output            underf;
    output            co;
    output            p;
    
    wire [`MSB_4:0] op_alu = (alu & valid_insr_en)? op: 4'h0; 
    wire [`MSB_8:0] a, b;                       // temp accumulators
    
    wire [`MSB_8:0] result_addsub;
    wire [`MSB_8:0] result_rlrr;
    wire [`MSB_8:0] result_logic;
    wire [`MSB_8:0] result_cpl;
    wire [`MSB_8:0] result_cpl;
    wire result_sc;
    
    
    
    // Operand selection  
    assign a = (rd ==  `A_ADDR)? A :
               (rd < 8'h08)   ? Reg :
                                {7'h00,rd[7]};
                 
    assign b = (imm == `EN_)                 ? rd :
               (rd < 8'h08 && imm != `EN_)   ? Reg :
               (op == `INC || op == `DEC)    ? 8'b01: 8'b00;
     
     
    addSub adder     (op_alu, ci, a, b, result_add, co, x, underf, overf);
    RlRr shift       (op_alu, a, result_rlrr);
    xorAndOr logic   (op_alu, a, b, result_logic, p);
    cpl cpl          (op_alu, a, result_cpl, mode, a[0]);
    clrSet clrSetBit (b, result_sc, op);
    
    // assign  result_addsub ;
    // assign 
    
endmodule
