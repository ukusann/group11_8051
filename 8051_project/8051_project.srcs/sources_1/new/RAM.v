`timescale 1ns / 1ps

`include "define_lib.vh"
  
`define DATA_LEN    16'hFF
 
module RAM(   

    input wire clock,            // sysclock
    input wire reset,            // reset
    input wire wr,               // write flag
    input wire rd,               // read flag
    input wire direct,           // acess the memory directly
    input wire [16:0] addr,      // memory address
    
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
    output wire TCON   
 );
 
reg [7:0] data [  0:`DATA_LEN];

reg [7:0] SFR  [128:`DATA_LEN];

reg [7:0] data_out_temp;

initial 
begin

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

 // ====================== END OF OUTPUTS ========================
 // ==============================================================
 
always @(posedge clock) begin
    
    if (reset);
    else if(wr == `EN &&  addr > 8'h7F && direct == `EN ) 
        SFR[addr] <= data_bus;
    else if (wr == `EN && direct == ~`EN )
        data[addr] <= data_bus;
    else if(rd)
        data_out_temp <= data[addr];
    
        
end
    
endmodule