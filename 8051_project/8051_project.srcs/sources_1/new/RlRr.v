`timescale 1ns / 1ps

`define RL    4'h5
`define RR    4'h6
`define EN    1'b1

module RlRr(op, a, result);
    input  [3:0] op;
    input  [7:0] a;
    output [7:0] result;

    assign result = (op == `RL)? a << 1'b1 : (op == `RR)? a >> 1'b1 : 8'h00;
endmodule