`timescale 1ns / 1ps

module RlRr(op, a, result);
    input        op;
    input  [7:0] a;
    output [7:0] result;

    assign result = op? a << 1'b1 : a >> 1'b1;
endmodule