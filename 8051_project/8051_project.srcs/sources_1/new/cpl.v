`timescale 1ns / 1ps

`define CLR   4'h8

module cpl(op, a, result, mode, bit);
       
    input  [3:0] op;   
    input        mode;
    input        bit;
    input  [7:0] a;             // Temp accumulators
    output [7:0] result;        // result of the operation
    
    assign result = (op ==`CLR)? (mode  ? ~a : {7'h00,~bit}) : 8'h00; 
endmodule 