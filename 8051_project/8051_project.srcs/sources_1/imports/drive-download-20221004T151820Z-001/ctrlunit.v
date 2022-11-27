`timescale 1ns / 1ps

// --------------------------------------------------
// BEGIN Defines declarations:

// Start State Machine defines
`define STATE_LEN  3'h6

`define _START   6'b000000
`define _FETCH   6'b000001
`define _DECODE  6'b000010
`define _MOV     6'b000011
`define _ADD     6'b000100
`define _SUBB    6'b000101
`define _DEC     6'b000110
`define _INC     6'b000111
`define _XRL     6'b001000
`define _ANL     6'b001001
`define _ORL     6'b001011
`define _CPL     6'b001100
`define _SETB    6'b001101
`define _CLR     6'b001111
`define _RL      6'b010000
`define _RR      6'b010001
`define _ACALL_1 6'b010010
`define _LCALL_1 6'b010011
`define _RET_1   6'b010100
`define _JNB_1   6'b010101
`define _JB_1    6'b010110
`define _JNC_1   6'b010111
`define _JC_1    6'b011000
`define _CJNE_1  6'b011001
`define _ACALL_2 6'b011010
`define _LCALL_2 6'b011011
`define _RET_2   6'b011100
`define _JNB_2   6'b011101
`define _JB_2    6'b011110
`define _JNC_2   6'b011111
`define _JC_2    6'b100000
`define _CJNE_2  6'b100001
// End of State Machine defines

// Start of OPcode defines
`define OPCODE_LEN  4'h8

`define OP_MOV_Ri       8'hF6
`define OP_MOV_DATA     8'hF5
`define OP_MOV_DIRECT   8'h85
`define OP_ADD_DIRECT   8'h25
`define OP_ADD_REG      8'h28
`define OP_SUB_DIRECT   8'h95
`define OP_SUB_REG      8'h98
`define OP_DEC          8'h18
`define OP_INC          8'h08
`define OP_XOR_DIRECT   8'h68
`define OP_XOR_REG      8'h62
`define OP_AND_DIRECT   8'h58
`define OP_AND_REG      8'h52
`define OP_OR_DIRECT    8'h48
`define OP_OR_REG       8'h42
`define OP_CPL_BIT      8'hB2
`define OP_CPL_A        8'hF4
`define OP_SETB         8'hD2
`define OP_CLR          8'hE4
`define OP_RL           8'h23
`define OP_RR           8'h03
`define OP_ACALL        8'h11
`define OP_LCALL        8'h12
`define OP_JNB          8'h30
`define OP_JB           8'h20
`define OP_JC           8'h40
`define OP_CJNE         8'hB5
// End of OPcode defines


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
input wire [`OPCODE_LEN -4'b1 :0] IR_op,       // 8 bits Instroction Registor (RI7, RI6, RI5)

output wire PCload,
output wire IRload,
output wire Aload,
output wire Add,
output wire Sub,
output wire Dec,
output wire Inc,
output wire Xor,
output wire And,
output wire Or,
output wire Cpl_1,
output wire Cpl_8,
output wire Rr,
output wire Rl
// END OF Variables declarations:
// --------------------------------------------------
);

//====================================================
//====================================================

// --------------------------------------------------
// BEGIN Signals:
reg [`STATE_LEN -3'b1 :0] state;
reg [`STATE_LEN -3'b1 :0] next_state;
// END OF Signals:
// --------------------------------------------------
    
//====================================================
//====================================================

// --------------------------------------------------
// BEGIN Inicial variables :
initial
    state = `_START;
// END OF Inicial variables:
// --------------------------------------------------

//====================================================
//====================================================

// --------------------------------------------------
// BEGIN Update Outputs:

// END OF Update Outputs:
// --------------------------------------------------

//====================================================
//====================================================



// BEGIN State Machine:
always @ (state)
    
    begin
    case(state)
        `_START: begin
            next_state <= `_FETCH;
        end
        `_FETCH: begin
            next_state <= `_DECODE; 
        end
        `_DECODE: begin
            next_state <= `_DECODE;
        end
        `_MOV: begin
        end
        `_ADD: begin   
        end
        `_SUBB: begin
        end
        `_DEC: begin
        end
        `_INC: begin 
        end
        `_XRL: begin 
        end
        `_ANL: begin
        end
        `_ORL: begin
        end
        `_CPL: begin
        end
        `_SETB: begin
        end
        `_CLR: begin
        end
        `_RL: begin
        end
        `_RR: begin
        end
        `_ACALL_1: begin
        end
        `_ACALL_2: begin
        end
        `_LCALL_1: begin
        end
        `_LCALL_2: begin
        end
        `_RET_1: begin
        end
        `_RET_2: begin
        end
        `_JNB_1: begin
        end
        `_JNB_2: begin
        end
        `_JB_1: begin
        end
        `_JB_2: begin
        end
        `_JNC_1: begin
        end
        `_JNC_2: begin
        end
        `_JC_1: begin 
        end
        `_JC_2: begin 
        end
        `_CJNE_1: begin
        end
        `_CJNE_2: begin
        end
        default: begin
        end
     endcase
    
    end

// END OF State MAchine:
// --------------------------------------------------

//====================================================
//====================================================

// --------------------------------------------------
// BEGIN Update State:
always @ (posedge clock)
    
    begin
    if (reset == `ENABLE)
        state   = `_START;
    else
        state <= next_state;
    end
// END OF Update State:
// --------------------------------------------------

//====================================================
//====================================================
endmodule