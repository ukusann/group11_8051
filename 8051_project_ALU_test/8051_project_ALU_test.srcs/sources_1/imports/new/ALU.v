`timescale 1ns / 1ps

`include "define_lib.vh"

//_______________________________________________________________________
// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  ALU  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
module ALU( alu_flag, imm, clk, rst, valid_insr_en, op, rd, rs, cpl_b, ci,
            A_in, B_in, Reg_in, A_out, B_out, Reg_out, overf, underf,
            co, p);

// ==============================================================
// ========================= INPUTS =============================
input wire alu_flag, imm;
input wire clk, rst;
input wire valid_insr_en;          // enable instrution register load
input wire [3:0] op;         // operation
input wire [7:0] rd;         // first register
input wire [7:0] rs;         // second register
input wire cpl_b;                  // register bit cpl (1 bit) 
input wire ci;

input wire [7:0] A_in;
input wire [7:0] B_in;
input wire [7:0] Reg_in;

 // ==============================================================
 // ========================= OUTPUTS ============================
output wire [7:0] A_out;
output wire [7:0] B_out;
output wire [7:0] Reg_out;    

output wire overf;
output wire underf;
output wire co;
output wire p;

// ==============================================================
// ==================== Internal Wires ======================    
wire [3:0] op_alu;

wire [7:0] a, b;                       // temp accumulators

wire [7:0] result_addsub;
wire [7:0] result_rlrr;
wire [7:0] result_logic;
wire [7:0] result_cpl;
wire [7:0] result_sc;
    
reg [7:0] A_out_temp;



assign op_alu = (alu_flag && valid_insr_en)? op : 4'h0; 

// Operand selection  
assign a = (rd ==  `A_ADDR)? A_in :
            (rd < 8'h08)   ? Reg_in :
                            {7'h00,rd[7]};
                
assign b = (imm == `EN)                 ? rs :
            (rs < 8'h08 && imm != `EN)   ? Reg_in :
            (op_alu == `INC || op_alu == `DEC)    ? 8'h01: 8'h00;

    
xorAndOr logic   (op_alu, a, b, result_logic, p);
addSub adder     (op_alu, ci, a, b, result_addsub, co, x, underf, overf);
RlRr shift       (op_alu, a, result_rlrr);
cpl Cpl          (op_alu, a, result_cpl, cpl_b, a[0]);
clrSet clrSetBit (op_alu, b, result_sc);


assign A_out = (op_alu == `ADD || op_alu == `INC || op_alu == `SUBB || op_alu == `DEC)? result_addsub :
                    (op_alu == `RL || op_alu == `RR)? result_rlrr :
                    (op_alu == `ANL || op_alu == `ORL || op_alu == `XRL)? result_logic :
                    (op_alu == `CLR)? result_cpl :
                    (op_alu == `SETB)? result_sc : A_in; 
endmodule