`timescale 1ns / 1ps

module cpl(a, result, mode, bit);
       
    input        mode;
    input        bit;
    input  [7:0] a;             // Temp accumulators
    output [7:0] result;        // result of the operation
    
    assign result = mode ? ~a : ~bit; 
endmodule 