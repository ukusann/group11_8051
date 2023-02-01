`timescale 1ns / 1ps

`define CODE_LEN    8'hff


module ROM(pc, pc_data);

input wire  [15:0] pc;
output wire [7:0]  pc_data;


reg[7:0]code_memo[`CODE_LEN:0];  // Big Endien

initial begin
    code_memo[8'h0] = 8'h98;
    code_memo[8'h1] = 8'hD5;
    code_memo[8'h2] = 8'h00;
    code_memo[8'h3] = 8'h0F;
    code_memo[8'h4] = 8'h11;
    code_memo[8'h5] = 8'h11;
    code_memo[8'h6] = 8'h11;
    code_memo[8'h7] = 8'h11;
    code_memo[8'h8] = 8'h22;
    code_memo[8'h9] = 8'h22;
    code_memo[8'hA] = 8'h22;
    code_memo[8'hB] = 8'h22;

end

assign pc_data = code_memo[pc];
endmodule
