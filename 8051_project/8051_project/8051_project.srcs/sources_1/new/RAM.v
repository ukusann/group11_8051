`timescale 1ns / 1ps

`include "define_lib.vh"
  
module RAM(   

    input wire clock,            // sysclock
    input wire reset,            // reset
    input wire wr,               // write flag
    input wire rd,               // read flag
    input wire direct,           // acess the memory directly
    input wire [15:0] addr,      // memory address
    
    inout wire [7:0] data_bus,   // 8 bits word
    
    output wire A,
    output wire P0,
    output wire SP,
    output wire TMOD,
    output wire DPL,
    output wire DPH,
    output wire TL0,
    output wire TL1,
    output wire TH0,
    output wire TH1,
    
    output wire IE,
    output wire IP,
    output wire PSW,
    output wire TCON,   
    
    output wire R0,
    output wire R1,
    output wire R2,
    output wire R3,
    output wire R4,
    output wire R5,
    output wire R6,
    output wire R7
 );
 
 reg [7:0] data [  0:`DATA_LEN];
  
 reg [7:0] SFR  [128:`DATA_LEN];
  
 reg [7:0] data_out_temp;

 reg [1:0] RS [0:3];
 
initial begin
        SFR[`SP_ADDR] <= 8'h07;
end
 
 // ==============================================================
 // ========================= OUTPUTS ============================
 
assign data_bus = data_out_temp;
 
assign A    = SFR[ `A_ADDR  ];
assign P0   = SFR[ `P0_ADDR ];
assign SP   = SFR[ `SP_ADDR ];
assign TMOD = SFR[`TMOD_ADDR];
assign DPL  = SFR[ `DPL_ADDR];
assign DPH  = SFR[ `DPH_ADDR];
assign TL0  = SFR[ `TL0_ADDR];
assign TL1  = SFR[ `TL1_ADDR];
assign TH0  = SFR[ `TH0_ADDR];
assign TH1  = SFR[ `TH1_ADDR];
assign IE   = SFR[ `IE_ADDR ];
assign IP   = SFR[ `IP_ADDR ];
assign PSW  = SFR[ `PSW_ADDR];
assign TCON = SFR[`TCON_ADDR];

assign R0 = data[PSW];
assign R1 = data[PSW];
assign R2 = data[PSW];
assign R3 = data[PSW];
assign R4 = data[PSW];
assign R5 = data[PSW];
assign R6 = data[PSW];
assign R7 = data[PSW];

 // ====================== END OF OUTPUTS ========================
 // ==============================================================
 
always @(posedge clock) begin

    if (reset)
        SFR[`SP_ADDR] <= 8'h07;
    else if (wr) begin
        if(addr > 8'h7F && direct == `EN)
            SFR[addr] <= data_bus;
        else 
            data[addr] <= data_bus;
    end
    
    else if (rd) begin
        if(addr > 8'h7F && direct == `EN ) 
            data_out_temp <= SFR[addr];
        else 
            data_out_temp <= data[addr];
    end
end

endmodule