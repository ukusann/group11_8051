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
input wire cond_C,
input wire cond_P,
input wire cond_bit,
input wire cond_A_dir,

output wire PCload,
output wire IRload,
output wire INmux,
output wire Aload,
output wire JMPmux,
output wire OP_register,
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
assign PCload  =    (state == `_FETCH || state == `_ACALL_1 
                    || state == `_ACALL_2 || state == `_LCALL_1 
                    || state == `_LCALL_2 || state == `_RET_1 
                    || state == `_RET_2 || state == `_JNB_1 
                    || state == `_JNB_2 || state == `_JB_1 
                    || state == `_JB_2 || state == `_JNC_1 
                    || state == `_JNC_2 || state == `_JC_1 
                    || state == `_JC_2 || state == `_CJNE_1 
                    || state == `_CJNE_2)     ? `ENABLE : `DISABLE;

assign IRload  =    (state == `_FETCH)        ? `ENABLE : `DISABLE;

assign Aload   =    ((state == `_MOV && ~OP_register) || state == `_ADD 
                    || state == `_SUBB || state == `_XRL || state == `_ANL 
                    || state == `_ORL  || (state == `_CPL && Cpl_8) 
                    || state == `_RR   || state == `_RL || state == `_CJNE_1 
                    || state == `_CJNE_2)     ? `ENABLE : `DISABLE;

assign Add     =    (state == `_ADD)          ? `ENABLE : `DISABLE;
assign Sub     =    (state == `_SUBB)         ? `ENABLE : `DISABLE;
assign Dec     =    (state == `_DEC)          ? `ENABLE : `DISABLE;
assign Inc     =    (state == `_INC)          ? `ENABLE : `DISABLE;
assign Xor     =    (state == `_XRL)          ? `ENABLE : `DISABLE;
assign Or      =    (state == `_ORL)          ? `ENABLE : `DISABLE;
assign Cpl_1   =    (state == `_CPL && Cpl_1) ? `ENABLE : `DISABLE;
assign Cpl_8   =    (state == `_CPL && Cpl_8) ? `ENABLE : `DISABLE;
assign Rr      =    (state == `_RR)           ? `ENABLE : `DISABLE;
assign Rl      =    (state == `_RL)           ? `ENABLE : `DISABLE;
// END OF Update Outputs:
// --------------------------------------------------

//====================================================
//====================================================



// BEGIN State Machine:
always @ (state) 
begin
    case(state)
        `_START: 
        begin
            next_state <= `_FETCH;
        end

        `_FETCH: 
        begin
            next_state <= `_DECODE; 
        end

        `_DECODE: 
        begin
            case(IR_op)
                `OP_MOV_Ri:
                begin
                    next_state <= `_MOV;
                end

                `OP_MOV_DATA:
                begin
                    next_state <= `_MOV;
                end
                
                `OP_MOV_DIRECT:
                begin
                    next_state <= `_MOV;
                end

                `OP_ADD_DIRECT:
                begin
                    next_state <= `_ADD;
                end

                `OP_ADD_REG:
                begin
                    next_state <= `_ADD;
                end

                `OP_SUB_DIRECT:
                begin
                    next_state <= `_SUBB;
                end

                `OP_SUB_REG:
                begin
                    next_state <= `_SUBB;
                end 

                `OP_DEC:
                begin
                    next_state <= `_DEC;
                end

                `OP_INC:
                begin
                    next_state <= `_INC;
                end

                `OP_XOR_DIRECT:
                begin
                    next_state <= `_XRL;
                end

                `OP_XOR_REG:
                begin
                    next_state <= `_XRL;
                end

                `OP_MOV_DATA:
                begin
                    next_state <= `_MOV;
                end

                `OP_AND_DIRECT:
                begin
                    next_state <= `_ANL;
                end

                `OP_AND_REG:
                begin
                    next_state <= `_ANL;
                end

                `OP_OR_DIRECT:
                begin
                    next_state <= `_ORL;
                end

                `OP_OR_REG:
                begin
                    next_state <= `_ORL;
                end

                `OP_CPL_BIT:
                begin
                    next_state <= `_CPL;
                end                   

                `OP_CPL_A:
                begin
                    next_state <= `_CPL;
                end

                `OP_SETB:
                begin
                    next_state <= `_SETB;
                end

                `OP_CLR:
                begin
                    next_state <= `_CLR;
                end

                `OP_RL:
                begin
                    next_state <= `_RL;
                end

                `OP_RR:
                begin
                    next_state <= `_RR;
                end

                `OP_ACALL:
                begin
                    next_state <= `_ACALL_1;
                end
                
                `OP_LCALL:
                begin
                    next_state <= `_LCALL_1;
                end

                `OP_JNB:
                begin
                    next_state <= `_JNB_1;
                end

                `OP_JB:
                begin
                    next_state <= `_JB_1;
                end

                `OP_JC:
                begin
                    next_state <= `_JC_1;
                end

                `OP_CJNE:
                begin
                    next_state <= `_CJNE_1;
                end
                
                default:
                    next_state <= `_START; 
            endcase
        end

        `_MOV: 
        begin
            next_state <= `_START;
        end
        
        `_ADD: 
        begin   
            next_state <= `_START;
        end
        
        `_SUBB: 
        begin
            next_state <= `_START;
        end
        
        `_DEC: 
        begin
            next_state <= `_START;
        end
        
        `_INC: 
        begin 
            next_state <= `_START;
        end
        
        `_XRL: 
        begin 
            next_state <= `_START;
        end
        
        `_ANL: 
        begin
            next_state <= `_START;
        end
        
        `_ORL: 
        begin
            next_state <= `_START;
        end
        
        `_CPL: 
        begin
            next_state <= `_START;
        end
        
        `_SETB: 
        begin
            next_state <= `_START;
        end
        
        `_CLR: 
        begin
            next_state <= `_START;
        end
        
        `_RL: 
        begin
            next_state <= `_START;
        end
        
        `_RR: 
        begin
            next_state <= `_START;
        end
        
        `_ACALL_1: 
        begin
            next_state <= `_ACALL_2;
        end

        `_ACALL_2: 
        begin
            next_state <= `_START;
        end

        `_LCALL_1: 
        begin
            next_state <= `_LCALL_2;
        end
        
        `_LCALL_2: 
        begin
            next_state <= `_START;
        end
        
        `_RET_1: 
        begin
            next_state <= `_RET_2;
        end
        
        `_RET_2:
        begin
            next_state <= `_START;
        end
        
        `_JNB_1: 
        begin
            next_state <= `_JNB_2;
        end
        
        `_JNB_2: 
        begin
            next_state <= `_START;
        end
        
        `_JB_1: 
        begin
            next_state <= `_JB_2;
        end
        
        `_JB_2: 
        begin
            next_state <= `_START;
        end
        
        `_JNC_1: 
        begin  
            next_state <= `_JNC_2;
        end
        
        `_JNC_2: 
        begin
            next_state <= `_START;
        end
        
        `_JC_1: 
        begin 
            next_state <= `_JC_2;
        end
        
        `_JC_2: 
        begin 
            next_state <= `_START;
        end
        
        `_CJNE_1: 
        begin
            next_state <= `_CJNE_2;
        end
        
        `_CJNE_2: 
        begin
            next_state <= `_START;
        end
        
        default: 
        begin
            next_state <= `_START;
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


cu_ALU cu_ALU(
    .clock(clock),    
    .reset(reset),
    .Add(Add),
    .Sub(Sub),
    .Dec(Dec),
    .Inc(Inc),
    .Xor(Xor),
    .And(And),
    .Or(Or),
    .Cpl_1(Cpl_1),
    .Cpl_8(Cpl_8),
    .Rr(Rr),
    .Rl(Rl)
    );
    
    
cu_RAM cu_RAM(
    .clock(clock),    
    .reset(reset),
    .wr(wr),          
    .rd(rd),          
    .addr(addr),      
    .data_in(data_in),   
    .data_out(data_out),  
    .A(A),
    .P0(P0),
    .SP(SP),
    .TMOD(TMOD),
    .DPL(DPL),
    .DPH(DPH),
    .TL0(TL0),
    .TL1(TL1),
    .TH0(TH0),
    .TH1(TH1),
    .IE(IE),
    .IP(IP),
    .PSW(PSW),
    .TCON(TCON)   
);
endmodule
