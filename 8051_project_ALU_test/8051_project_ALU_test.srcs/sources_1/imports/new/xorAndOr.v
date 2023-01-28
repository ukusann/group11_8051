`timescale 1ns / 1ps

`define ANL   4'h2
`define ORL   4'h3
`define XRL   4'h4

module xorAndOr(op, a, b, result, p);
    input  [3:0] op;        // operations: 1 -> and, 0 -> xor;
    input  [7:0] a, b;      // Temp accumulators
    output [7:0] result;    // result of the operation
    output       p;         // bit parity
 
assign result = (op == `ORL) ? a|b : 
                (op == `XRL) ? a^b :
                (op == `ANL) ? a&b : 8'h0;

assign p = result[0];

endmodule
