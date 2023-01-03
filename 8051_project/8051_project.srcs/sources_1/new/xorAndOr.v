`timescale 1ns / 1ps

`define OR  2'b00
`define XOR 2'b01
`define AND 2'b10

module xorAndOr(op, a, b, result, p);
    input        op;        // operations: 1 -> and, 0 -> xor;
    input  [7:0] a, b;      // Temp accumulators
    output [7:0] result;    // result of the operation
    output       p;         // bit parity
 
assign result = (op == `OR)  ? a|b : 8'bz;
assign result = (op == `XOR) ? a^b : 8'bz;
assign result = (op == `AND) ? a&b : 8'bz;

assign p = result[0];

endmodule
