`timescale 1ns / 1ps

`define ADD   4'hC
`define SUB   4'h1
`define INC   4'hA
`define DEC   4'hB

module addSub(op, ci, a, b, result, co,x , underf, overf);
    input        op, ci;        // operations: 1 -> add, 0 -> sub;     carry in
    input  [7:0] a, b;          // Temp accumulators
    output [7:0] result;        // result of the operation
    output       co, x;            // carry out
    output       underf, overf;

assign {co,result, x} = (op == `ADD || op == `INC) ? {a,ci} + {b, 1'b1} : 
                             (op == `SUB || op == `DEC) ? {a,ci} - {b, 1'b1} : 
                             {ci, 8'h00, x};   // last bit is the carry
 
assign underf      = co^(~result[7])^(a[7]^(~b[7]) | b[7]^(~a[7]));  //   00000 -1 = 11111
assign overf       = co^result[7]^a[7]^b[7];                         //   01111 +1 = 10000

endmodule