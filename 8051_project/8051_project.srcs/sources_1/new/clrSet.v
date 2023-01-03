`timescale 1ns / 1ps

module clrSet(b, result, op);
    
    input b, op;
    output wire result;
    
    assign result = op? b|1'b1 : b&1'b0; 
    
endmodule
