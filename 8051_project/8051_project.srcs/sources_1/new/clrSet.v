`timescale 1ns / 1ps

`define SETB  4'h7
`define CLR   4'h8

module clrSet(op, b, result);
    input [3:0] op;
    input b;
    output wire result;
    
    assign result = (op == `SETB)? b|1'b1 :(op == `CLR)? b&1'b0 : 8'h00; 
    
endmodule
