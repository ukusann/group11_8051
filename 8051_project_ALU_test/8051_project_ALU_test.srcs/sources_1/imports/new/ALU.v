`timescale 1ns / 1ps

`include "define_lib.vh"

//_______________________________________________________________________
// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  ALU  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
module ALU( alu_flag, imm, clk, rst, valid_insr_en, op, rd, rs, cpl_b, ci,
            A_in, B_in, Reg_in, A_out, B_out, Reg_out, overf, underf,
            ci, co, p);

// ==============================================================
// ========================= INPUTS =============================
    input wire alu_flag, imm;
    input wire clk, rst;
    input wire valid_insr_en;          // enable instrution register load
    input wire [ `MSB_4:0] op;         // operation
    input wire [ `MSB_8:0] rd;         // first register
    input wire [ `MSB_8:0] rs;         // second register
    input wire cpl_b;                  // register bit cpl (1 bit) 
    input wire ci;
    
    input wire [`MSB_8:0] A_in;
    input wire [`MSB_8:0] B_in;
    input wire [`MSB_8:0] Reg_in;

 // ==============================================================
 // ========================= OUTPUTS ============================
    output wire [`MSB_8:0] A_out;
    output wire [`MSB_8:0] B_out;
    output wire [`MSB_8:0] Reg_out;    
    
    output wire overf;
    output wire underf;
    output wire co;
    output wire p;

// ==============================================================
// ==================== Internal Wires ======================    
    wire [`MSB_4:0] op_alu = (alu_flag & valid_insr_en)? op: 4'h0; 
    wire [`MSB_8:0] a, b;                       // temp accumulators
    
    wire [`MSB_8:0] result_addsub;
    wire [`MSB_8:0] result_rlrr;
    wire [`MSB_8:0] result_logic;
    wire [`MSB_8:0] result_cpl;
    wire [`MSB_8:0] result_sc;
    
    assign A_out =  (op_alu == `ADD || op_alu == `INC || op_alu == `SUBB || op_alu == `DEC)? result_addsub :
                    (op_alu == `RL || op_alu == `RR)? result_rlrr :
                    (op_alu == `ANL || op_alu == `ORL || op_alu == `XRL)? result_logic :
                    (op_alu == `CLR)? result_cpl :
                    (op_alu == `SETB)? result_sc : A_in;
    
    

    // Operand selection  
    assign a = (rd ==  `A_ADDR)? A_in :
               (rd < 8'h08)   ? Reg_in :
                                {7'h00,rd[7]};
                 
    assign b = (imm == `EN)                 ? rs :
               (rs < 8'h08 && imm != `EN)   ? Reg_in :
               (op_alu == `INC || op_alu == `DEC)    ? 8'b01: 8'b00;
     
     
    addSub adder     (op_alu, ci, a, b, result_addsub, co, x, underf, overf);
    RlRr shift       (op_alu, a, result_rlrr);
    xorAndOr logic   (op_alu, a, b, result_logic, p);
    cpl cpl          (op_alu, a, result_cpl, cpl_b, a[0]);
    clrSet clrSetBit (b, result_sc, op);
    
    // assign  result_addsub ;
    // assign 
    
endmodule
