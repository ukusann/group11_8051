`timescale 1ns / 1ps

`define MSB_8       8'h7
`define CODE_LEN    8'hff


module ROM(pc, insr);

input wire pc;
output wire insr;


reg[`MSB_8:0]code_memo[`CODE_LEN:0];  // Big Endien

assign insr = {code_memo[pc], code_memo[pc+1], code_memo[pc+2]};
endmodule
