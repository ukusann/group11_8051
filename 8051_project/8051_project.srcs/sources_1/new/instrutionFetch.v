`timescale 1ns / 1ps
 
 `define MSB_8  8'h7
 `define MSB_11 8'hB
 `define MSB_15 8'hE
 `define MSB_16 8'hF

 // 32 bits
 // 0000 0000 | 0000 0000 | 0000 0000 | 0000 0000
 //     IS         rd           rs       offset
 
     /*_________________________________________
    rr     ->  -- | op  |  rd    | rs   |------|   
    ri     ->  -- | op  |  rd    | imm  |------|
    brNE   ->  -- | op  |  rd    |  rs  |offset|
    br8    ->  -- | op  | cond   |------|offset|
    br1    ->  -- | op  |-------b|------|offset|
    br1c   ->  -- | op  |-------0|------|offset|      
    acall  ->  -- | op||| addr8+3|------|------|
    lcall  ->  -- | op  |    addr 16    |------|
    ____________________________________________*/
 
 
 module instrutionFetch( clk, rst, hit, en_ir_op, endOp, offset, op_call, IR_op, rd, rs, 
                        cpl_b, cond, cond_b, offset8, addr11, addr16, pc_out, sp_load);
    
input wire clk;
input wire rst;
input wire hit;          // 
input wire en_ir_op;     // enable instrution register
input wire endOp;
input wire offset;
input wire op_call;


output wire [7:0] IR_op;      // Instrution
output wire [7:0] rd;         // first register
output wire [7:0] rs;         // second register
output wire       cpl_b;      // register bit cpl (1 bit)
output wire [7:0] cond;       // branch condition (8 bit)
output wire       cond_b;     // branch condition (1 bit)
output wire [7:0] offset8;    // jump offset (8 bit)
output wire [7:0] addr11;     // addr acall (11 bit)
output wire [7:0] addr16;     // addr lcall (11 bit)
output wire [15:0] pc_out;
output wire sp_load;

reg fetched, stack_l;
reg enable_fetch;
wire [7:0] pc_data;                 // Instrution register -> 8 bit
reg [31:0] insr;                    // Instruction Vector Reg -> 32 bit
reg [15:0] pc;

assign sp_load = stack_l;

always @(posedge clk) begin

    if (rst) begin
        enable_fetch    <= 1'b1;
        fetched         <= 1'b0;
        pc              <= 16'd0;
    end
        
    if (enable_fetch && en_ir_op || op_call) begin
        insr[7:0] = pc_data;
        if(insr > 24'hFFFFFF) begin
            fetched    <= 1'b1;
            enable_fetch <= 1'b0;
        end
        else if (fetched)
            insr <= 8'h0;
        else begin
            insr  <= (insr << 8'h8);
            fetched    <= 1'b0;
        end
        pc <= pc_out + 8'h1;
    end
    else
        enable_fetch = 1'b1; 
      
end


ROM code(pc_out, pc_data); // só somar PC quando flga estiver a 1

assign pc_out   = (offset)?  offset8 + pc_out : pc;

assign IR_op    = fetched ?  insr [31:24] :(endOp)? IR_op   : 8'h0;  
assign rd       = fetched ?  insr [23:16] :(endOp)? rd      : 8'h0;
assign rs       = fetched ?  insr [15: 8] :(endOp)? rs      : 8'h0;
assign cpl_b    = fetched ?  insr [  23 ] :(endOp)? cpl_b   : 1'h0;
assign cond_b   = fetched ?  insr [  23 ] :(endOp)? cond_b  : 1'h0;
assign cond     = fetched ?  insr [23:16] :(endOp)? cond    : 8'h0;
assign offset8  = fetched ?  insr [ 7: 0] :(endOp)? offset8 : 8'h0;   
assign addr11   = fetched ?  insr [26:16] :(endOp)? addr11  : 11'h0;  // op[2] + op[1] + op[0] + insr [23:16] (acall) 
assign addr16   = fetched ?  insr [23: 8] :(endOp)? addr16  : 16'h0;
/*
switch case opcodes
clock
valor de contador consoante operação
*/    
 
 endmodule