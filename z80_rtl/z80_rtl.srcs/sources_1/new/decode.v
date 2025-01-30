`timescale 1ns / 1ps
`include "z80_defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2024 01:52:16 PM
// Design Name: 
// Module Name: decode
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module decode(
    input wire [7:0] IR,
    input wire [1:0] PLA_idx,
    input wire IX_pref, IY_pref, //need to add this to microsequencer later, DD, FD prefixes
    output reg [244:0] SIGNALS_PORT, //what are the next M-states? Could be up to 5 
    //(Changed from 7 to 5: prefixes now restart the M-cycles because redundant prefix (DD for example) is legal and 2nd one needs to be treated as M1, therefore always go back to M1
    output reg [1:0] next_PLA, //CB --> 01, ED --> 10, DDCB/FDCB opcode --> 11 (This gets latched in useq) (IMPORTANT: if nextPLA == b11, don't clear MSTATES at the end of the instruction, and latch b10 into MAX_CNT at the end of the mcycle)
    output reg [24:0] MSTATES_PORT, // exec signals for M-states
    output reg [2:0] MAX_CNT, //Num M-States to follow this fetch/decode (0 means only OCF happens)
    output reg [1:0] F_stall, //anded into the stall signals in usequencer probably
    output reg next_IX_pref, next_IY_pref, //this needs two latches each in useq - for example, we see DD: set next_IX latch to 1. When instruciton restarts (hitting max count), set current_IX latch to 1, and clear next_IX latch, only setting it again if we get another prefix.
    output reg no_int //useq latch interrupts not allowed, even if we reached max count (required for prefixes)
    );
    
    /*
        If DD (IX), restart with next IX pref (In the reg file, the HL, H, and L output in general, except toward the MAR, is replaced with IX, IXH, and IXL (when is H and L used anyway???))
        if DD (IY), restart with next IY pref (same but with IY)
        if CB, restart with CB PLA. if IX or IY present, maintain next IX and next IY but use DDCB/FDCB PLA (need to insert states to get (IX + D) into MDR... - I think we need to load them in, and have the useq not clear them at the end of this mcycle)
        IF ED, restart with ED PLA
    */
    
    wire[1:0] x, p;
    wire[2:0] y, z;
    wire q;
    assign x = IR[7:6];
    assign y = IR[5:3];
    assign p = IR[5:4];
    assign q = IR[3];
    assign z = IR[2:0];
    integer M1, M2, M3, M4, M5;
    
    always @(*) begin : named_block
    reg [56:0] SIGNALS [4:0];
    reg [4:0] MSTATES [4:0];
        integer i;
        for(i = 0; i < 7; i = i+1) begin
            MSTATES[i] = 53'b0;
            SIGNALS[i] = 7'b0;
        end
        MAX_CNT = 3'b0;
        next_PLA = 0;
        F_stall = 0;
        next_IX_pref = 0;
        next_IY_pref = 0;
        no_int = 0;
        
        
        M1 = 0;
        M2 = 1;
        M3 = 2;
        M4 = 3;
        M5 = 4;

        
        case (PLA_idx)
            2'b00:begin //this is the default PLA
                case (x)
                    2'b00:begin //x = 0
                        case(z)
                            3'b000:begin//z = 0
                                case(y)
                                    3'b000:begin //NOP
                                        //NOP
                                    end
                                    3'b001:begin
                                        SIGNALS[M1][`ALU_OP] = `ALU_SWAP_REGS;
                                        
                                    end
                                    3'b010:begin //DJNZ
                                        SIGNALS[M1][`ALU_DEC_8BIT] = 1;
                                        SIGNALS[M1][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M1][`ALU_OP] = `ALU_DEC_8BIT;
                                        SIGNALS[M1][`LD_ACCUM] = 1;
                                        SIGNALS[M1][`MUX_EXEC_COND] = `MUX_EXEC_COND_NZ;
                                        SIGNALS[M1][`DEC_MCTR_CC] = 1;

                                        SIGNALS[M3][`SEXT_MDR] = 1;
                                        SIGNALS[M3][`ALU_OP] = `ALU_ADD_16BIT;
                                        SIGNALS[M3][`A_MUX] = `A_MUX_PC;
                                        SIGNALS[M3][`B_MUX] = `B_MUX_MDR;
                                        SIGNALS[M3][`LD_PC] = 1;
                                        SIGNALS[M3][`PCMUX] = `PCMUX_ALU;

                                        
                                        //OD, IO
                                        MSTATES[M2] = `ODL;
                                        MSTATES[M3] = `IO;
                                        MAX_CNT = 2;
                                    end
                                    3'b011:begin //JR e
                                        SIGNALS[M3][`SEXT_MDR] = 1;
                                        SIGNALS[M3][`ALU_OP] = `ALU_ADD_16BIT;
                                        SIGNALS[M3][`A_MUX] = `A_MUX_PC;
                                        SIGNALS[M3][`B_MUX] = `B_MUX_MDR;
                                        SIGNALS[M3][`LD_PC] = 1;
                                        SIGNALS[M3][`PCMUX] = `PCMUX_ALU;

                                        //OD, IO
                                        MSTATES[M2] = `ODL;
                                        MSTATES[M3] = `IO;
                                        MAX_CNT = 2;
                                    end
                                    3'b100, 3'b101, 3'b110, 3'b111:begin //JR cc, e
                                        SIGNALS[M1][`MUX_EXEC_COND] = `MUX_EXEC_COND_Y_SUB_4;
                                        SIGNALS[M1][`DEC_MCTR_CC] = 1;

                                        SIGNALS[M3][`SEXT_MDR] = 1;
                                        SIGNALS[M3][`ALU_OP] = `ALU_ADD_16BIT;
                                        SIGNALS[M3][`A_MUX] = `A_MUX_PC;
                                        SIGNALS[M3][`B_MUX] = `B_MUX_MDR;
                                        SIGNALS[M3][`LD_PC] = 1;
                                        SIGNALS[M3][`PCMUX] = `PCMUX_ALU;

                                        //OD, IO
                                        MSTATES[M2] = `ODL;
                                        MSTATES[M3] = `IO;
                                        MAX_CNT = 2;
                                    end
                                endcase
                            end
                            3'b001:begin//z = 1
                                case(q)
                                    1'b0: begin //ld rp[p], nn
                                        SIGNALS[M3][`RP_TABLE] = 0; //default is 0
                                        SIGNALS[M3][`B_MUX] = `B_MUX_MDR;
                                        SIGNALS[M3][`ALU_OP] = `ALU_PASSB;
                                        SIGNALS[M3][`RP] = 1;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_DR; //it's actually P, not Y, if RP is set
                                        SIGNALS[M3][`LD_REG] = 1;

                                        //ODL, ODH
                                        MSTATES[M2] = `ODL;
                                        MSTATES[M3] = `ODH;
                                        MAX_CNT = 2;
                                    end
                                    1'b1: begin //add HL, rp[p]
                                        SIGNALS[M3][`A_MUX] = `A_MUX_HL;
                                        SIGNALS[M3][`B_MUX] = `B_MUX_SR2;
                                        SIGNALS[M3][`ALU_OP] = `ALU_ADD_16BIT;
                                        SIGNALS[M3][`RP] = 1;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_HL;
                                        SIGNALS[M3][`LD_REG] = 1;

                                        //IO, IO
                                        MSTATES[M2] = `IO;
                                        MSTATES[M3] = `IO;
                                        MAX_CNT = 2;
                                    end
                                endcase
                            end
                            3'b010:begin //z = 2
                                case(q)
                                    1'b0: begin
                                        case(p)
                                            2'b0, 2'b1: begin //LD (BC/DE), A
                                                SIGNALS[M1][`ALU_OP] = `ALU_PASSA;
                                                SIGNALS[M1][`A_MUX] = `A_MUX_A;
                                                SIGNALS[M1][`LD_MDR] = 1;
                                                SIGNALS[M1][`RP] = 1;
                                                SIGNALS[M1][`LD_MAR] = 1;
                                                SIGNALS[M1][`MAR_MUX] = 0;

                                                //MW
                                                MSTATES[M2] = `MW;
                                                MAX_CNT = 1;
                                            end
                                            2'b10: begin //LD (nn), HL
                                                SIGNALS[M3][`ALU_OP] = `ALU_PASSA;
                                                SIGNALS[M3][`A_MUX] = `A_MUX_HL;
                                                SIGNALS[M3][`LD_MDR] = 1;
                                                SIGNALS[M3][`LD_MAR] = 1;
                                                SIGNALS[M3][`MAR_MUX] = 1;

                                                //ODL, ODH, MRL, MRH
                                                MSTATES[M2] = `ODL;
                                                MSTATES[M3] = `ODH;
                                                MSTATES[M4] = `MRL;
                                                MSTATES[M5] = `MRH;
                                                MAX_CNT = 4;
                                            end
                                            2'b11: begin //LD (nn), A
                                                SIGNALS[M3][`ALU_OP] = `ALU_PASSA;
                                                SIGNALS[M3][`A_MUX] = `A_MUX_A;
                                                SIGNALS[M3][`LD_MDR] = 1;
                                                SIGNALS[M3][`LD_MAR] = 1;
                                                SIGNALS[M3][`MAR_MUX] = 1;

                                                //ODL, ODH, MR
                                                MSTATES[M2] = `ODL;
                                                MSTATES[M3] = `ODH;
                                                MSTATES[M4] = `MR;
                                                MAX_CNT = 3;
                                            end
                                        endcase
                                    end
                                    1'b1: begin 
                                        case(p)
                                            2'b0, 2'b1: begin //load MAR with RP in M1, MRD to A in M2
                                                SIGNALS[M1][`RP] = 1;
                                                SIGNALS[M1][`LD_MAR] = 1;
                                                SIGNALS[M2][`B_MUX] = `B_MUX_MDR;
                                                SIGNALS[M2][`ALU_OP] = `ALU_PASSB;
                                                SIGNALS[M2][`LD_ACCUM] = 1;
                                                
                                                //MR
                                                MSTATES[M2] = `MR;
                                                MAX_CNT = 1;

                                            end
                                            2'b10: begin //MDR to MAR in M3, MDR to HL in M4
                                                SIGNALS[M3][`MAR_MUX] = 1;
                                                SIGNALS[M3][`LD_MAR] = 1;
                                                SIGNALS[M4][`B_MUX] = `B_MUX_MDR;
                                                SIGNALS[M4][`ALU_OP] = `ALU_PASSB;
                                                SIGNALS[M4][`DR_MUX] = `DR_MUX_HL;

                                                //ODL, ODH, MRL, MRH
                                                MSTATES[M2] = `ODL;
                                                MSTATES[M3] = `ODH;
                                                MSTATES[M4] = `MRL;
                                                MSTATES[M5] = `MRH;
                                                MAX_CNT = 4;
                                            end
                                            2'b11: begin //MDR to MAR in M3, MDR to A in M4
                                                SIGNALS[M3][`MAR_MUX] = 1;
                                                SIGNALS[M3][`LD_MAR] = 1;
                                                SIGNALS[M4][`B_MUX] = `B_MUX_MDR;
                                                SIGNALS[M4][`ALU_OP] = `ALU_PASSB;
                                                SIGNALS[M4][`LD_ACCUM] = 1;

                                                //ODL, ODH, MR
                                                MSTATES[M2] = `ODL;
                                                MSTATES[M3] = `ODH;
                                                MSTATES[M4] = `MR;
                                                MAX_CNT = 3;
                                            end
                                        endcase
                                    end
                                endcase
                            end
                            //z = 3
                            3'b011:begin
                                case(q)
                                    1'b0: begin //increment rp[p]
                                        SIGNALS[M1][`RP_TABLE] = 1;
                                        SIGNALS[M1][`A_MUX] = `A_MUX_Y;
                                        SIGNALS[M1][`RP] = 1;
                                        SIGNALS[M1][`ALU_OP] = `ALU_INC_16BIT;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_DR;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        F_stall = 2'd2;


                                    end
                                    1'b1: begin //decrement rp[p]
                                        SIGNALS[M1][`RP_TABLE] = 1;
                                        SIGNALS[M1][`A_MUX] = `A_MUX_Y;
                                        SIGNALS[M1][`RP] = 1;
                                        SIGNALS[M1][`ALU_OP] = `ALU_DEC_16BIT;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_DR;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        F_stall = 2'd2;
                                    end
                                endcase
                            end
                            3'b100:begin
                                case(y)
                                    3'b110:begin //Increment r[y] (8 bit)
                                        SIGNALS[M1][`A_MUX] = `A_MUX_Y;
                                        SIGNALS[M1][`ALU_OP] = `ALU_INC_8BIT;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_DR;
                                        SIGNALS[M1][`LD_REG] = 1;
                                    end
                                    default:begin //INC (HL) Increment memory at HL (16 bit)
                                        if(IX_pref || IY_pref) begin 
                                            SIGNALS[M4][`A_MUX] = `A_MUX_MDR;
                                            SIGNALS[M4][`ALU_OP] = `ALU_INC_16BIT;
                                            SIGNALS[M4][`LD_MDR] = 1;

                                            //OD, IO, MR, MW
                                            MSTATES[M2] = `ODL;
                                            MSTATES[M3] = `IO;
                                            MSTATES[M4] = `MR;
                                            MSTATES[M5] = `MW;
                                            MAX_CNT = 4;

                                            SIGNALS[M3][`ALU_OP] = `ALU_ADD_16BIT;
                                            SIGNALS[M3][`STALL_2] = 1;
                                            SIGNALS[M3][`A_MUX] = `A_MUX_HL;
                                            SIGNALS[M3][`B_MUX] = `B_MUX_MDR;
                                            SIGNALS[M3][`LD_MAR] = 1;
                                            SIGNALS[M3][`MAR_MUX] = `MAR_MUX_ALU;
                                        end
                                        else begin
                                            SIGNALS[M1][`LD_MAR] = 1;
                                            SIGNALS[M2][`A_MUX] = `A_MUX_MDR;
                                            SIGNALS[M2][`ALU_OP] = `ALU_INC_16BIT;
                                            SIGNALS[M2][`LD_MDR] = 1;

                                            //MR, MW
                                            MSTATES[M2] = `MR;
                                            MSTATES[M3] = `MW;
                                            MAX_CNT = 2;
                                        end                      
                                        
                                        
                                        
                                    end
                                endcase
                            end
                            3'b101:begin
                                case(y)
                                    3'b110:begin //Decrement r[y] (8 bit)
                                        SIGNALS[M1][`A_MUX] = `A_MUX_Y;
                                        SIGNALS[M1][`ALU_OP] = `ALU_DEC_8BIT;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_DR;
                                        SIGNALS[M1][`LD_REG] = 1;
                                    end
                                    default:begin //Decrement memory at HL (16 bit)
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_DEC_16BIT;
                                        SIGNALS[M2][`LD_MDR] = 1;

                                        //MR, MW
                                        MSTATES[M2] = `MR;
                                        MSTATES[M3] = `MW;
                                        MAX_CNT = 2;
                                    end
                                endcase
                            end
                            3'b110:begin
                                case(y)
                                    3'b110:begin //in M2, mdr to memory at HL
                                        SIGNALS[M2][`LD_MAR] = 1;
                                        SIGNALS[M2][`MAR_MUX] = `MAR_MUX_HL;

                                        //OD, MW
                                        MSTATES[M2] = `ODL;
                                        MSTATES[M3] = `MW;
                                        MAX_CNT = 2;
                                        
                                    end
                                    default:begin //in M2, mdr to r[y]
                                        SIGNALS[M2][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M2][`DR_MUX] = `DR_MUX_DR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_PASSA;
                                        SIGNALS[M2][`LD_REG] = 1;

                                        //OD
                                        MSTATES[M2] = `ODL;
                                        MAX_CNT = 1;
                                    end
                                endcase
                            end
                            3'b111:begin
                                case(y)
                                    3'b0:begin //in M1, ALU RLCA
                                        SIGNALS[M1][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M1][`ALU_OP] = `ALU_RLCA;
                                        SIGNALS[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b1:begin //in M1, ALU RRCA
                                        SIGNALS[M1][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M1][`ALU_OP] = `ALU_RRCA;
                                        SIGNALS[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b10:begin //in M1, ALU RLA
                                        SIGNALS[M1][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M1][`ALU_OP] = `ALU_RLA;
                                        SIGNALS[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b11:begin //in M1, ALU RRA
                                        SIGNALS[M1][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M1][`ALU_OP] = `ALU_RRA;
                                        SIGNALS[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b100:begin //in M1, ALU DAA
                                        SIGNALS[M1][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M1][`ALU_OP] = `ALU_DAA;
                                        SIGNALS[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b101:begin //in M1, ALU CPL
                                        SIGNALS[M1][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M1][`ALU_OP] = `ALU_CPL;
                                        SIGNALS[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b110:begin //in M1, ALU SCF
                                        SIGNALS[M1][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M1][`ALU_OP] = `ALU_SCF;
                                        SIGNALS[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b111:begin //in M1, ALU CCF
                                        SIGNALS[M1][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M1][`ALU_OP] = `ALU_CCF;
                                        SIGNALS[M1][`LD_ACCUM] = 1;
                                    end
                                endcase
                            end
                        endcase
                    end
                    2'b01:begin //x = 1
                        case(z)
                            3'b110:begin 
                                case(y)
                                    3'b011:begin //HALT
                                        SIGNALS[M1][`HALT] = 1;
                                    end
                                    default:begin //LD r[y], (HL)
                                        if(IX_pref || IY_pref) begin 
                                            SIGNALS[M4][`A_MUX] = `A_MUX_MDR;
                                            SIGNALS[M4][`DR_MUX] = `DR_MUX_DR;
                                            SIGNALS[M4][`ALU_OP] = `ALU_PASSA;
                                            SIGNALS[M4][`LD_REG] = 1;  
                                            //OD, IO, MR

                                            MSTATES[M2] = `ODL;
                                            MSTATES[M3] = `IO;
                                            MSTATES[M4] = `MR; 
                                            MAX_CNT = 3;

                                            SIGNALS[M3][`ALU_OP] = `ALU_ADD_16BIT;
                                            SIGNALS[M3][`STALL_2] = 1;
                                            SIGNALS[M3][`A_MUX] = `A_MUX_HL;
                                            SIGNALS[M3][`B_MUX] = `B_MUX_MDR;
                                            SIGNALS[M3][`LD_MAR] = 1;
                                            SIGNALS[M3][`MAR_MUX] = `MAR_MUX_ALU;
                                        end
                                        else begin
                                            SIGNALS[M1][`LD_MAR] = 1;
                                            SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;  
                                            SIGNALS[M2][`A_MUX] = `A_MUX_MDR;
                                            SIGNALS[M2][`DR_MUX] = `DR_MUX_DR;
                                            SIGNALS[M2][`ALU_OP] = `ALU_PASSA;
                                            SIGNALS[M2][`LD_REG] = 1;  
                                            //MR
                                            MSTATES[M2] = `MR;  
                                            MAX_CNT = 2; 
                                        end                       
                                    end
                                endcase
                            end
                            default:begin
                                case(y)
                                    3'b110:begin //LD (HL), r[z]
                                        
                                        if(IX_pref || IY_pref) begin 
                                            //OD, IO, Mw

                                            MSTATES[M2] = `ODL;
                                            MSTATES[M3] = `IO;
                                            MSTATES[M4] = `MW; 
                                            MAX_CNT = 3;

                                            SIGNALS[M3][`ALU_OP] = `ALU_ADD_16BIT;
                                            SIGNALS[M3][`STALL_2] = 1;
                                            SIGNALS[M3][`A_MUX] = `A_MUX_HL;
                                            SIGNALS[M3][`B_MUX] = `B_MUX_MDR;
                                            SIGNALS[M3][`LD_MAR] = 1;
                                            SIGNALS[M3][`MAR_MUX] = `MAR_MUX_ALU;

                                            SIGNALS[M3][`LD_MDR] = 1;
                                            SIGNALS[M3][`MDR_MUX] = `MDR_MUX_Z;
                                        end
                                        else begin
                                            SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                            SIGNALS[M1][`LD_MAR] = 1;
                                            SIGNALS[M1][`ALU_OP] = `ALU_PASSA;
                                            SIGNALS[M1][`A_MUX] = `A_MUX_Z;
                                            SIGNALS[M1][`LD_MDR] = 1;

                                            //MW
                                            MSTATES[M2] = `MW; 
                                            MAX_CNT = 2;
                                        end                      
                                        
                                        
                                    end
                                    default:begin //LD r[y], r[z]
                                        SIGNALS[M1][`A_MUX] = `A_MUX_Z;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_DR;
                                        SIGNALS[M1][`ALU_OP] = `ALU_PASSA;
                                        SIGNALS[M1][`LD_REG] = 1;
                                    end
                                endcase
                            end
                        endcase
                    end
                    2'b10:begin //x = 2
                        case(z)
                            3'b110:begin //order ADD, SUB, AND, OR, ADC, SBC, XOR, CP
                                case(y)
                                    3'b000:begin //ADD A, (HL)
                                        if(IX_pref || IY_pref) begin 

                                            SIGNALS[M4][`A_MUX] = `A_MUX_A;
                                            SIGNALS[M4][`B_MUX] = `B_MUX_MDR;
                                            SIGNALS[M4][`ALU_OP] = `ALU_ADD_8BIT;
                                            SIGNALS[M4][`LD_ACCUM] = 1;

                                            //OD, IO, MR
                                            MSTATES[M2] = `ODL;
                                            MSTATES[M3] = `IO;
                                            MSTATES[M4] = `MR;
                                            MAX_CNT = 3;

                                            SIGNALS[M3][`ALU_OP] = `ALU_ADD_16BIT;
                                            SIGNALS[M3][`STALL_2] = 1;
                                            SIGNALS[M3][`A_MUX] = `A_MUX_HL;
                                            SIGNALS[M3][`B_MUX] = `B_MUX_MDR;
                                            SIGNALS[M3][`LD_MAR] = 1;
                                            SIGNALS[M3][`MAR_MUX] = `MAR_MUX_ALU;
                                        end
                                        else begin
                                            SIGNALS[M1][`LD_MAR] = 1;
                                            SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                            SIGNALS[M2][`A_MUX] = `A_MUX_A;
                                            SIGNALS[M2][`B_MUX] = `B_MUX_SR2;
                                            SIGNALS[M2][`ALU_OP] = `ALU_ADD_8BIT;
                                            SIGNALS[M2][`LD_ACCUM] = 1;
                                            //MR
                                            MSTATES[M2] = `MR;
                                            MAX_CNT = 1;
                                        end              

                                        
                                    end
                                    3'b001:begin //SUB A, (HL)
                                        if(IX_pref || IY_pref) begin 
                                            SIGNALS[M4][`A_MUX] = `A_MUX_A;
                                            SIGNALS[M4][`B_MUX] = `B_MUX_MDR;
                                            SIGNALS[M4][`ALU_OP] = `ALU_SUB_8BIT;
                                            SIGNALS[M4][`LD_ACCUM] = 1;

                                            //OD, IO, MR
                                            MSTATES[M2] = `ODL;
                                            MSTATES[M3] = `IO;
                                            MSTATES[M4] = `MR;
                                            MAX_CNT = 3;

                                            SIGNALS[M3][`ALU_OP] = `ALU_ADD_16BIT;
                                            SIGNALS[M3][`STALL_2] = 1;
                                            SIGNALS[M3][`A_MUX] = `A_MUX_HL;
                                            SIGNALS[M3][`B_MUX] = `B_MUX_MDR;
                                            SIGNALS[M3][`LD_MAR] = 1;
                                            SIGNALS[M3][`MAR_MUX] = `MAR_MUX_ALU;
                                        end
                                        else begin
                                            SIGNALS[M1][`LD_MAR] = 1;
                                            SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                            SIGNALS[M2][`A_MUX] = `A_MUX_A;
                                            SIGNALS[M2][`B_MUX] = `B_MUX_SR2;
                                            SIGNALS[M2][`ALU_OP] = `ALU_SUB_8BIT;
                                            SIGNALS[M2][`LD_ACCUM] = 1;
                                            //MR
                                            MSTATES[M2] = `MR;
                                            MAX_CNT = 1;
                                        end
                                    end
                                    3'b010:begin //AND A, (HL)
                                        if(IX_pref || IY_pref) begin 
                                            SIGNALS[M4][`A_MUX] = `A_MUX_A;
                                            SIGNALS[M4][`B_MUX] = `B_MUX_MDR;
                                            SIGNALS[M4][`ALU_OP] = `ALU_AND_8BIT;
                                            SIGNALS[M4][`LD_ACCUM] = 1;

                                            //OD, IO, MR
                                            MSTATES[M2] = `ODL;
                                            MSTATES[M3] = `IO;
                                            MSTATES[M4] = `MR;
                                            MAX_CNT = 3;

                                            SIGNALS[M3][`ALU_OP] = `ALU_ADD_16BIT;
                                            SIGNALS[M3][`STALL_2] = 1;
                                            SIGNALS[M3][`A_MUX] = `A_MUX_HL;
                                            SIGNALS[M3][`B_MUX] = `B_MUX_MDR;
                                            SIGNALS[M3][`LD_MAR] = 1;
                                            SIGNALS[M3][`MAR_MUX] = `MAR_MUX_ALU;
                                        end
                                        else begin
                                            SIGNALS[M1][`LD_MAR] = 1;
                                            SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                            SIGNALS[M2][`A_MUX] = `A_MUX_A;
                                            SIGNALS[M2][`B_MUX] = `B_MUX_SR2;
                                            SIGNALS[M2][`ALU_OP] = `ALU_AND_8BIT;
                                            SIGNALS[M2][`LD_ACCUM] = 1;
                                            //MR
                                            MSTATES[M2] = `MR;
                                            MAX_CNT = 1;
                                        end
                                    end
                                    3'b011:begin //OR A, (HL)
                                        if(IX_pref || IY_pref) begin 
                                            SIGNALS[M4][`A_MUX] = `A_MUX_A;
                                            SIGNALS[M4][`B_MUX] = `B_MUX_MDR;
                                            SIGNALS[M4][`ALU_OP] = `ALU_OR_8BIT;
                                            SIGNALS[M4][`LD_ACCUM] = 1;

                                            //OD, IO, MR
                                            MSTATES[M2] = `ODL;
                                            MSTATES[M3] = `IO;
                                            MSTATES[M4] = `MR;
                                            MAX_CNT = 3;

                                            SIGNALS[M3][`ALU_OP] = `ALU_ADD_16BIT;
                                            SIGNALS[M3][`STALL_2] = 1;
                                            SIGNALS[M3][`A_MUX] = `A_MUX_HL;
                                            SIGNALS[M3][`B_MUX] = `B_MUX_MDR;
                                            SIGNALS[M3][`LD_MAR] = 1;
                                            SIGNALS[M3][`MAR_MUX] = `MAR_MUX_ALU;
                                        end
                                        else begin
                                            SIGNALS[M1][`LD_MAR] = 1;
                                            SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                            SIGNALS[M2][`A_MUX] = `A_MUX_A;
                                            SIGNALS[M2][`B_MUX] = `B_MUX_SR2;
                                            SIGNALS[M2][`ALU_OP] = `ALU_OR_8BIT;
                                            SIGNALS[M2][`LD_ACCUM] = 1;
                                            //MR
                                            MSTATES[M2] = `MR;
                                            MAX_CNT = 1;
                                        end
                                    end
                                    3'b100:begin //ADC A, (HL)
                                        if(IX_pref || IY_pref) begin 
                                            SIGNALS[M4][`A_MUX] = `A_MUX_A;
                                            SIGNALS[M4][`B_MUX] = `B_MUX_MDR;
                                            SIGNALS[M4][`ALU_OP] = `ALU_ADC_8BIT;
                                            SIGNALS[M4][`LD_ACCUM] = 1;

                                            //OD, IO, MR
                                            MSTATES[M2] = `ODL;
                                            MSTATES[M3] = `IO;
                                            MSTATES[M4] = `MR;
                                            MAX_CNT = 3;

                                            SIGNALS[M3][`ALU_OP] = `ALU_ADD_16BIT;
                                            SIGNALS[M3][`STALL_2] = 1;
                                            SIGNALS[M3][`A_MUX] = `A_MUX_HL;
                                            SIGNALS[M3][`B_MUX] = `B_MUX_MDR;
                                            SIGNALS[M3][`LD_MAR] = 1;
                                            SIGNALS[M3][`MAR_MUX] = `MAR_MUX_ALU;
                                        end
                                        else begin
                                            SIGNALS[M1][`LD_MAR] = 1;
                                            SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                            SIGNALS[M2][`A_MUX] = `A_MUX_A;
                                            SIGNALS[M2][`B_MUX] = `B_MUX_SR2;
                                            SIGNALS[M2][`ALU_OP] = `ALU_ADC_8BIT;
                                            SIGNALS[M2][`LD_ACCUM] = 1;
                                            //MR
                                            MSTATES[M2] = `MR;
                                            MAX_CNT = 1;
                                        end
                                    end
                                    3'b101:begin //SBC A, (HL)
                                        if(IX_pref || IY_pref) begin 
                                            SIGNALS[M4][`A_MUX] = `A_MUX_A;
                                            SIGNALS[M4][`B_MUX] = `B_MUX_MDR;
                                            SIGNALS[M4][`ALU_OP] = `ALU_ADC_8BIT;
                                            SIGNALS[M4][`LD_ACCUM] = 1;

                                            //OD, IO, MR
                                            MSTATES[M2] = `ODL;
                                            MSTATES[M3] = `IO;
                                            MSTATES[M4] = `MR;
                                            MAX_CNT = 3;

                                            SIGNALS[M3][`ALU_OP] = `ALU_ADD_16BIT;
                                            SIGNALS[M3][`STALL_2] = 1;
                                            SIGNALS[M3][`A_MUX] = `A_MUX_HL;
                                            SIGNALS[M3][`B_MUX] = `B_MUX_MDR;
                                            SIGNALS[M3][`LD_MAR] = 1;
                                            SIGNALS[M3][`MAR_MUX] = `MAR_MUX_ALU;
                                        end
                                        else begin
                                            SIGNALS[M1][`LD_MAR] = 1;
                                            SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                            SIGNALS[M2][`A_MUX] = `A_MUX_A;
                                            SIGNALS[M2][`B_MUX] = `B_MUX_SR2;
                                            SIGNALS[M2][`ALU_OP] = `ALU_ADC_8BIT;
                                            SIGNALS[M2][`LD_ACCUM] = 1;
                                            //MR
                                            MSTATES[M2] = `MR;
                                            MAX_CNT = 1;
                                        end
                                    end
                                    3'b110:begin //XOR A, (HL)
                                        if(IX_pref || IY_pref) begin 
                                            SIGNALS[M4][`A_MUX] = `A_MUX_A;
                                            SIGNALS[M4][`B_MUX] = `B_MUX_MDR;
                                            SIGNALS[M4][`ALU_OP] = `ALU_ADC_8BIT;
                                            SIGNALS[M4][`LD_ACCUM] = 1;

                                            //OD, IO, MR
                                            MSTATES[M2] = `ODL;
                                            MSTATES[M3] = `IO;
                                            MSTATES[M4] = `MR;
                                            MAX_CNT = 3;

                                            SIGNALS[M3][`ALU_OP] = `ALU_ADD_16BIT;
                                            SIGNALS[M3][`STALL_2] = 1;
                                            SIGNALS[M3][`A_MUX] = `A_MUX_HL;
                                            SIGNALS[M3][`B_MUX] = `B_MUX_MDR;
                                            SIGNALS[M3][`LD_MAR] = 1;
                                            SIGNALS[M3][`MAR_MUX] = `MAR_MUX_ALU;
                                        end
                                        else begin
                                            SIGNALS[M1][`LD_MAR] = 1;
                                            SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                            SIGNALS[M2][`A_MUX] = `A_MUX_A;
                                            SIGNALS[M2][`B_MUX] = `B_MUX_SR2;
                                            SIGNALS[M2][`ALU_OP] = `ALU_ADC_8BIT;
                                            SIGNALS[M2][`LD_ACCUM] = 1;
                                            //MR
                                            MSTATES[M2] = `MR;
                                            MAX_CNT = 1;
                                        end
                                    end
                                    3'b111:begin //CP A, (HL)
                                        if(IX_pref || IY_pref) begin 
                                            SIGNALS[M4][`A_MUX] = `A_MUX_A;
                                            SIGNALS[M4][`B_MUX] = `B_MUX_MDR;
                                            SIGNALS[M4][`ALU_OP] = `ALU_CP;
                                            SIGNALS[M4][`LD_ACCUM] = 1;

                                            //OD, IO, MR
                                            MSTATES[M2] = `ODL;
                                            MSTATES[M3] = `IO;
                                            MSTATES[M4] = `MR;
                                            MAX_CNT = 3;

                                            SIGNALS[M3][`ALU_OP] = `ALU_ADD_16BIT;
                                            SIGNALS[M3][`STALL_2] = 1;
                                            SIGNALS[M3][`A_MUX] = `A_MUX_HL;
                                            SIGNALS[M3][`B_MUX] = `B_MUX_MDR;
                                            SIGNALS[M3][`LD_MAR] = 1;
                                            SIGNALS[M3][`MAR_MUX] = `MAR_MUX_ALU;
                                        end
                                        else begin
                                            SIGNALS[M1][`LD_MAR] = 1;
                                            SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                            SIGNALS[M2][`A_MUX] = `A_MUX_A;
                                            SIGNALS[M2][`B_MUX] = `B_MUX_SR2;
                                            SIGNALS[M2][`ALU_OP] = `ALU_CP;
                                            SIGNALS[M2][`LD_ACCUM] = 1;
                                            //MR
                                            MSTATES[M2] = `MR;
                                            MAX_CNT = 1;
                                        end
                                    end
                                endcase                                
                            end
                            default:begin
                                case(y)
                                    3'b000:begin //ADD A, r[z]
                                        SIGNALS[M1][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M1][`B_MUX] = `B_MUX_SR2;
                                        SIGNALS[M1][`ALU_OP] = `ALU_ADD_8BIT;
                                        SIGNALS[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b001:begin //SUB A, r[z]
                                        SIGNALS[M1][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M1][`B_MUX] = `B_MUX_SR2;
                                        SIGNALS[M1][`ALU_OP] = `ALU_SUB_8BIT;
                                        SIGNALS[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b010:begin //AND A, r[z]
                                        SIGNALS[M1][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M1][`B_MUX] = `B_MUX_SR2;
                                        SIGNALS[M1][`ALU_OP] = `ALU_AND_8BIT;
                                        SIGNALS[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b011:begin //OR A, r[z]
                                        SIGNALS[M1][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M1][`B_MUX] = `B_MUX_SR2;
                                        SIGNALS[M1][`ALU_OP] = `ALU_OR_8BIT;
                                        SIGNALS[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b100:begin //ADC A, r[z]
                                        SIGNALS[M1][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M1][`B_MUX] = `B_MUX_SR2;
                                        SIGNALS[M1][`ALU_OP] = `ALU_ADC_8BIT;
                                        SIGNALS[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b101:begin //SBC A, r[z]
                                        SIGNALS[M1][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M1][`B_MUX] = `B_MUX_SR2;
                                        SIGNALS[M1][`ALU_OP] = `ALU_ADC_8BIT;
                                        SIGNALS[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b110:begin //XOR A, r[z]
                                        SIGNALS[M1][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M1][`B_MUX] = `B_MUX_SR2;
                                        SIGNALS[M1][`ALU_OP] = `ALU_ADC_8BIT;
                                        SIGNALS[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b111:begin //CP A, r[z]
                                        SIGNALS[M1][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M1][`B_MUX] = `B_MUX_SR2;
                                        SIGNALS[M1][`ALU_OP] = `ALU_CP;
                                        SIGNALS[M1][`LD_ACCUM] = 1;
                                    end
                                endcase
                            end
                        endcase
                    end
                    2'b11:begin //x = 3
                        case(z)
                            3'b000:begin //RET cc
                                SIGNALS[M1][`MUX_EXEC_COND] = `MUX_EXEC_COND_Y;
                                SIGNALS[M1][`DEC2_MCTR_CC] = 1;
                                F_stall = 2'd1;
                                SIGNALS[M3][`LD_PC] = 1;
                                SIGNALS[M3][`PCMUX] = `PCMUX_MDR;

                                //SRL, SRH
                                MSTATES[M2] = `SRL;
                                MSTATES[M3] = `SRH;
                                MAX_CNT = 2;

                            end
                            3'b001:begin 
                                case(q)
                                    1'b0:begin//POP rp2
                                        SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_DR;
                                        SIGNALS[M3][`ALU_OP] = `ALU_PASSA;
                                        SIGNALS[M3][`LD_REG] = 1;
                                        SIGNALS[M3][`RP] = 1;

                                        //SRL, SRH
                                        MSTATES[M2] = `SRL;
                                        MSTATES[M3] = `SRH;
                                        MAX_CNT = 2;
                                    end
                                    1'b1:begin
                                        case(p)
                                            2'b0:begin//RET
                                                SIGNALS[M3][`LD_PC] = 1;
                                                SIGNALS[M3][`PCMUX] = `PCMUX_MDR;
                                                //SRL, SRH
                                                MSTATES[M2] = `SRL;
                                                MSTATES[M3] = `SRH;
                                                MAX_CNT = 2;
                                            end
                                            2'b1:begin//EXX
                                                SIGNALS[M1][`EXX] = 1;
                                            end
                                            2'b10:begin//JP HL
                                                SIGNALS[M1][`LD_PC] = 1;
                                                SIGNALS[M1][`PCMUX] = `PCMUX_ALU;
                                                SIGNALS[M1][`A_MUX] = `A_MUX_HL;
                                                SIGNALS[M1][`ALU_OP] = `ALU_PASSA;
                                            end
                                            2'b11:begin//LD SP, HL
                                                SIGNALS[M3][`A_MUX] = `A_MUX_HL;
                                                F_stall = 2'd2;
                                                SIGNALS[M3][`ALU_OP] = `ALU_PASSA;
                                                SIGNALS[M3][`LD_REG] = 1;
                                                SIGNALS[M3][`DR_MUX] = `DR_MUX_SP;
                                            end
                                        endcase
                                    end
                                endcase
                            end
                            3'b010:begin //JP cc, nn
                                SIGNALS[M1][`MUX_EXEC_COND] = `MUX_EXEC_COND_Y;
                                SIGNALS[M1][`DEC2_MCTR_CC] = 1;
                                F_stall = 2'd1;
                                SIGNALS[M3][`PC_CONDLD] = 1;
                                SIGNALS[M3][`PCMUX] = `PCMUX_MDR;

                                //ODL, ODH
                                MSTATES[M2] = `ODL;
                                MSTATES[M3] = `ODH;
                                MAX_CNT = 2;
                            end
                            3'b011:begin
                                case(y)
                                    3'b000:begin //JP nn
                                        SIGNALS[M3][`LD_PC] = 1;
                                        SIGNALS[M3][`PCMUX] = `PCMUX_MDR;
                                        //ODL, ODH
                                        MSTATES[M2] = `ODL;
                                        MSTATES[M3] = `ODH;
                                        MAX_CNT = 2;
                                    end
                                    3'b001:begin //CB prefix
                                        if(IX_pref || IY_pref) begin
                                            next_PLA = 2'b11;
                                            next_IX_pref = IX_pref;
                                            next_IY_pref = IY_pref;
                                            MSTATES[M1] = `ODL;
                                            MSTATES[M2] = `IO;
                                            MSTATES[M3] = `IO2;
                                            MAX_CNT = 0; //the useq has to set this
                                            SIGNALS[M2][`ALU_OP] = `ALU_ADD_16BIT;
                                            SIGNALS[M2][`STALL_2] = 1;
                                            SIGNALS[M2][`A_MUX] = `A_MUX_HL;
                                            SIGNALS[M2][`B_MUX] = `B_MUX_MDR;
                                            SIGNALS[M2][`LD_MAR] = 1;
                                            SIGNALS[M2][`MAR_MUX] = `MAR_MUX_ALU;
                                        end
                                        else begin
                                            next_PLA = 2'b01;
                                        end
                                        no_int = 1;
                                    end
                                    3'b010:begin //OUT (n), A
                                        SIGNALS[M2][`MAR_MUX] = `MAR_MUX_MDR_A;
                                        SIGNALS[M2][`LD_MAR] = 1;
                                        SIGNALS[M2][`LD_MDR] = 1;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M2][`ALU_OP] = `ALU_PASSA;
                                        //OD, PW
                                        MSTATES[M2] = `ODL;
                                        MSTATES[M3] = `PW;
                                        MAX_CNT = 2;
                                    end
                                    3'b011:begin //IN A, (n)
                                        SIGNALS[M2][`MAR_MUX] = `MAR_MUX_MDR_A;
                                        SIGNALS[M2][`LD_MAR] = 1;
                                        SIGNALS[M2][`LD_MDR] = 1;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_DR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_PASSA;
                                        SIGNALS[M3][`LD_REG] = 1;
                                        SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M3][`ALU_OP] = `ALU_PASSA;
                                        //OD, PR
                                        MSTATES[M2] = `ODL;
                                        MSTATES[M3] = `PR;
                                        MAX_CNT = 2;
                                    end
                                    3'b100:begin //EX (SP), HL
                                        SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_HL;
                                        SIGNALS[M3][`ALU_OP] = `ALU_PASSA;
                                        SIGNALS[M3][`LD_MDR] = 1;
                                        SIGNALS[M3][`MDR_MUX] = 1;
                                        SIGNALS[M3][`STALL_1] = 1;
                                        SIGNALS[M5][`STALL_2] = 1;
                                        //SRL, SRH, SWH, SWL
                                        MSTATES[M2] = `SRL;
                                        MSTATES[M3] = `SRH;
                                        MSTATES[M4] = `SWH;
                                        MSTATES[M5] = `SWL;
                                        MAX_CNT = 4;
                                    end
                                    3'b101:begin //EX DE, HL
                                        SIGNALS[M1][`A_MUX] = `A_MUX_HL;
                                        SIGNALS[M1][`ALU_OP] = `ALU_PASSA;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_DE;
                                    end
                                    3'b110:begin //DI
                                        SIGNALS[M1][`INT_FF_RESET] = 1;
                                    end
                                    3'b111:begin //EI
                                        SIGNALS[M1][`INT_FF_SET] = 1;
                                    end
                                endcase
                            end
                            3'b100:begin //call CC, nn
                                SIGNALS[M1][`MUX_EXEC_COND] = `MUX_EXEC_COND_Y;
                                SIGNALS[M1][`DEC2_MCTR_CC] = 1;
                                SIGNALS[M3][`LD_PC] = 1;
                                SIGNALS[M3][`PCMUX] = `PCMUX_MDR;
                                SIGNALS[M3][`A_MUX] = `A_MUX_PC;
                                SIGNALS[M3][`ALU_OP] = `ALU_PASSA;
                                SIGNALS[M3][`LD_MDR] = 1;
                                SIGNALS[M3][`MDR_MUX] = 0;
                                SIGNALS[M3][`CONDSTALL] = 1;

                                //ODL, ODH, SWH, SWL
                                MSTATES[M2] = `ODL;
                                MSTATES[M3] = `ODH;
                                MSTATES[M4] = `SWH;
                                MSTATES[M5] = `SWL;
                                MAX_CNT = 4;
                            end
                            3'b101:begin
                                case(q)
                                    1'b0:begin //PUSH rp2
                                        SIGNALS[M1][`A_MUX] = `A_MUX_Y;
                                        SIGNALS[M1][`ALU_OP] = `ALU_PASSA;
                                        SIGNALS[M1][`LD_MDR] = 1;
                                        SIGNALS[M1][`RP] = 1;

                                        //SWH, SWL
                                        MSTATES[M2] = `SWH;
                                        MSTATES[M3] = `SWL;
                                        MAX_CNT = 2;
                                    end
                                    1'b1:begin
                                        case(p)
                                            2'b0:begin //CALL nn
                                                SIGNALS[M3][`STALL_1] = 1;
                                                SIGNALS[M3][`LD_MDR] = 1;
                                                SIGNALS[M3][`MDR_MUX] = 0;
                                                SIGNALS[M3][`A_MUX] = `A_MUX_PC;
                                                SIGNALS[M3][`ALU_OP] = `ALU_PASSA;
                                                SIGNALS[M3][`LD_PC] = 1;
                                                SIGNALS[M3][`PCMUX] = `PCMUX_MDR;

                                                //ODL, ODH, SWH, SWL
                                                MSTATES[M2] = `ODL;
                                                MSTATES[M3] = `ODH;
                                                MSTATES[M4] = `SWH;
                                                MSTATES[M5] = `SWL;
                                                MAX_CNT = 4;
                                            end
                                            2'b1:begin //DD prefix
                                                next_IX_pref = 1;
                                            end
                                            2'b10:begin //ED prefix
                                                next_PLA = 2'b10;
                                            end
                                            2'b11:begin //FD prefix
                                                next_IY_pref = 1;

                                            end
                                        endcase
                                    end     
                                endcase
                            end
                            3'b110:begin
                                case(y)
                                    3'b000:begin //ADD n
                                        SIGNALS[M2][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M2][`B_MUX] = `B_MUX_MDR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_ADD_8BIT;
                                        SIGNALS[M2][`LD_ACCUM] = 1;

                                        //OD
                                        MSTATES[M2] = `ODL;
                                        MAX_CNT = 1;
                                    end
                                    3'b001:begin //SUB n
                                        SIGNALS[M2][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M2][`B_MUX] = `B_MUX_MDR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_SUB_8BIT;
                                        SIGNALS[M2][`LD_ACCUM] = 1;
                                        //OD
                                        MSTATES[M2] = `ODL;
                                        MAX_CNT = 1;
                                    end
                                    3'b010:begin //AND n
                                        SIGNALS[M2][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M2][`B_MUX] = `B_MUX_MDR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_AND_8BIT;
                                        SIGNALS[M2][`LD_ACCUM] = 1;
                                        //OD
                                        MSTATES[M2] = `ODL;
                                        MAX_CNT = 1;
                                    end
                                    3'b011:begin //OR n
                                        SIGNALS[M2][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M2][`B_MUX] = `B_MUX_MDR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_OR_8BIT;
                                        SIGNALS[M2][`LD_ACCUM] = 1;
                                        //OD
                                        MSTATES[M2] = `ODL;
                                        MAX_CNT = 1;
                                    end
                                    3'b100:begin //ADC n
                                        SIGNALS[M2][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M2][`B_MUX] = `B_MUX_MDR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_ADC_8BIT;
                                        SIGNALS[M2][`LD_ACCUM] = 1;
                                        //OD
                                        MSTATES[M2] = `ODL;
                                        MAX_CNT = 1;
                                    end
                                    3'b101:begin //SBC n
                                        SIGNALS[M2][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M2][`B_MUX] = `B_MUX_MDR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_ADC_8BIT;
                                        SIGNALS[M2][`LD_ACCUM] = 1;
                                        //OD
                                        MSTATES[M2] = `ODL;
                                        MAX_CNT = 1;
                                    end
                                    3'b110:begin //XOR n
                                        SIGNALS[M2][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M2][`B_MUX] = `B_MUX_MDR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_ADC_8BIT;
                                        SIGNALS[M2][`LD_ACCUM] = 1;
                                        //OD
                                        MSTATES[M2] = `ODL;
                                        MAX_CNT = 1;
                                    end
                                    3'b111:begin //CP n
                                        SIGNALS[M2][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M2][`B_MUX] = `B_MUX_MDR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_CP;
                                        SIGNALS[M2][`LD_ACCUM] = 1;
                                        //OD
                                        MSTATES[M2] = `ODL;
                                        MAX_CNT = 1;
                                    end
                                endcase
                            end
                            3'b111:begin //RST y<<3
                                SIGNALS[M1][`A_MUX] = `A_MUX_PC;
                                SIGNALS[M1][`ALU_OP] = `ALU_PASSA;
                                SIGNALS[M1][`LD_MDR] = 1;
                                SIGNALS[M1][`MDR_MUX] = 0;
                                SIGNALS[M1][`LD_PC] = 1;
                                SIGNALS[M1][`PCMUX] = `PCMUX_Y_SHIFT;
                            end
                        endcase
                    end
                endcase
            end
            2'b01:begin //this is bit instructions PLA
                case(x)
                    2'b00:begin
                        case(z)
                            3'b110:begin 
                                case(y)
                                    3'b000:begin //RLC (HL)
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M2][`LD_MDR] = 1;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_RLCA;

                                        //MR, MW
                                        MSTATES[M2] = `MR;
                                        MSTATES[M3] = `MW;
                                        MAX_CNT = 2;
                                    end
                                    3'b001:begin //RRC (HL)
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M2][`LD_MDR] = 1;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_RRCA;
                                        //MR, MW
                                        MSTATES[M2] = `MR;
                                        MSTATES[M3] = `MW;
                                        MAX_CNT = 2;
                                    end
                                    3'b010:begin //RL (HL)
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M2][`LD_MDR] = 1;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_RLA;
                                        //MR, MW
                                        MSTATES[M2] = `MR;
                                        MSTATES[M3] = `MW;
                                        MAX_CNT = 2;
                                    end
                                    3'b011:begin //RR (HL)
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M2][`LD_MDR] = 1;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_RRA;
                                        //MR, MW
                                        MSTATES[M2] = `MR;
                                        MSTATES[M3] = `MW;
                                        MAX_CNT = 2;
                                    end
                                    3'b100:begin //SLA (HL)
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M2][`LD_MDR] = 1;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_SLA;
                                        //MR, MW
                                        MSTATES[M2] = `MR;
                                        MSTATES[M3] = `MW;
                                        MAX_CNT = 2;
                                    end
                                    3'b101:begin //SRA (HL)
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M2][`LD_MDR] = 1;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_SRA;
                                        //MR, MW
                                        MSTATES[M2] = `MR;
                                        MSTATES[M3] = `MW;
                                        MAX_CNT = 2;
                                    end
                                    3'b110:begin //SLL (HL)
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M2][`LD_MDR] = 1;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_SLL;
                                        //MR, MW
                                        MSTATES[M2] = `MR;
                                        MSTATES[M3] = `MW;
                                        MAX_CNT = 2;
                                    end
                                    3'b111:begin //SRL (HL)
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M2][`LD_MDR] = 1;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_SRL;
                                        //MR, MW
                                        MSTATES[M2] = `MR;
                                        MSTATES[M3] = `MW;
                                        MAX_CNT = 2;
                                    end
                                endcase
                            end
                            default:begin
                                case(y)
                                    3'b000:begin //RLC r[z]
                                        SIGNALS[M1][`A_MUX] = `A_MUX_Z;
                                        SIGNALS[M1][`ALU_OP] = `ALU_RLCA;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_Z;
                                    end
                                    3'b001:begin //RRC r[z]
                                        SIGNALS[M1][`A_MUX] = `A_MUX_Z;
                                        SIGNALS[M1][`ALU_OP] = `ALU_RRCA;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_Z;
                                    end
                                    3'b010:begin //RL r[z]
                                        SIGNALS[M1][`A_MUX] = `A_MUX_Z;
                                        SIGNALS[M1][`ALU_OP] = `ALU_RLA;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_Z;
                                    end
                                    3'b011:begin //RR r[z]
                                        SIGNALS[M1][`A_MUX] = `A_MUX_Z;
                                        SIGNALS[M1][`ALU_OP] = `ALU_RRA;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_Z;
                                    end
                                    3'b100:begin //SLA r[z]
                                        SIGNALS[M1][`A_MUX] = `A_MUX_Z;
                                        SIGNALS[M1][`ALU_OP] = `ALU_SLA;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_Z;
                                    end
                                    3'b101:begin //SRA r[z]
                                        SIGNALS[M1][`A_MUX] = `A_MUX_Z;
                                        SIGNALS[M1][`ALU_OP] = `ALU_SRA;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_Z;
                                    end
                                    3'b110:begin //SLL r[z]
                                        SIGNALS[M1][`A_MUX] = `A_MUX_Z;
                                        SIGNALS[M1][`ALU_OP] = `ALU_SLL;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_Z;
                                    end
                                    3'b111:begin //SRL r[z]
                                        SIGNALS[M1][`A_MUX] = `A_MUX_Z;
                                        SIGNALS[M1][`ALU_OP] = `ALU_SRL;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_Z;
                                    end
                                endcase 
                            end
                        endcase
                    end
                    2'b01:begin
                        case(z)
                            3'b110:begin //BIT y, (HL)
                                SIGNALS[M1][`LD_MAR] = 1;
                                SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                SIGNALS[M2][`A_MUX] = `A_MUX_MDR;
                                SIGNALS[M2][`ALU_OP] = `ALU_TEST_BASE + y; //this might not work
                                //MR
                                MSTATES[M2] = `MR;
                                MAX_CNT = 1;
                            end
                            default:begin //BIT y, r[z]
                                SIGNALS[M1][`A_MUX] = `A_MUX_Z;
                                SIGNALS[M1][`ALU_OP] = `ALU_TEST_BASE + y;
                            end
                        endcase
                    end
                    2'b10:begin
                        case(z)
                            3'b110:begin //RES y, (HL)
                                SIGNALS[M1][`LD_MAR] = 1;
                                SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                SIGNALS[M2][`LD_MDR] = 1;
                                SIGNALS[M2][`A_MUX] = `A_MUX_MDR;
                                SIGNALS[M2][`ALU_OP] = `ALU_RESET_BASE + y;
                                //MR, MW
                                MSTATES[M2] = `MR;
                                MSTATES[M3] = `MW;
                                MAX_CNT = 2;
                            end
                            default:begin //RES y, r[z]
                                SIGNALS[M1][`A_MUX] = `A_MUX_Z;
                                SIGNALS[M1][`ALU_OP] = `ALU_RESET_BASE + y;
                                SIGNALS[M1][`LD_REG] = 1;
                                SIGNALS[M1][`DR_MUX] = `DR_MUX_Z;
                            end
                        endcase
                    end
                    2'b11:begin
                        case(z)
                            3'b110:begin //SET y, (HL)
                                SIGNALS[M1][`LD_MAR] = 1;
                                SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                SIGNALS[M2][`LD_MDR] = 1;
                                SIGNALS[M2][`A_MUX] = `A_MUX_MDR;
                                SIGNALS[M2][`ALU_OP] = `ALU_SET_BASE + y;
                                //MR, MW
                                MSTATES[M2] = `MR;
                                MSTATES[M3] = `MW;
                                MAX_CNT = 2;
                            end
                            default:begin //SET y, r[z]
                                SIGNALS[M1][`A_MUX] = `A_MUX_Z;
                                SIGNALS[M1][`ALU_OP] = `ALU_SET_BASE + y;
                                SIGNALS[M1][`LD_REG] = 1;
                                SIGNALS[M1][`DR_MUX] = `DR_MUX_Z;
                            end
                        endcase
                    end
                endcase
            end
            2'b10:begin //this is the extra cringe PLA
                case(x)
                    2'b01:begin
                        case(z)
                            3'b000:begin
                                case(y)
                                    3'b110:begin //NOP
                                        //NOP
                                    end
                                    default:begin //IN r[y], (C)
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_BC;
                                        SIGNALS[M2][`LD_REG] = 1;
                                        SIGNALS[M2][`DR_MUX] = `DR_MUX_DR;

                                        //PR
                                        MSTATES[M2] = `PR;
                                        MAX_CNT = 1;
                                    end
                                endcase
                            end
                            3'b001:begin
                                case(y)
                                    3'b110:begin //OUT (C), 0
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_BC;
                                        SIGNALS[M1][`A_MUX] = `A_MUX_ZERO;
                                        SIGNALS[M1][`ALU_OP] = `ALU_PASSA;
                                        SIGNALS[M1][`LD_MDR] = 1;
                                        //PW
                                        MSTATES[M2] = `PW;
                                        MAX_CNT = 1;
                                    end
                                    default:begin //OUT (C), r[y]
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_BC;
                                        SIGNALS[M1][`A_MUX] = `A_MUX_Y;
                                        SIGNALS[M1][`ALU_OP] = `ALU_PASSA;
                                        SIGNALS[M1][`LD_MDR] = 1;
                                        //PW
                                        MSTATES[M2] = `PW;
                                        MAX_CNT = 1;
                                    end
                                endcase
                            end
                            3'b010:begin
                                case(q)
                                    1'b0:begin //SBC HL, rp[p]
                                        SIGNALS[M3][`A_MUX] = `A_MUX_Y;
                                        SIGNALS[M3][`B_MUX] = `B_MUX_HL;
                                        SIGNALS[M3][`RP] = 1;
                                        SIGNALS[M3][`ALU_OP] = `ALU_DEC_16BIT; //is this fine?
                                        SIGNALS[M2][`STALL_1] = 1;
                                        SIGNALS[M3][`LD_REG] = 1;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_HL;
                                        //IO, IO
                                        MSTATES[M2] = `IO;
                                        MSTATES[M3] = `IO;
                                        MAX_CNT = 2;
                                    end
                                    1'b1:begin //ADC HL, rp[p]
                                        SIGNALS[M3][`A_MUX] = `A_MUX_Y;
                                        SIGNALS[M3][`B_MUX] = `B_MUX_HL;
                                        SIGNALS[M3][`RP] = 1;
                                        SIGNALS[M3][`ALU_OP] = `ALU_INC_16BIT; //is this fine?
                                        SIGNALS[M2][`STALL_1] = 1;
                                        SIGNALS[M3][`LD_REG] = 1;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_HL;
                                        //IO, IO
                                        MSTATES[M2] = `IO;
                                        MSTATES[M3] = `IO;
                                        MAX_CNT = 2;
                                    end
                                endcase
                            end
                            3'b011:begin
                                case(q)
                                    1'b0:begin //LD (nn), rp[p]
                                        SIGNALS[M3][`LD_MAR] = 1;
                                        SIGNALS[M3][`MAR_MUX] = `MAR_MUX_MDR;
                                        SIGNALS[M3][`LD_MDR] = 1;
                                        SIGNALS[M3][`MDR_MUX] = 0;
                                        SIGNALS[M3][`A_MUX] = `A_MUX_Y;
                                        SIGNALS[M3][`ALU_OP] = `ALU_PASSA;
                                        SIGNALS[M3][`RP] = 1;
                                        //ODL, ODH, MWL, MWH
                                        MSTATES[M2] = `ODL;
                                        MSTATES[M3] = `ODH;
                                        MSTATES[M4] = `MWL;
                                        MSTATES[M5] = `MWH;
                                        MAX_CNT = 4;
                                    end
                                    1'b1:begin //LD rp[p], (nn)
                                        SIGNALS[M3][`LD_MAR] = 1;
                                        SIGNALS[M3][`MAR_MUX] = `MAR_MUX_MDR;
                                        SIGNALS[M5][`LD_REG] = 1;
                                        SIGNALS[M5][`DR_MUX] = `DR_MUX_DR;
                                        SIGNALS[M5][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M5][`ALU_OP] = `ALU_PASSA;
                                        SIGNALS[M5][`RP] = 1;
                                        //ODL, ODH, MRL, MRH
                                        MSTATES[M2] = `ODL;
                                        MSTATES[M3] = `ODH;
                                        MSTATES[M4] = `MRL;
                                        MSTATES[M5] = `MRH;
                                        MAX_CNT = 4;
                                    end   
                                endcase
                            end
                            3'b100:begin //NEG
                                SIGNALS[M1][`A_MUX] = `A_MUX_A;
                                SIGNALS[M1][`ALU_OP] = `ALU_NEG;
                                SIGNALS[M1][`LD_ACCUM] = 1;
                            end
                            3'b101:begin
                                case(y)
                                    3'b001:begin //RETI
                                        SIGNALS[M3][`LD_PC] = 1;
                                        SIGNALS[M3][`PCMUX] = `PCMUX_MDR;
                                        //SRL, SRH
                                        MSTATES[M2] = `SRL;
                                        MSTATES[M3] = `SRH;
                                        MAX_CNT = 2;
                                    end
                                    default:begin //RETN
                                        SIGNALS[M3][`LD_PC] = 1;
                                        SIGNALS[M3][`PCMUX] = `PCMUX_MDR;
                                        SIGNALS[M3][`IFF2_TO_IFF1] = 1;
                                        //SRL, SRH
                                        MSTATES[M2] = `SRL;
                                        MSTATES[M3] = `SRH;
                                        MAX_CNT = 2;
                                    end
                                endcase
                            end
                            3'b110:begin //IM y
                                SIGNALS[M1][`A_MUX] = `A_MUX_A;
                                SIGNALS[M1][`ALU_OP] = `ALU_PASSA;
                                SIGNALS[M1][`LD_INT_MODE] = 1;
                            end
                            3'b111:begin
                                case(y)
                                    3'b000:begin //LD I, A
                                        SIGNALS[M1][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M1][`ALU_OP] = `ALU_PASSA;
                                        SIGNALS[M1][`LD_I] = 1;
                                        F_stall = 2'd1;
                                    end
                                    3'b001:begin //LD R, A
                                        SIGNALS[M1][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M1][`ALU_OP] = `ALU_PASSA;
                                        SIGNALS[M1][`LD_R] = 1;
                                        F_stall = 2'd1;
                                    end
                                    3'b010:begin //LD A, I
                                        SIGNALS[M1][`A_MUX] = `A_MUX_I;
                                        SIGNALS[M1][`ALU_OP] = `ALU_PASSA;
                                        SIGNALS[M1][`LD_ACCUM] = 1;
                                        F_stall = 2'd1;
                                    end
                                    3'b011:begin //LD A, R
                                        SIGNALS[M1][`A_MUX] = `A_MUX_R;
                                        SIGNALS[M1][`ALU_OP] = `ALU_PASSA;
                                        SIGNALS[M1][`LD_ACCUM] = 1;
                                        F_stall = 2'd1;
                                    end
                                    3'b100:begin //RRD
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M3][`LD_MDR] = 1;
                                        SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M3][`ALU_OP] = `ALU_RRD;
                                        //IO, MW
                                        MSTATES[M2] = `IO;
                                        MSTATES[M3] = `MW;
                                        MAX_CNT = 2;
                                    end
                                    3'b101:begin //RLD
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M3][`LD_MDR] = 1;
                                        SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M3][`ALU_OP] = `ALU_RLD;
                                        //IO, MW
                                        MSTATES[M2] = `IO;
                                        MSTATES[M3] = `MW;
                                        MAX_CNT = 2;
                                    end
                                    3'b110:begin //NOP
                                        //NOP
                                    end
                                    3'b111:begin //NOP
                                        //NOP
                                    end
                                endcase
                            end
                        endcase
                    end
                    2'b10:begin
                        case(z)
                            3'b000:begin
                                case(y)
                                    3'b000:begin //LDI
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M1][`A_MUX] = `A_MUX_BC;
                                        SIGNALS[M1][`ALU_OP] = `ALU_LD_DEC;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_BC;
                                        SIGNALS[M2][`LD_MAR] = 1;
                                        SIGNALS[M2][`MAR_MUX] = `MAR_MUX_DE;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_DE;
                                        SIGNALS[M2][`ALU_OP] = `ALU_LDI_INC;
                                        SIGNALS[M2][`LD_REG] = 1;
                                        SIGNALS[M2][`DR_MUX] = `DR_MUX_DE;
                                        SIGNALS[M3][`A_MUX] = `A_MUX_HL;
                                        SIGNALS[M3][`ALU_OP] = `ALU_INC_16BIT; //is this gonna mess with flags?
                                        SIGNALS[M3][`LD_REG] = 1;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_HL;
                                        SIGNALS[M3][`STALL_2] = 1;

                                        //MR, MW
                                        MSTATES[M2] = `MR;
                                        MSTATES[M3] = `MW;
                                        MAX_CNT = 2;
                                    end
                                    3'b001:begin //LDD
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M1][`A_MUX] = `A_MUX_BC;
                                        SIGNALS[M1][`ALU_OP] = `ALU_LD_DEC;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_BC;
                                        SIGNALS[M2][`LD_MAR] = 1;
                                        SIGNALS[M2][`MAR_MUX] = `MAR_MUX_DE;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_DE;
                                        SIGNALS[M2][`ALU_OP] = `ALU_LDD_DEC;
                                        SIGNALS[M2][`LD_REG] = 1;
                                        SIGNALS[M2][`DR_MUX] = `DR_MUX_DE;
                                        SIGNALS[M3][`A_MUX] = `A_MUX_HL;
                                        SIGNALS[M3][`ALU_OP] = `ALU_DEC_16BIT;
                                        SIGNALS[M3][`LD_REG] = 1;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_HL;
                                        SIGNALS[M3][`STALL_2] = 1;

                                        //MR, MW
                                        MSTATES[M2] = `MR;
                                        MSTATES[M3] = `MW;
                                        MAX_CNT = 2;
                                    end
                                    3'b010:begin //LDIR
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M1][`A_MUX] = `A_MUX_BC;
                                        SIGNALS[M1][`ALU_OP] = `ALU_LD_DEC;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_BC;
                                        SIGNALS[M2][`LD_MAR] = 1;
                                        SIGNALS[M2][`MAR_MUX] = `MAR_MUX_DE;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_DE;
                                        SIGNALS[M2][`ALU_OP] = `ALU_LDI_INC;
                                        SIGNALS[M1][`DEC_MCTR_CC] = 1;
                                        SIGNALS[M1][`MUX_EXEC_COND] = `MUX_EXEC_COND_Z;
                                        SIGNALS[M2][`LD_REG] = 1;
                                        SIGNALS[M2][`DR_MUX] = `DR_MUX_DE;
                                        SIGNALS[M3][`A_MUX] = `A_MUX_HL;
                                        SIGNALS[M3][`ALU_OP] = `ALU_INC_16BIT;
                                        SIGNALS[M3][`LD_REG] = 1;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_HL;
                                        SIGNALS[M4][`A_MUX] = `A_MUX_PC;
                                        SIGNALS[M4][`ALU_OP] = `ALU_ADD_16BIT; //is this what we want?
                                        SIGNALS[M4][`LD_PC] = 1;
                                        SIGNALS[M4][`B_MUX] = `B_MUX_NEGTWO; 
                                        SIGNALS[M4][`STALL_2] = 1;
                                        SIGNALS[M3][`STALL_2] = 1;

                                        //MR, MW, IO
                                        MSTATES[M2] = `MR;
                                        MSTATES[M3] = `MW;
                                        MSTATES[M4] = `IO;
                                        MAX_CNT = 3;
                                    end
                                    3'b011:begin //LDDR
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M1][`A_MUX] = `A_MUX_BC;
                                        SIGNALS[M1][`ALU_OP] = `ALU_LD_DEC;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_BC;
                                        SIGNALS[M2][`LD_MAR] = 1;
                                        SIGNALS[M2][`MAR_MUX] = `MAR_MUX_DE;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_DE;
                                        SIGNALS[M2][`ALU_OP] = `ALU_LDD_DEC;
                                        SIGNALS[M1][`DEC_MCTR_CC] = 1;
                                        SIGNALS[M1][`MUX_EXEC_COND] = `MUX_EXEC_COND_Z;
                                        SIGNALS[M2][`LD_REG] = 1;
                                        SIGNALS[M2][`DR_MUX] = `DR_MUX_DE;
                                        SIGNALS[M3][`A_MUX] = `A_MUX_HL;
                                        SIGNALS[M3][`ALU_OP] = `ALU_DEC_16BIT;
                                        SIGNALS[M3][`LD_REG] = 1;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_HL;
                                        SIGNALS[M4][`A_MUX] = `A_MUX_PC;
                                        SIGNALS[M4][`ALU_OP] = `ALU_ADD_16BIT; 
                                        SIGNALS[M4][`LD_PC] = 1;
                                        SIGNALS[M4][`B_MUX] = `B_MUX_NEGTWO; 
                                        SIGNALS[M4][`STALL_2] = 1;
                                        SIGNALS[M3][`STALL_2] = 1;

                                        //MR, MW, IO
                                        MSTATES[M2] = `MR;
                                        MSTATES[M3] = `MW;
                                        MSTATES[M4] = `IO;
                                        MAX_CNT = 3;
                                    end
                                endcase
                            end
                            3'b001:begin
                                case(y)
                                    3'b100:begin //CPI
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M1][`A_MUX] = `A_MUX_BC;
                                        SIGNALS[M1][`ALU_OP] = `ALU_CP_DEC;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_BC;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M2][`B_MUX] = `B_MUX_MDR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_CPID;
                                        SIGNALS[M3][`A_MUX] = `A_MUX_HL;
                                        SIGNALS[M3][`ALU_OP] = `ALU_INC_16BIT;
                                        SIGNALS[M3][`LD_REG] = 1;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_HL;
                                        SIGNALS[M3][`STALL_2] = 1;

                                        //MR, MW, 
                                        MSTATES[M2] = `MR;
                                        MSTATES[M3] = `MW;
                                        MAX_CNT = 2;
                                    end

                                    3'b001:begin //CPD
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M1][`A_MUX] = `A_MUX_BC;
                                        SIGNALS[M1][`ALU_OP] = `ALU_CP_DEC;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_BC;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M2][`B_MUX] = `B_MUX_MDR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_CPID;
                                        SIGNALS[M3][`A_MUX] = `A_MUX_HL;
                                        SIGNALS[M3][`ALU_OP] = `ALU_DEC_16BIT;
                                        SIGNALS[M3][`LD_REG] = 1;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_HL;
                                        SIGNALS[M3][`STALL_2] = 1;

                                        //MR, MW
                                        MSTATES[M2] = `MR;
                                        MSTATES[M3] = `MW;
                                        MAX_CNT = 2;

                                    end
                                    3'b010:begin //CPIR
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M1][`A_MUX] = `A_MUX_BC;
                                        SIGNALS[M1][`ALU_OP] = `ALU_CP_DEC;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_BC;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M2][`B_MUX] = `B_MUX_MDR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_CPID;
                                        SIGNALS[M1][`MUX_EXEC_COND] = `MUX_EXEC_COND_Z;
                                        SIGNALS[M1][`DEC_MCTR_CC] = 1;
                                        SIGNALS[M3][`A_MUX] = `A_MUX_HL;
                                        SIGNALS[M3][`ALU_OP] = `ALU_INC_16BIT;
                                        SIGNALS[M3][`LD_REG] = 1;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_HL;
                                        SIGNALS[M4][`A_MUX] = `A_MUX_PC;
                                        SIGNALS[M4][`ALU_OP] = `ALU_ADD_16BIT; 
                                        SIGNALS[M4][`LD_PC] = 1;
                                        SIGNALS[M4][`B_MUX] = `B_MUX_NEGTWO; 
                                        SIGNALS[M4][`STALL_2] = 1;
                                        SIGNALS[M3][`STALL_2] = 1;

                                        //MR, MW, IO
                                        MSTATES[M2] = `MR;
                                        MSTATES[M3] = `MW;
                                        MSTATES[M4] = `IO;
                                        MAX_CNT = 3;
                                    end
                                    3'b011:begin //CPDR
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M1][`A_MUX] = `A_MUX_BC;
                                        SIGNALS[M1][`ALU_OP] = `ALU_CP_DEC;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_BC;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_A;
                                        SIGNALS[M2][`B_MUX] = `B_MUX_MDR;
                                        SIGNALS[M2][`ALU_OP] = `ALU_CPID;
                                        SIGNALS[M1][`MUX_EXEC_COND] = `MUX_EXEC_COND_Z;
                                        SIGNALS[M1][`DEC_MCTR_CC] = 1;
                                        SIGNALS[M3][`A_MUX] = `A_MUX_HL;
                                        SIGNALS[M3][`ALU_OP] = `ALU_DEC_16BIT;
                                        SIGNALS[M3][`LD_REG] = 1;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_HL;
                                        SIGNALS[M4][`A_MUX] = `A_MUX_PC;
                                        SIGNALS[M4][`ALU_OP] = `ALU_ADD_16BIT; 
                                        SIGNALS[M4][`LD_PC] = 1;
                                        SIGNALS[M4][`B_MUX] = `B_MUX_NEGTWO; 
                                        SIGNALS[M4][`STALL_2] = 1;
                                        SIGNALS[M3][`STALL_2] = 1;

                                        //MR, MW, IO
                                        MSTATES[M2] = `MR;
                                        MSTATES[M3] = `MW;
                                        MSTATES[M4] = `IO;
                                        MAX_CNT = 3;
                                    end
                                endcase
                            end
                            3'b010:begin
                                case(y)
                                    3'b000:begin //INI
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_BC;
                                        SIGNALS[M1][`A_MUX] = `A_MUX_B;
                                        SIGNALS[M1][`ALU_OP] = `ALU_INI_DEC;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_B;
                                        SIGNALS[M2][`LD_MAR] = 1;
                                        SIGNALS[M2][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_HL;
                                        SIGNALS[M2][`ALU_OP] = `ALU_INC_16BIT;
                                        SIGNALS[M2][`LD_REG] = 1;
                                        SIGNALS[M2][`DR_MUX] = `DR_MUX_HL;

                                        //PR, MW
                                        MSTATES[M2] = `PR;
                                        MSTATES[M3] = `MW;
                                        MAX_CNT = 2;
                                    end
                                    3'b001:begin //IND
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_BC;
                                        SIGNALS[M1][`A_MUX] = `A_MUX_B;
                                        SIGNALS[M1][`ALU_OP] = `ALU_IND_DEC;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_B;
                                        SIGNALS[M2][`LD_MAR] = 1;
                                        SIGNALS[M2][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_HL;
                                        SIGNALS[M2][`ALU_OP] = `ALU_DEC_16BIT;
                                        SIGNALS[M2][`LD_REG] = 1;
                                        SIGNALS[M2][`DR_MUX] = `DR_MUX_HL;
                                        //PR, MW
                                        MSTATES[M2] = `PR;
                                        MSTATES[M3] = `MW;
                                        MAX_CNT = 2;
                                    end
                                    3'b010:begin //INIR
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_BC;
                                        SIGNALS[M1][`A_MUX] = `A_MUX_B;
                                        SIGNALS[M1][`ALU_OP] = `ALU_INI_DEC;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_B;
                                        SIGNALS[M1][`DEC_MCTR_CC] = 1;
                                        SIGNALS[M1][`MUX_EXEC_COND] = `MUX_EXEC_COND_Z;
                                        SIGNALS[M2][`LD_MAR] = 1;
                                        SIGNALS[M2][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_HL;
                                        SIGNALS[M2][`ALU_OP] = `ALU_INC_16BIT;
                                        SIGNALS[M2][`LD_REG] = 1;
                                        SIGNALS[M2][`DR_MUX] = `DR_MUX_HL;
                                        SIGNALS[M4][`A_MUX] = `A_MUX_PC;
                                        SIGNALS[M4][`ALU_OP] = `ALU_ADD_16BIT; 
                                        SIGNALS[M4][`LD_PC] = 1;
                                        SIGNALS[M4][`B_MUX] = `B_MUX_NEGTWO; 
                                        SIGNALS[M4][`STALL_2] = 1;
                                        //PR, MW, IO
                                        MSTATES[M2] = `PR;
                                        MSTATES[M3] = `MW;
                                        MSTATES[M4] = `IO;
                                        MAX_CNT = 3;
                                    end
                                    3'b011:begin //INDR
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_BC;
                                        SIGNALS[M1][`A_MUX] = `A_MUX_B;
                                        SIGNALS[M1][`ALU_OP] = `ALU_IND_DEC;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_B;
                                        SIGNALS[M1][`DEC_MCTR_CC] = 1;
                                        SIGNALS[M1][`MUX_EXEC_COND] = `MUX_EXEC_COND_Z;
                                        SIGNALS[M2][`LD_MAR] = 1;
                                        SIGNALS[M2][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_HL;
                                        SIGNALS[M2][`ALU_OP] = `ALU_DEC_16BIT;
                                        SIGNALS[M2][`LD_REG] = 1;
                                        SIGNALS[M2][`DR_MUX] = `DR_MUX_HL;
                                        SIGNALS[M4][`A_MUX] = `A_MUX_PC;
                                        SIGNALS[M4][`ALU_OP] = `ALU_ADD_16BIT; 
                                        SIGNALS[M4][`LD_PC] = 1;
                                        SIGNALS[M4][`B_MUX] = `B_MUX_NEGTWO; 
                                        SIGNALS[M4][`STALL_2] = 1;
                                        //PR, MW, IO
                                        MSTATES[M2] = `PR;
                                        MSTATES[M3] = `MW;
                                        MSTATES[M4] = `IO;
                                        MAX_CNT = 3;
                                    end
                                endcase
                            end
                            3'b011:begin
                                case(y)
                                    3'b000:begin //OUTI
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M1][`A_MUX] = `A_MUX_B;
                                        SIGNALS[M1][`ALU_OP] = `ALU_OUTI_DEC;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_B;
                                        SIGNALS[M2][`LD_MAR] = 1;
                                        SIGNALS[M2][`MAR_MUX] = `MAR_MUX_BC; //is this ok even though we alr changed b?
                                        SIGNALS[M2][`A_MUX] = `A_MUX_HL;
                                        SIGNALS[M2][`ALU_OP] = `ALU_INC_16BIT;
                                        SIGNALS[M2][`LD_REG] = 1;
                                        SIGNALS[M2][`DR_MUX] = `DR_MUX_HL;
                                        //MR, PW
                                        MSTATES[M2] = `MR;
                                        MSTATES[M3] = `PW;
                                        MAX_CNT = 2;
                                    end
                                    3'b001:begin //OUTD
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M1][`A_MUX] = `A_MUX_B;
                                        SIGNALS[M1][`ALU_OP] = `ALU_OUTD_DEC;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_B;
                                        SIGNALS[M2][`LD_MAR] = 1;
                                        SIGNALS[M2][`MAR_MUX] = `MAR_MUX_BC;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_HL;
                                        SIGNALS[M2][`ALU_OP] = `ALU_DEC_16BIT;
                                        SIGNALS[M2][`LD_REG] = 1;
                                        SIGNALS[M2][`DR_MUX] = `DR_MUX_HL;
                                        //MR, PW
                                        MSTATES[M2] = `MR;
                                        MSTATES[M3] = `PW;
                                        MAX_CNT = 2;
                                    end
                                    3'b010:begin //OTIR
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M1][`A_MUX] = `A_MUX_B;
                                        SIGNALS[M1][`ALU_OP] = `ALU_OUTI_DEC;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_B;
                                        SIGNALS[M2][`LD_MAR] = 1;
                                        SIGNALS[M2][`MAR_MUX] = `MAR_MUX_BC; //is this ok even though we alr changed b?
                                        SIGNALS[M2][`A_MUX] = `A_MUX_HL;
                                        SIGNALS[M2][`ALU_OP] = `ALU_INC_16BIT;
                                        SIGNALS[M1][`DEC_MCTR_CC] = 1;
                                        SIGNALS[M1][`MUX_EXEC_COND] = `MUX_EXEC_COND_Z;
                                        SIGNALS[M4][`A_MUX] = `A_MUX_PC;
                                        SIGNALS[M4][`ALU_OP] = `ALU_ADD_16BIT; 
                                        SIGNALS[M4][`LD_PC] = 1;
                                        SIGNALS[M4][`B_MUX] = `B_MUX_NEGTWO; 
                                        SIGNALS[M4][`STALL_2] = 1;
                                        //MR, PW, IO
                                        MSTATES[M2] = `MR;
                                        MSTATES[M3] = `PW;
                                        MSTATES[M4] = `IO;
                                        MAX_CNT = 3;
                                    end
                                    3'b011:begin //OTDR
                                        SIGNALS[M1][`LD_MAR] = 1;
                                        SIGNALS[M1][`MAR_MUX] = `MAR_MUX_HL;
                                        SIGNALS[M1][`A_MUX] = `A_MUX_B;
                                        SIGNALS[M1][`ALU_OP] = `ALU_OUTD_DEC;
                                        SIGNALS[M1][`LD_REG] = 1;
                                        SIGNALS[M1][`DR_MUX] = `DR_MUX_B;
                                        SIGNALS[M2][`LD_MAR] = 1;
                                        SIGNALS[M2][`MAR_MUX] = `MAR_MUX_BC;
                                        SIGNALS[M2][`A_MUX] = `A_MUX_HL;
                                        SIGNALS[M2][`ALU_OP] = `ALU_DEC_16BIT;
                                        SIGNALS[M1][`DEC_MCTR_CC] = 1;
                                        SIGNALS[M1][`MUX_EXEC_COND] = `MUX_EXEC_COND_Z;
                                        SIGNALS[M4][`A_MUX] = `A_MUX_PC;
                                        SIGNALS[M4][`ALU_OP] = `ALU_ADD_16BIT; 
                                        SIGNALS[M4][`LD_PC] = 1;
                                        SIGNALS[M4][`B_MUX] = `B_MUX_NEGTWO; 
                                        SIGNALS[M4][`STALL_2] = 1;
                                        //MR, PW, IO
                                        MSTATES[M2] = `MR;
                                        MSTATES[M3] = `PW;
                                        MSTATES[M4] = `IO;
                                        MAX_CNT = 3;
                                    end
                                endcase
                            end
                        endcase
                    end
                endcase
            end
            2'b11:begin //this is the cringe with IX or IY PLA
                case(x)
                    2'b00:begin
                        case(z)
                            3'b110:begin 
                                case(y)
                                    3'b000:begin //RLC (IX + D)
                                        SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M3][`ALU_OP] = `ALU_RLC;
                                        SIGNALS[M3][`LD_MDR] = 1;
                                        //MW
                                        MSTATES[M4] = `MW;
                                        MAX_CNT = 3;
                                    end
                                    3'b001:begin //RRC (IX + D)
                                        SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M3][`ALU_OP] = `ALU_RRC;
                                        SIGNALS[M3][`LD_MDR] = 1;
                                        //MW
                                        MSTATES[M4] = `MW;
                                        MAX_CNT = 3;
                                    end
                                    3'b010:begin //RL (IX + D)
                                        SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M3][`ALU_OP] = `ALU_RL;
                                        SIGNALS[M3][`LD_MDR] = 1;
                                        //MW
                                        MSTATES[M4] = `MW;
                                        MAX_CNT = 3;
                                    end
                                    3'b011:begin //RR (IX + D)
                                        SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M3][`ALU_OP] = `ALU_RR;
                                        SIGNALS[M3][`LD_MDR] = 1;
                                        //MW
                                        MSTATES[M4] = `MW;
                                        MAX_CNT = 3;
                                    end
                                    3'b100:begin //SLA (IX + D)
                                        SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M3][`ALU_OP] = `ALU_SLA;
                                        SIGNALS[M3][`LD_MDR] = 1;
                                        //MW
                                        MSTATES[M4] = `MW;
                                        MAX_CNT = 3;
                                    end
                                    3'b101:begin //SRA (IX + D)
                                        SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M3][`ALU_OP] = `ALU_SRA;
                                        SIGNALS[M3][`LD_MDR] = 1;
                                        //MW
                                        MSTATES[M4] = `MW;
                                        MAX_CNT = 3;
                                    end
                                    3'b110:begin //SLL (IX + D)
                                        SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M3][`ALU_OP] = `ALU_SLL;
                                        SIGNALS[M3][`LD_MDR] = 1;
                                        //MW
                                        MSTATES[M4] = `MW;
                                        MAX_CNT = 3;
                                    end
                                    3'b111:begin //SRL (IX + D)
                                        SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M3][`ALU_OP] = `ALU_SRL;
                                        SIGNALS[M3][`LD_MDR] = 1;
                                        //MW
                                        MSTATES[M4] = `MW;
                                        MAX_CNT = 3;
                                    end
                                endcase
                            end
                            default:begin
                                case(y)
                                    3'b000:begin //RLC r, (IX + D)
                                        SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M3][`ALU_OP] = `ALU_RLC;
                                        SIGNALS[M3][`LD_MDR] = 1;
                                        SIGNALS[M3][`LD_REG] = 1;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_Z;
                                        //MW
                                        MSTATES[M4] = `MW;
                                        MAX_CNT = 3;
                                    end
                                    3'b001:begin //RRC r, (IX + D)
                                        SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M3][`ALU_OP] = `ALU_RRC;
                                        SIGNALS[M3][`LD_MDR] = 1;
                                        SIGNALS[M3][`LD_REG] = 1;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_Z;
                                        //MW
                                        MSTATES[M4] = `MW;
                                        MAX_CNT = 3;
                                    end
                                    3'b010:begin //RL r, (IX + D)
                                        SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M3][`ALU_OP] = `ALU_RL;
                                        SIGNALS[M3][`LD_MDR] = 1;
                                        SIGNALS[M3][`LD_REG] = 1;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_Z;
                                        //MW
                                        MSTATES[M4] = `MW;
                                        MAX_CNT = 3;
                                    end
                                    3'b011:begin //RR r, (IX + D)
                                        SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M3][`ALU_OP] = `ALU_RR;
                                        SIGNALS[M3][`LD_MDR] = 1;
                                        SIGNALS[M3][`LD_REG] = 1;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_Z;
                                        //MW
                                        MSTATES[M4] = `MW;
                                        MAX_CNT = 3;
                                    end
                                    3'b100:begin //SLA r, (IX + D)
                                        SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M3][`ALU_OP] = `ALU_SLA;
                                        SIGNALS[M3][`LD_MDR] = 1;
                                        SIGNALS[M3][`LD_REG] = 1;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_Z;
                                        //MW
                                        MSTATES[M4] = `MW;
                                        MAX_CNT = 3;
                                    end
                                    3'b101:begin //SRA r, (IX + D)
                                        SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M3][`ALU_OP] = `ALU_SRA;
                                        SIGNALS[M3][`LD_MDR] = 1;
                                        SIGNALS[M3][`LD_REG] = 1;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_Z;
                                        //MW
                                        MSTATES[M4] = `MW;
                                        MAX_CNT = 3;
                                    end
                                    3'b110:begin //SLL r, (IX + D)
                                        SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M3][`ALU_OP] = `ALU_SLL;
                                        SIGNALS[M3][`LD_MDR] = 1;
                                        SIGNALS[M3][`LD_REG] = 1;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_Z;
                                        //MW
                                        MSTATES[M4] = `MW;
                                        MAX_CNT = 3;
                                    end
                                    3'b111:begin //SRL r, (IX + D)
                                        SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                        SIGNALS[M3][`ALU_OP] = `ALU_SRL;
                                        SIGNALS[M3][`LD_MDR] = 1;
                                        SIGNALS[M3][`LD_REG] = 1;
                                        SIGNALS[M3][`DR_MUX] = `DR_MUX_Z;
                                        //MW
                                        MSTATES[M4] = `MW;
                                        MAX_CNT = 3;
                                    end
                                endcase
                            end
                        endcase
                    end
                    2'b01:begin //BIT y, (IX + D)
                        SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                        SIGNALS[M4][`ALU_OP] = `ALU_TEST_BASE + y; //is it ok to just add y here? synth will save us I hope
                    end
                    2'b10:begin
                        case(z)
                            3'b110:begin //RES y, (IX + D)
                                SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                SIGNALS[M3][`ALU_OP] = `ALU_RESET_BASE + y;
                                SIGNALS[M3][`LD_MDR] = 1;
                                //MW
                                MSTATES[M4] = `MW;
                                MAX_CNT = 3;
                            end
                            default:begin //RES y, r[z], (IX + D)
                                SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                SIGNALS[M3][`ALU_OP] = `ALU_RESET_BASE + y;
                                SIGNALS[M3][`LD_MDR] = 1;
                                SIGNALS[M3][`LD_REG] = 1;
                                SIGNALS[M3][`DR_MUX] = `DR_MUX_Z;
                                
                                //MW
                                MSTATES[M4] = `MW;
                                MAX_CNT = 3;
                            end
                        endcase
                    end
                    2'b11:begin
                        case(z)
                            3'b110:begin //SET y, (IX + D)
                                SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                SIGNALS[M3][`ALU_OP] = `ALU_SET_BASE + y;
                                SIGNALS[M3][`LD_MDR] = 1;
                                //MW
                                MSTATES[M4] = `MW;
                                MAX_CNT = 3;
                            end
                            default:begin //SET y, r[z], (IX + D)
                                SIGNALS[M3][`A_MUX] = `A_MUX_MDR;
                                SIGNALS[M3][`ALU_OP] = `ALU_SET_BASE + y;
                                SIGNALS[M3][`LD_MDR] = 1;
                                SIGNALS[M3][`LD_REG] = 1;
                                SIGNALS[M3][`DR_MUX] = `DR_MUX_Z;
                                //MW
                                MSTATES[M4] = `MW;
                                MAX_CNT = 3;
                            end
                        endcase
                    end
                endcase
            end           
        endcase
        SIGNALS_PORT = {SIGNALS[4], SIGNALS[3], SIGNALS[2], SIGNALS[1], SIGNALS[0]};
        MSTATES_PORT = {MSTATES[4], MSTATES[3], MSTATES[2], MSTATES[1], MSTATES[0]};
    end 
endmodule
