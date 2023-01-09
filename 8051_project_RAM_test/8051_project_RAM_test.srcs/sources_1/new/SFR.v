`timescale 1ns / 1ps
module SFR(clock, reset, A_in, P0_in, SP_in, TMOD_in,
            DPL_in, DPH_in, TL0_in, TL1_in, TH0_in, TH1_in, IE_in,
            IP_in, PSW_in, TCON_in, A_out, P0_out, SP_out, TMOD_out,
            DPL_out, DPH_out, TL0_out, TL1_out, TH0_out, TH1_out,
            IE_out, IP_out, PSW_out, TCON_out);

input wire clock;                   // sysclock
input wire reset;                   // reset

//----SFR inputs----
input wire [7:0] A_in;
input wire [7:0] P0_in;
input wire [7:0] SP_in;
input wire [7:0] TMOD_in;
input wire [7:0] DPL_in;
input wire [7:0] DPH_in;
input wire [7:0] TL0_in;
input wire [7:0] TL1_in;
input wire [7:0] TH0_in;
input wire [7:0] TH1_in;
input wire [7:0] IE_in;
input wire [7:0] IP_in;
input wire [7:0] PSW_in;
input wire [7:0] TCON_in; 

//----SFR outputs----
output wire [7:0] A_out;
output wire [7:0] P0_out;
output wire [7:0] SP_out;
output wire [7:0] TMOD_out;
output wire [7:0] DPL_out;
output wire [7:0] DPH_out;
output wire [7:0] TL0_out;
output wire [7:0] TL1_out;
output wire [7:0] TH0_out;
output wire [7:0] TH1_out;
output wire [7:0] IE_out;
output wire [7:0] IP_out;
output wire [7:0] PSW_out;
output wire [7:0] TCON_out;

reg [7:0] SFR [`DATA_LEN:128];
endmodule
