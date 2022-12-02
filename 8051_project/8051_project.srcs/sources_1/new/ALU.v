`timescale 1ns / 1ps

`include "define_lib.vh"
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


module ALU
(
    input wire clock,            // sysclock
    input wire reset,            // reset
    input wire Add,
    input wire Sub,
    input wire Dec,
    input wire Inc,
    input wire Xor,
    input wire And,
    input wire Or,
    input wire Cpl_1,
    input wire Cpl_8,
    input wire Rr,
    input wire Rl,

    input   wire [24:0] IR,
    input   wire A,
    input   wire PSW,
    output  wire [15:0] addr,
    output  wire [7:0] data_bus
);

reg [7:0]   reg_1;
reg [7:0]   reg_2;
reg [7:0]   result;
reg [15:0]  res_addr;
reg [7:0]   carry;
initial 
begin

end

// ==============================================================
// ========================= OUTPUTS ============================

assign data_bus = result;

// ====================== END OF OUTPUTS ========================
// ==============================================================

// ==============================================================
// ========================= EXECUTION ============================

always @(posedge clock) 
begin
    reg_1   <= IR[16:9];
    reg_2   <= IR[7:0];
    carry = ((8'b1000000 & PSW) >> 7) ? 8'b00000001 : 8'b00000000; 
    if (reset);
    
    else if(Add)
    begin
        result <= A + reg_2; 
        res_addr = `A_ADDR;
    end

    else if(Sub)
    begin
        result <= A - carry - reg_2; 
        res_addr = `A_ADDR;
    end

    else if(Dec)
    begin
        result <= reg_1 - 8'b00000001; 
        //res_addr = ;
    end

end


 // ====================== END OF EXECUTION ========================
 // ==============================================================
endmodule
