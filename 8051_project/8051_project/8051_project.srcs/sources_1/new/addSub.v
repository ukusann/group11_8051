`timescale 1ns / 1ps



module addSub(op, ci, a, b, result, co, underf, overf);
    input        op, ci;        // operations: 1 -> add, 0 -> sub;     carry in
    input  [7:0] a, b;          // Temp accumulators
    output [7:0] result;        // result of the operation
    output       co;            // carry out
    output       underf, overf;

assign {co,result} = op ? {a,ci} + {b, 1'b1} : {a,ci} - {b, 1'b1};   // last bit is the carry
 
assign underf      = co^(~result[7])^(a[7]^(~b[7]) | b[7]^(~a[7]));  //   00000 -1 = 11111
assign overf       = co^result[7]^a[7]^b[7];                         //   01111 +1 = 10000

endmodule