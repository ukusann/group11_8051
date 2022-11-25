`timescale 1ns / 1ps

// --------------------------------------------------
// BEGIN Defines declarations:
`define START   3'b000
`define FETCH   3'b001
`define DECODE  3'b010
`define INPUT   3'b011
`define OUTPUT  3'b100
`define DEC     3'b101
`define JNZ     3'b110
`define HALT    3'b111

`define DISABLE 1'b0
`define ENABLE  1'b1


// END OF Defines declarations:
// --------------------------------------------------

//====================================================
//====================================================

module ctrlunit( 
// --------------------------------------------------
// BEGIN Variables declarations:
input clock,
input reset,
input wire cond_A,
input wire [2:0] IR_op,       // 3 bits Instroction Registor (RI7, RI6, RI5)

output wire PCload,
output wire IRload,
output wire INmux,
output wire Aload,
output wire JNZmux,
output wire Halt,
output wire Out_enable
// END OF Variables declarations:
// --------------------------------------------------
);

//====================================================
//====================================================

// --------------------------------------------------
// BEGIN Signals:
reg[2:0] state;
wire[2:0] next_state;
// END OF Signals:
// --------------------------------------------------
    
//====================================================
//====================================================

// --------------------------------------------------
// BEGIN Inicial variables :
initial
    state = `START;
// END OF Inicial variables:
// --------------------------------------------------

//====================================================
//====================================================

// --------------------------------------------------
// BEGIN Update Outputs:
assign PCload        = (!state[2] && !state[1] && state[0]) || 
                (state[2]  && state[1]  && !state[0] && cond_A);
                
assign IRload        =  !state[2] && !state[1] && state[0];

assign INmux         =  !state[2] && state[1]  && state[0];

assign Aload         = (!state[2] && state[1]  && state[0]) || 
                (state[2]  && !state[1] && state[0]);
                
assign JNZmux        =  state[2]  && state[1]  && !state[0];

assign Halt          =  state[2]  && state[1]  && state[0];

assign Out_enable    =  state[2] && !state[1] && !state[0];
// END OF Update Outputs:
// --------------------------------------------------

//====================================================
//====================================================

// --------------------------------------------------
// BEGIN State Machine:
assign next_state[2] = (state[2]  && state[1]  && state[0]) ||  
                        (!state[2]  && state[1]  && !state[0] && IR_op[2]);
                        
assign next_state[1] = (state[2]  && state[1]  && state[0]) ||
                        (!state[2] && state[1]  && !state[0] && 
                        ((IR_op[1] && IR_op[0]) || (IR_op[2] && IR_op[1]) )) ||
                        (!state[2] && !state[1] && state[0]);
                        
                        
assign next_state[0] = (state[2]  && state[1]  && state[0]) ||
                        (!state[2] && state[1]  && !state[0] && 
                        ((IR_op[1] && IR_op[0]) || (IR_op[2] && IR_op[0]) )) ||
                        (!state[2] && !state[1] && !state[0]);
// END OF State MAchine:
// --------------------------------------------------

//====================================================
//====================================================

// --------------------------------------------------
// BEGIN Update State:
always @ (posedge clock)
    
    begin
    if (reset == `ENABLE)
        state   = `START;
    else
        state <= next_state;
    end
// END OF Update State:
// --------------------------------------------------

//====================================================
//====================================================
endmodule