`timescale 1ns / 1ps

`include "define_lib.vh"
  
module RAM(clock, reset, wr, rd, direct, addressable_b, rd_bit_address,
            addr, is_regist, data_bus_in, A_in, P0_in, SP_in, TMOD_in,
            DPL_in, DPH_in, TL0_in, TL1_in, TH0_in, TH1_in, IE_in,
            IP_in, PSW_in, TCON_in, A_out, P0_out, SP_out, TMOD_out,
            DPL_out, DPH_out, TL0_out, TL1_out, TH0_out, TH1_out,
            IE_out, IP_out, PSW_out, TCON_out, R0, R1, R2, R3, R4, 
            R5, R6, R7, data_bus_out);   

// ==============================================================
// ========================= INPUTS =============================
input wire clock;                   // sysclock
input wire reset;                   // reset
input wire wr;                      // write flag
input wire rd;                      // read flag
input wire direct;                  // acess the memory directly
input wire addressable_b;           // access the bit directly
input wire [3:0] rd_bit_address;    // address of bit to be read
input wire [7:0] addr;              // memory address

input is_regist;

input wire [7:0] data_bus_in;   // 8 bits word

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

 // ==============================================================
 // ========================= OUTPUTS ============================
output wire [7:0] R0;
output wire [7:0] R1;
output wire [7:0] R2;
output wire [7:0] R3;
output wire [7:0] R4;
output wire [7:0] R5;
output wire [7:0] R6;
output wire [7:0] R7;
output wire [7:0] data_bus_out; 

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



// ==============================================================
// ==================== Internal Registers ======================
reg [7:0] data [`DATA_LEN:0];

reg [7:0] SFR  [`DATA_LEN:128];

reg [7:0] temp_SFR;

reg [7:0] data_out_temp;

reg [7:0] RegBank [3:0];
 
 
 
initial begin
    SFR[ `A_ADDR  ] = A_in;
    SFR[ `P0_ADDR ] = P0_in;
    SFR[ `SP_ADDR ] = SP_in;
    SFR[`TMOD_ADDR] = TMOD_in;
    SFR[ `DPL_ADDR] = DPL_in;
    SFR[ `DPH_ADDR] = DPH_in;
    SFR[ `TL0_ADDR] = TL0_in;
    SFR[ `TL1_ADDR] = TL1_in;
    SFR[ `TH0_ADDR] = TH0_in;
    SFR[ `TH1_ADDR] = TH1_in;
    SFR[ `IE_ADDR ] = IE_in;
    SFR[ `IP_ADDR ] = IP_in;
    SFR[ `PSW_ADDR] = PSW_in;
    SFR[`TCON_ADDR] = TCON_in;
    RegBank[0]      = 8'h00;
    RegBank[1]      = 8'h08;
    RegBank[2]      = 8'h10;
    RegBank[3]      = 8'h18;
end
 

 
assign data_bus_out = data_out_temp;
 
assign A_out    = SFR[ `A_ADDR  ];  
assign P0_out   = SFR[ `P0_ADDR ];
assign SP_out   = SFR[ `SP_ADDR ];
assign TMOD_out = SFR[`TMOD_ADDR];
assign DPL_out  = SFR[ `DPL_ADDR];
assign DPH_out  = SFR[ `DPH_ADDR];
assign TL0_out  = SFR[ `TL0_ADDR];
assign TL1_out  = SFR[ `TL1_ADDR];
assign TH0_out  = SFR[ `TH0_ADDR];
assign TH1_out  = SFR[ `TH1_ADDR];
assign IE_out   = SFR[ `IE_ADDR ];
assign IP_out   = SFR[ `IP_ADDR ];
assign PSW_out  = SFR[ `PSW_ADDR];
assign TCON_out = SFR[`TCON_ADDR];


assign R0 = data[`R0_ADDR + RegBank[PSW_in[4:3]]];
assign R1 = data[`R1_ADDR + RegBank[PSW_in[4:3]]];
assign R2 = data[`R2_ADDR + RegBank[PSW_in[4:3]]];
assign R3 = data[`R3_ADDR + RegBank[PSW_in[4:3]]];
assign R4 = data[`R4_ADDR + RegBank[PSW_in[4:3]]];
assign R5 = data[`R5_ADDR + RegBank[PSW_in[4:3]]];
assign R6 = data[`R6_ADDR + RegBank[PSW_in[4:3]]];
assign R7 = data[`R7_ADDR + RegBank[PSW_in[4:3]]];

 // ====================== END OF OUTPUTS ========================
 // ==============================================================
 
always @(posedge clock) begin

    if (reset) begin
        SFR[`SP_ADDR]   <= 8'h07;
        SFR[ `A_ADDR  ] <= A_in;
        SFR[ `P0_ADDR ] <= P0_in;
        SFR[`TMOD_ADDR] <= TMOD_in;
        SFR[ `DPL_ADDR] <= DPL_in;
        SFR[ `DPH_ADDR] <= DPH_in;
        SFR[ `TL0_ADDR] <= TL0_in;
        SFR[ `TL1_ADDR] <= TL1_in;
        SFR[ `TH0_ADDR] <= TH0_in;
        SFR[ `TH1_ADDR] <= TH1_in;
        SFR[ `IE_ADDR ] <= IE_in;
        SFR[ `IP_ADDR ] <= IP_in;
        SFR[ `PSW_ADDR] <= PSW_in;
        SFR[`TCON_ADDR] <= TCON_in;
        RegBank[0]      <= 8'h00;
        RegBank[1]      <= 8'h08;
        RegBank[2]      <= 8'h10;
        RegBank[3]      <= 8'h18;
    end
    else if (wr) begin
        if(addr > 8'h7F)
            if(direct == `EN)
                if(addressable_b)
                    SFR[addr][rd_bit_address] <= data_bus_in[0]; 
                else
                    SFR[addr] <= data_bus_in;   
            else
                data[addr] <= data_bus_in;
        else
            if(is_regist)
                data[RegBank[PSW_in[4:3]] + addr] <= data_bus_in;
            else
                data[addr] <= data_bus_in;
    end
    
    else if (rd) begin
        if(addr > 8'h7F)
            if(direct == `EN)
                data_out_temp <= addressable_b ? {7'h0,SFR[addr][rd_bit_address]} : SFR[addr]; 
            else 
                data_out_temp <= data[addr];
        else
            if(is_regist) 
                data_out_temp <= data[RegBank[PSW_in[4:3]] + addr];
            else
                data_out_temp <= data[addr];
    end
end

endmodule