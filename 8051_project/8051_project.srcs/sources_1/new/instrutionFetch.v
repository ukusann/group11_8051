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
 
 
 module instrutionFetch( clk, rst, hit, en_ir_op, endOp, offset, op_call, pc_in, IR_op, rd, rs, 
                        cpl_b, cond, cond_b, offset8, addr11, addr16, pc_out, sp_load);
    
input wire clk;
input wire rst;
input wire hit;          // 
input wire en_ir_op;     // enable instrution register
input wire endOp;
input wire offset;
input wire op_call;
input wire [15:0] pc_in;


// ==============================================================
// ========================= OUTPUTS ============================

output wire [ 7:0] IR_op;     // Instrution
output wire [ 7:0] rd;        // first register
output wire [ 7:0] rs;        // second register
output wire        cpl_b;     // register bit cpl (1 bit)
output wire [ 7:0] cond;      // branch condition (8 bit)
output wire        cond_b;    // branch condition (1 bit)
output wire [ 7:0] offset8;   // jump offset (8 bit)
output wire [10:0] addr11;    // addr acall (11 bit)
output wire [15:0] addr16;    // addr lcall (16 bit)
output wire [15:0] pc_out;
output wire sp_load;

reg fetched, stack_l;
wire [7:0] pc_data;                 // Instrution register -> 8 bit
reg [31:0] insr;                    // Instruction Vector Reg -> 32 bit
reg [15:0] pc;
reg [2:0] counter;



initial begin
    fetched = 1'b0;
    pc      = 8'h0;
    counter = 2'b00;
end



ROM code(pc_out, pc_data); // só somar PC quando flag estiver a 1

assign pc_out = pc;
assign IR_op    = fetched ? insr [31:24] : IR_op   ===  8'h1;  
assign rd       = fetched ? insr [23:16] : rd      ===  8'h1;
assign rs       = fetched ? insr [15: 8] : rs      ===  8'h1;
assign cpl_b    = fetched ? insr [  23 ] : cpl_b   ===  1'b1;
assign cond_b   = fetched ? insr [  23 ] : cond_b  ===  1'b1;
assign cond     = fetched ? insr [23:16] : cond    ===  8'h1;
assign offset8  = fetched ? insr [ 7: 0] : offset8 ===  8'h1;   
assign addr11   = fetched ? insr [23:13] : addr11  === 11'h1;  // op[2] + op[1] + op[0] + insr [23:16] (acall) 
assign addr16   = fetched ? insr [23: 8] : addr16  === 16'h1;


assign sp_load = stack_l;

always @(posedge clk) begin

    if (rst) begin
        pc           <= pc_in;
        fetched      <= 1'b0;
        counter      <= 2'b00;
    end
        
    else if (en_ir_op) begin
        insr[7:0] = pc_data;

        if (counter == 2'b11) begin
            fetched      <= 1'b1;
            counter      <= 2'b00;
            pc <= pc + 8'h1;
        end

        else if (fetched) begin
            insr    <= 8'h0;
            fetched <= 1'b0;
        end
        
        else begin
            insr    <= (insr << 8'h8);
            fetched <= 1'b0;
            counter <= counter + 2'b01;   
            pc <= pc + 8'h1;
        end
    end
end

 endmodule