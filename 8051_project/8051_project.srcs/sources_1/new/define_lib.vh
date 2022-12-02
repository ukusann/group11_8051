`ifndef __define_lib_vh__
`define __define_lib_vh__

// Logical Enable
`define EN  1'b1

// memories addrs:

// ----- SFR: Special Functions Registers -----
`define A_ADDR      16'hE0    // acumulator
`define P0_ADDR     16'h80    // pointer
`define SP_ADDR     16'h81    // stack pointer
`define TMOD_ADDR   16'h89    // timer mode
`define DPL_ADDR    16'h82    // DPTR low
`define DPH_ADDR    16'h83    // DPTR high
`define TL0_ADDR    16'h8A    // timer counter 8 bits
`define TL1_ADDR    16'h8B    // timer counter 16 bits
`define TH0_ADDR    16'h8C    // auto-reload of counter 8 bits
`define TH1_ADDR    16'h8D    // auto-reload of counter 16 bits
`define IE_ADDR     16'hA8    // interruptions enables
`define IP_ADDR     16'hB8    // interruptions prioryties
`define PSW_ADDR    16'hD0    // program statment word
`define TCON_ADDR   16'h88    // timer control
  
`endif
