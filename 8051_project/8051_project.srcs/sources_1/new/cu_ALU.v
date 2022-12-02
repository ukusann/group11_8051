`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2022 03:43:38 PM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cu_ALU(
    input wire clock,            // sysclock
    input wire reset,            // reset
    
    output wire Add,
    output wire Sub,
    output wire Dec,
    output wire Inc,
    output wire Xor,
    output wire And,
    output wire Or,
    output wire Cpl_1,
    output wire Cpl_8,
    output wire Rr,
    output wire Rl
    
    );
endmodule
