`ifndef __define_lib_vh__
`define __define_lib_vh__

// Logical Enable
`define EN  1'b1

// memories addrs:
//_______________________________________________________________________
// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  RAM  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
`define DATA_LEN    8'hFF
`define SFR_LEN     8'h80
// ----- SFR: Special Functions Registers -----
`define A_ADDR      8'hE0    // accumulator
`define P0_ADDR     8'h80    // pointer
`define SP_ADDR     8'h81    // stack pointer
`define TMOD_ADDR   8'h89    // timer mode
`define DPL_ADDR    8'h82    // DPTR low
`define DPH_ADDR    8'h83    // DPTR high
`define TL0_ADDR    8'h8A    // timer counter 8 bits
`define TL1_ADDR    8'h8B    // timer counter 16 bits
`define TH0_ADDR    8'h8C    // auto-reload of counter 8 bits
`define TH1_ADDR    8'h8D    // auto-reload of counter 16 bits
`define IE_ADDR     8'hA8    // interruptions enables
`define IP_ADDR     8'hB8    // interruptions prioryties
`define PSW_ADDR    8'hD0    // program statment word
`define TCON_ADDR   8'h88    // timer control

// ----- Internal Registers -----
`define R0_ADDR   8'h00    // R0 register
`define R1_ADDR   8'h01    // R1 register
`define R2_ADDR   8'h02    // R2 register
`define R3_ADDR   8'h03    // R3 register
`define R4_ADDR   8'h04    // R4 register
`define R5_ADDR   8'h05    // R5 register
`define R6_ADDR   8'h06    // R6 register
`define R7_ADDR   8'h07    // R7 register

//----- Bit addresable -----
`define BIT_ADDR_MIN 8'h20 // bit address begin
`define BIT_ADDR_MAX 8'h30 // bit address final    

//_______________________________________________________________________
// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  ALU  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// ----- Opcodes -----
`define NO_OP 4'h0
`define ADD   4'hC
`define SUBB  4'h1
`define ANL   4'h2
`define ORL   4'h3
`define XRL   4'h4
`define RL    4'h5
`define RR    4'h6
`define SETB  4'h7
`define CLR   4'h8
`define CPL   4'h9
`define INC   4'hA
`define DEC   4'hB

// `define MSB_4           8'h03
// `define MSB_8           8'h07

`define MSB_4           3
`define MSB_8           7
`endif
