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

//A_MUX chooses between 5:3 of opcode, 2:0 of opcode, HL, BC, DE, A, I, R, IX, IY, PC, MDR as SR1
`define A_MUX_SR1 4'd0 //uses P if RP is set
`define A_MUX_Z 4'd1
`define A_MUX_HL 4'd2
`define A_MUX_BC 4'd3
`define A_MUX_DE 4'd4
`define A_MUX_A 4'd5
`define A_MUX_I 4'd6
`define A_MUX_R 4'd7
`define A_MUX_IX 4'd8
`define A_MUX_IY 4'd9
`define A_MUX_PC 4'd10
`define A_MUX_MDR 4'd11 //new from nadia's original drawing

//MARMUX chooses between SR1, MDR, MDR[7:0]`A
`define MAR_MUX_SR1 0
`define MAR_MUX_MDR 1
`define MAR_MUX_MDR_A 2

//DR_MUX chooses between 5:3 of opcode, 2:0 of opcode, HL, BC, DE as DR
`define DR_MUX_DR 3'd0 //uses P if RP is set
`define DR_MUX_Z 3'd1
`define DR_MUX_HL 3'd2
`define DR_MUX_BC 3'd3
`define DR_MUX_DE 3'd4
`define DR_MUX_SP 3'd5

//MUX_EXEC_COND chooses between condition y, y-4, 0 (NZ), and 1 (Z)
`define MUX_EXEC_COND_Y 2'd0
`define MUX_EXEC_COND_Y_SUB_4 2'd1
`define MUX_EXEC_COND_NZ 2'd2
`define MUX_EXEC_COND_Z 2'd3

//PCMUX chooses between ALU (BUSC), IR (Absolute), PC + 1, y << 3
`define PCMUX_ALU 2'd0
`define PCMUX_IR 2'd1
`define PCMUX_INC_PC 2'd2
`define PCMUX_Y_SHIFT 2'd3

//muxes
`define MUX_EXEC_COND_0 0//chooses between condition y, y-4, 0 (NZ), and 1 (Z)
`define MUX_EXEC_COND_1 1
`define MUX_EXEC_COND `MUX_EXEC_COND_1:`MUX_EXEC_COND_0

`define PCMUX_0 2 //chooses between ALU (BUSC), IR (Absolute), PC + 1, y << 3
`define PCMUX_1 3
`define PCMUX `PCMUX_1:`PCMUX_0
`define PC_CONDLD 4 //if 1, only loads pc if condition met
`define CONDSTALL 5 //if 1, useq only uses stal1 if condition met

`define A_MUX_0 6 //chooses between 5:3 of opcode, 2:0 of opcode, HL, BC, DE, A, I, R, IX, IY, PC as SR1
`define A_MUX_1 7
`define A_MUX_2 8
`define A_MUX_3 9
`define A_MUX `A_MUX_3:`A_MUX_0
`define B_MUX 10  //chooses between MDR and SR2 (which is r[z] I think)

`define B_MUX_MDR 0
`define B_MUX_SR2 1 //SR2 is RP if SR_RP set, R otherwise


`define DR_MUX_0 11  //chooses between 5:3 of opcode, 2:0 of opcode, HL, BC, DE as DR
`define DR_MUX_1 12
`define DR_MUX_2 13
`define DR_MUX `DR_MUX_2:`DR_MUX_0
`define MAR_MUX_0 14
`define MAR_MUX_1 15
`define MAR_MUX `MAR_MUX_0:`MAR_MUX_1 //chooses between OP1, MDR, and MDR[7:0]`A


//register file signals
`define RP_TABLE 16// chooses which register pair to load from
`define ld_IX 17
`define ld_IY 18
`define EXX 19
//bits 4-5 of opcode along with RP_TABLE select register pairs, but this doesn't get handled in RF if ALU has AF still
//sr1 will be R or RP uness overriden by specific register signals.
//sr2 output based on bits 5:3 of the opcode always
//Needs to be a separate port for HL

//ld signals other than reg file
`define LD_PC 20
`define LD_I 21
`define LD_R 22
`define LD_REG 23
`define LD_MDR 24 //loads MDR with data from MDR_MUX
`define LD_MAR 25
`define LD_CMET 26 //loads false if condition not met (set true by default in usequencer)

//usequencer signals
`define DEC_MCTR_CC 27
`define FETCH_AGAIN 28
`define NEXT_PLA 29//latched if there is a prefix, reset on last m cycle
`define STALL_1 30//we can stall either 1 or 2 cycles in certain places 
`define STALL_2 31

//system signals
`define HALT 32   //does something in datapath somewhere
`define INT_FF_RESET 33//sets 
`define INT_FF_SET 34
`define IFF2_to_IFF1 35//IFF2 --> IFF1

//alu signals
`define ZEXT6(VALUE) ({6{1'b0}} | (VALUE))
`define ALU_OP_0 36
`define ALU_OP_1 37
`define ALU_OP_2 38
`define ALU_OP_3 39
`define ALU_OP_4 40
`define ALU_OP_5 41
`define ALU_OP_6 42
`define ALU_OP `ALU_OP_6:`ALU_OP_0
`define LD_ACCUM 43 //Loads A to be equal to result of ALU (hopefully)
`define LD_FLAG 44 //loads flags based on result data, depending on ALUOP - April needs to add the non aluop instructions as aluops too

`define SEXT_MDR 45 //reorganize later
`define SR_RP 46 //output RP insted of R
`define EXEC_COND_MUX 47//chooses which condition to use if ld_CMET
`define MDR_MUX 48 //chooses between ALU result and HL
`define EX 49 //ex instruction for reg file

`define CS_BITS 50


module decode(
    input [7:0] IR,
    input wire [1:0] PLA_idx,
    input IX_pref, IY_pref, //need to add this to microsequencer later
    output reg [4:0] MSTATES [6:0], //what are the next M-states? Could be up to 7
    output reg [1:0] next_PLA, //CB --> 01, ED --> 10, DDCB/FDCB opcode --> 11
    output reg ld_PLA,
    output reg [5:0] INST_SIGNALS [6:0], // exec signals for M-states
    output reg [2:0] MAX_CNT, //Num M-States to follow this fetch/decode
    output reg [1:0] F_stall, //anded into the stall signals in usequencer probably
    output reg next_IX_pref, next_IY_pref
    );
    

    
    wire[1:0] x, p;
    wire[2:0] y, z;
    wire q;
    integer M_OFFSET;
    assign x = IR[7:6];
    assign y = IR[5:3];
    assign p = IR[5:4];
    assign q = IR[3];
    assign z = IR[2:0];
    integer i, M_OFFSET, M1, M2, , M4, M5;
    
    always @(*) begin
        for(i = 0; i < 7; i = i+1) begin
            INST_SIGNALS[i] = 53'b0;
            MSTATES[i] = 7'b0;
        end
        MAX_CNT = 3'b0;
        ld_PLA = 0;
        next_PLA = 0;
        F_stall = 0;
        next_IX_pref = 0;
        next_IY_pref = 0;
        
        M_OFFSET = 0;
        M1 = 0 + M_OFFSET;
        M2 = 1 + M_OFFSET;
        M3 = 2 + M_OFFSET;
        M4 = 3 + M_OFFSET;
        M5 = 4 + M_OFFSET;
        
        
        case (PLA_idx)
            2'b00:begin //this is the default PLA
                case (x)
                    2'b00:begin //x = 0
                        case(z)
                            3'b000:begin//z = 0
                                case(y)
                                    3'b001:begin
                                        MSTATES[M1][`ALU_OP] = `ALU_SWAP_REGS;
                                    end
                                    3'b010:begin
                                        MSTATES[M1][`ALU_DEC_8BIT] = 1;
                                        MSTATES[M1][`A_MUX] = `A_MUX_A;
                                        MSTATES[M1][`ALU_OP] = `ALU_DEC_8BIT;
                                        MSTATES[M1][`LD_ACCUM] = 1;
                                        MSTATES[M1][`MUX_EXEC_COND] = `MUX_EXEC_COND_NZ;
                                        MSTATES[M1][`LD_CMET] = 1;
                                        MSTATES[M1][`DEC_MCTR_CC] = 1;

                                        MSTATES[M3][`SEXT_MDR] = 1;
                                        MSTATES[M3][`ALU_OP] = `ALU_ADD_16BIT;
                                        MSTATES[M3][`A_MUX] = `A_MUX_PC;
                                        MSTATES[M3][`B_MUX] = `B_MUX_MDR;
                                        MSTATES[M3][`LD_PC] = 1;
                                        MSTATES[M3][`PCMUX] = `PCMUX_ALU;
                                    end
                                    3'b011:begin
                                        MSTATES[M3][`SEXT_MDR] = 1;
                                        MSTATES[M3][`ALU_OP] = `ALU_ADD_16BIT;
                                        MSTATES[M3][`A_MUX] = `A_MUX_PC;
                                        MSTATES[M3][`B_MUX] = `B_MUX_MDR;
                                        MSTATES[M3][`LD_PC] = 1;
                                        MSTATES[M3][`PCMUX] = `PCMUX_ALU;
                                    end
                                    3'b100, 3'b101, 3'b110, 3'b111:begin
                                        MSTATES[M1][`MUX_EXEC_COND] = `MUX_EXEC_COND_Y_SUB_4;
                                        MSTATES[M1][`LD_CMET] = 1;
                                        MSTATES[M1][`DEC_MCTR_CC] = 1;

                                        MSTATES[M3][`SEXT_MDR] = 1;
                                        MSTATES[M3][`ALU_OP] = `ALU_ADD_16BIT;
                                        MSTATES[M3][`A_MUX] = `A_MUX_PC;
                                        MSTATES[M3][`B_MUX] = `B_MUX_MDR;
                                        MSTATES[M3][`LD_PC] = 1;
                                        MSTATES[M3][`PCMUX] = `PCMUX_ALU;
                                    end
                                endcase
                            end
                            3'b001:begin//z = 1
                                case(q)
                                    1'b0: begin
                                        MSTATES[M3][`RP_TABLE] = 0; //default is 0
                                        MSTATES[M3][`B_MUX] = `B_MUX_MDR;
                                        MSTATES[M3][`ALU_OP] = `ALU_PASSB;
                                        MSTATES[M3][`SR_RP] = 1;
                                        MSTATES[M3][`DR_MUX] = `DR_MUX_DR; //it's actually P, not Y, if RP is set
                                        MSTATES[M3][`LD_REG] = 1;
                                    end
                                    1'b1: begin //add HL, rp[p]
                                        MSTATES[M3][`A_MUX] = `A_MUX_HL;
                                        MSTATES[M3][`B_MUX] = `B_MUX_SR2;
                                        MSTATES[M3][`ALU_OP] = `ALU_ADD_16BIT;
                                        MSTATES[M3][`SR_RP] = 1;
                                        MSTATES[M3][`DR_MUX] = `DR_MUX_HL;
                                        MSTATES[M3][`LD_REG] = 1;
                                    end
                                endcase
                            end
                            3'b010:begin //z = 2
                                case(q)
                                    1'b0: begin
                                        case(p)
                                            2'b0, 2'b1: begin
                                                MSTATES[M1][`ALU_OP] = `ALU_PASSA;
                                                MSTATES[M1][`A_MUX] = `A_MUX_A;
                                                MSTATES[M1][`LD_MDR] = 1;
                                                MSTATES[M1][`SR_RP] = 1;
                                                MSTATES[M1][`LD_MAR] = 1;
                                                MSTATES[M3][`MAR_MUX] = 0;
                                            end
                                            2'b10: begin
                                                MSTATES[M3][`ALU_OP] = `ALU_PASSA;
                                                MSTATES[M3][`A_MUX] = `A_MUX_HL;
                                                MSTATES[M3][`LD_MDR] = 1;
                                                MSTATES[M3][`LD_MAR] = 1;
                                                MSTATES[M3][`MAR_MUX] = 1;
                                            end
                                            2'b11: begin
                                                MSTATES[M3][`ALU_OP] = `ALU_PASSA;
                                                MSTATES[M3][`A_MUX] = `A_MUX_A;
                                                MSTATES[M3][`LD_MDR] = 1;
                                                MSTATES[M3][`LD_MAR] = 1;
                                                MSTATES[M3][`MAR_MUX] = 1;
                                            end
                                        endcase
                                    end
                                    1'b1: begin //adc HL, rp[p]
                                        case(p)
                                            2'b0, 2'b1: begin //load MAR with RP in M1, MRD to A in M2
                                                MSTATES[M1][`SR_RP] = 1;
                                                MSTATES[M1][`LD_MAR] = 1;
                                                MSTATES[M2][`B_MUX] = `B_MUX_MDR;
                                                MSTATES[M2][`ALU_OP] = `ALU_PASSB;
                                                MSTATES[M2][`LD_ACCUM] = 1;
                                            end
                                            2'b10: begin //MDR to MAR in M3, MDR to HL in M4
                                                MSTATES[M3][`MAR_MUX] = 1;
                                                MSTATES[M3][`LD_MAR] = 1;
                                                MSTATES[M4][`B_MUX] = `B_MUX_MDR;
                                                MSTATES[M4][`ALU_OP] = `ALU_PASSB;
                                                MSTATES[M4][`DR_MUX] = `DR_MUX_HL;
                                            end
                                            2'b11: begin //MDR to MAR in M3, MDR to A in M4
                                                MSTATES[M3][`MAR_MUX] = 1;
                                                MSTATES[M3][`LD_MAR] = 1;
                                                MSTATES[M4][`B_MUX] = `B_MUX_MDR;
                                                MSTATES[M4][`ALU_OP] = `ALU_PASSB;
                                                MSTATES[M4][`LD_ACCUM] = 1;
                                            end
                                        endcase
                                    end
                                endcase
                            end
                            //z = 3
                            3'b011:begin
                                case(q)
                                    1'b0: begin //increment rp[p]
                                        MSTATES[M1][`RP_TABLE] = 1;
                                        MSTATES[M1][`A_MUX] = `A_MUX_SR1;
                                        MSTATES[M1][`ALU_OP] = `ALU_INC_16BIT;
                                        MSTATES[M1][`DR_MUX] = `DR_MUX_DR;
                                        MSTATES[M1][`LD_REG] = 1;
                                        F_stall = 2'd2;
                                    end
                                    1'b1: begin //decrement rp[p]
                                        MSTATES[M1][`RP_TABLE] = 1;
                                        MSTATES[M1][`A_MUX] = `A_MUX_SR1;
                                        MSTATES[M1][`ALU_OP] = `ALU_DEC_16BIT;
                                        MSTATES[M1][`DR_MUX] = `DR_MUX_DR;
                                        MSTATES[M1][`LD_REG] = 1;
                                        F_stall = 2'd2;
                                    end
                                endcase
                            end
                            3'b100:begin
                                case(y)
                                    3'b110:begin //Increment r[y] (8 bit)
                                        MSTATES[M1][`A_MUX] = `A_MUX_SR1;
                                        MSTATES[M1][`ALU_OP] = `ALU_INC_8BIT;
                                        MSTATES[M1][`DR_MUX] = `DR_MUX_DR;
                                        MSTATES[M1][`LD_REG] = 1;
                                    end
                                    default:begin //Increment memory at HL (16 bit)
                                        MSTATES[M1][`LD_MAR] = 1;
                                        MSTATES[M2][`A_MUX] = `A_MUX_MDR;
                                        MSTATES[M2][`ALU_OP] = `ALU_INC_16BIT;
                                        MSTATES[M2][`LD_MDR] = 1;
                                    end
                                endcase
                            end
                            3'b101:begin
                                case(y)
                                    3'b110:begin //Decrement r[y] (8 bit)
                                        MSTATES[M1][`A_MUX] = `A_MUX_SR1;
                                        MSTATES[M1][`ALU_OP] = `ALU_DEC_8BIT;
                                        MSTATES[M1][`DR_MUX] = `DR_MUX_DR;
                                        MSTATES[M1][`LD_REG] = 1;
                                    end
                                    default:begin //Decrement memory at HL (16 bit)
                                        MSTATES[M1][`LD_MAR] = 1;
                                        MSTATES[M2][`A_MUX] = `A_MUX_MDR;
                                        MSTATES[M2][`ALU_OP] = `ALU_DEC_16BIT;
                                        MSTATES[M2][`LD_MDR] = 1;
                                    end
                                endcase
                            end
                            3'b110:begin
                                case(y)
                                    3'b110:begin //in M2, mdr to r[y]
                                        MSTATES[M2][`A_MUX] = `A_MUX_MDR;
                                        MSTATES[M2][`DR_MUX] = `DR_MUX_DR;
                                        MSTATES[M2][`ALU_OP] = `ALU_PASSA;
                                        MSTATES[M2][`LD_REG] = 1;
                                    end
                                    default:begin //in M2, mdr to memory at HL
                                        MSTATES[M2][`LD_MAR] = 1;
                                    end
                                endcase
                            end
                            3'b111:begin
                                case(y)
                                    3'b0:begin //in M1, ALU RLCA
                                        MSTATES[M1][`A_MUX] = `A_MUX_A;
                                        MSTATES[M1][`ALU_OP] = `ALU_RLCA;
                                        MSTATES[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b1:begin //in M1, ALU RRCA
                                        MSTATES[M1][`A_MUX] = `A_MUX_A;
                                        MSTATES[M1][`ALU_OP] = `ALU_RRCA;
                                        MSTATES[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b10:begin //in M1, ALU RLA
                                        MSTATES[M1][`A_MUX] = `A_MUX_A;
                                        MSTATES[M1][`ALU_OP] = `ALU_RLA;
                                        MSTATES[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b11:begin //in M1, ALU RRA
                                        MSTATES[M1][`A_MUX] = `A_MUX_A;
                                        MSTATES[M1][`ALU_OP] = `ALU_RRA;
                                        MSTATES[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b100:begin //in M1, ALU DAA
                                        MSTATES[M1][`A_MUX] = `A_MUX_A;
                                        MSTATES[M1][`ALU_OP] = `ALU_DAA;
                                        MSTATES[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b101:begin //in M1, ALU CPL
                                        MSTATES[M1][`A_MUX] = `A_MUX_A;
                                        MSTATES[M1][`ALU_OP] = `ALU_CPL;
                                        MSTATES[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b110:begin //in M1, ALU SCF
                                        MSTATES[M1][`A_MUX] = `A_MUX_A;
                                        MSTATES[M1][`ALU_OP] = `ALU_SCF;
                                        MSTATES[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b111:begin //in M1, ALU CCF
                                        MSTATES[M1][`A_MUX] = `A_MUX_A;
                                        MSTATES[M1][`ALU_OP] = `ALU_CCF;
                                        MSTATES[M1][`LD_ACCUM] = 1;
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
                                        MSTATES[M1][`HALT] = 1;
                                    end
                                    default:begin //LD r[y], (HL)
                                        MSTATES[M1][`LD_MAR] = 1;
                                        MSTATES[M1][`MAR_MUX] = 0  
                                        MSTATES[M2][`A_MUX] = `A_MUX_MDR;
                                        MSTATES[M2][`DR_MUX] = `DR_MUX_DR;
                                        MSTATES[M2][`ALU_OP] = `ALU_PASSA;
                                        MSTATES[M2][`LD_REG] = 1;                                
                                    end
                                endcase
                            end
                            default:begin
                                case(y)
                                    3'b110:begin //LD (HL), r[z]
                                        MSTATES[M1][`MAR_MUX] = 0;
                                        MSTATES[M1][`LD_MAR] = 1;
                                        MSTATES[M1][`ALU_OP] = `ALU_PASSA;
                                        MSTATES[M1][`A_MUX] = `A_MUX_Z;
                                        MSTATES[M1][`LD_MDR] = 1;
                                    end
                                    default:begin //LD r[y], r[z]
                                        MSTATES[M1][`A_MUX] = `A_MUX_Z;
                                        MSTATES[M1][`DR_MUX] = `DR_MUX_DR;
                                        MSTATES[M1][`ALU_OP] = `ALU_PASSA;
                                        MSTATES[M1][`LD_REG] = 1;
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
                                        MSTATES[M1][`LD_MAR] = 1;
                                        MSTATES[M1][`MAR_MUX] = 0;
                                        MSTATES[M2][`A_MUX] = `A_MUX_A;
                                        MSTATES[M2][`B_MUX] = `B_MUX_SR2;
                                        MSTATES[M2][`ALU_OP] = `ALU_ADD_8BIT;
                                        MSTATES[M2][`LD_ACCUM] = 1;
                                    end
                                    3'b001:begin //SUB A, (HL)
                                        MSTATES[M1][`LD_MAR] = 1;
                                        MSTATES[M1][`MAR_MUX] = 0;
                                        MSTATES[M2][`A_MUX] = `A_MUX_A;
                                        MSTATES[M2][`B_MUX] = `B_MUX_SR2;
                                        MSTATES[M2][`ALU_OP] = `ALU_SUB_8BIT;
                                        MSTATES[M2][`LD_ACCUM] = 1;
                                    end
                                    3'b010:begin //AND A, (HL)
                                        MSTATES[M1][`LD_MAR] = 1;
                                        MSTATES[M1][`MAR_MUX] = 0;
                                        MSTATES[M2][`A_MUX] = `A_MUX_A;
                                        MSTATES[M2][`B_MUX] = `B_MUX_SR2;
                                        MSTATES[M2][`ALU_OP] = `ALU_AND;
                                        MSTATES[M2][`LD_ACCUM] = 1;
                                    end
                                    3'b011:begin //OR A, (HL)
                                        MSTATES[M1][`LD_MAR] = 1;
                                        MSTATES[M1][`MAR_MUX] = 0;
                                        MSTATES[M2][`A_MUX] = `A_MUX_A;
                                        MSTATES[M2][`B_MUX] = `B_MUX_SR2;
                                        MSTATES[M2][`ALU_OP] = `ALU_OR;
                                        MSTATES[M2][`LD_ACCUM] = 1;
                                    end
                                    3'b100:begin //ADC A, (HL)
                                        MSTATES[M1][`LD_MAR] = 1;
                                        MSTATES[M1][`MAR_MUX] = 0;
                                        MSTATES[M2][`A_MUX] = `A_MUX_A;
                                        MSTATES[M2][`B_MUX] = `B_MUX_SR2;
                                        MSTATES[M2][`ALU_OP] = `ALU_ADC;
                                        MSTATES[M2][`LD_ACCUM] = 1;
                                    end
                                    3'b101:begin //SBC A, (HL)
                                        MSTATES[M1][`LD_MAR] = 1;
                                        MSTATES[M1][`MAR_MUX] = 0;
                                        MSTATES[M2][`A_MUX] = `A_MUX_A;
                                        MSTATES[M2][`B_MUX] = `B_MUX_SR2;
                                        MSTATES[M2][`ALU_OP] = `ALU_SBC;
                                        MSTATES[M2][`LD_ACCUM] = 1;
                                    end
                                    3'b110:begin //XOR A, (HL)
                                        MSTATES[M1][`LD_MAR] = 1;
                                        MSTATES[M1][`MAR_MUX] = 0;
                                        MSTATES[M2][`A_MUX] = `A_MUX_A;
                                        MSTATES[M2][`B_MUX] = `B_MUX_SR2;
                                        MSTATES[M2][`ALU_OP] = `ALU_XOR;
                                        MSTATES[M2][`LD_ACCUM] = 1;
                                    end
                                    3'b111:begin //CP A, (HL)
                                        MSTATES[M1][`LD_MAR] = 1;
                                        MSTATES[M1][`MAR_MUX] = 0;
                                        MSTATES[M2][`A_MUX] = `A_MUX_A;
                                        MSTATES[M2][`B_MUX] = `B_MUX_SR2;
                                        MSTATES[M2][`ALU_OP] = `ALU_CP;
                                        MSTATES[M2][`LD_ACCUM] = 1;
                                    end
                                endcase                                
                            end
                            default:begin
                                case(y)
                                    3'b000:begin //ADD A, r[z]
                                        MSTATES[M1][`A_MUX] = `A_MUX_A;
                                        MSTATES[M1][`B_MUX] = `B_MUX_SR2;
                                        MSTATES[M1][`ALU_OP] = `ALU_ADD_8BIT;
                                        MSTATES[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b001:begin //SUB A, r[z]
                                        MSTATES[M1][`A_MUX] = `A_MUX_A;
                                        MSTATES[M1][`B_MUX] = `B_MUX_SR2;
                                        MSTATES[M1][`ALU_OP] = `ALU_SUB_8BIT;
                                        MSTATES[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b010:begin //AND A, r[z]
                                        MSTATES[M1][`A_MUX] = `A_MUX_A;
                                        MSTATES[M1][`B_MUX] = `B_MUX_SR2;
                                        MSTATES[M1][`ALU_OP] = `ALU_AND;
                                        MSTATES[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b011:begin //OR A, r[z]
                                        MSTATES[M1][`A_MUX] = `A_MUX_A;
                                        MSTATES[M1][`B_MUX] = `B_MUX_SR2;
                                        MSTATES[M1][`ALU_OP] = `ALU_OR;
                                        MSTATES[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b100:begin //ADC A, r[z]
                                        MSTATES[M1][`A_MUX] = `A_MUX_A;
                                        MSTATES[M1][`B_MUX] = `B_MUX_SR2;
                                        MSTATES[M1][`ALU_OP] = `ALU_ADC;
                                        MSTATES[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b101:begin //SBC A, r[z]
                                        MSTATES[M1][`A_MUX] = `A_MUX_A;
                                        MSTATES[M1][`B_MUX] = `B_MUX_SR2;
                                        MSTATES[M1][`ALU_OP] = `ALU_SBC;
                                        MSTATES[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b110:begin //XOR A, r[z]
                                        MSTATES[M1][`A_MUX] = `A_MUX_A;
                                        MSTATES[M1][`B_MUX] = `B_MUX_SR2;
                                        MSTATES[M1][`ALU_OP] = `ALU_XOR;
                                        MSTATES[M1][`LD_ACCUM] = 1;
                                    end
                                    3'b111:begin //CP A, r[z]
                                        MSTATES[M1][`A_MUX] = `A_MUX_A;
                                        MSTATES[M1][`B_MUX] = `B_MUX_SR2;
                                        MSTATES[M1][`ALU_OP] = `ALU_CP;
                                        MSTATES[M1][`LD_ACCUM] = 1;
                                    end
                                endcase
                            end
                        endcase
                    end
                    2'b11:begin //x = 3
                        case(z)
                            3'b000:begin //RET cc
                                MSTATES[M1][`MUX_EXEC_COND] = `MUX_EXEC_COND_Y;
                                MSTATES[M1][`LD_CMET] = 1;
                                MSTATES[M1][`DEC_MCTR_CC] = 1;
                                MSTATES[M1][`F_stall] = 2'd1;
                                MSTATES[M3][`LD_PC] = 1;
                                MSTATES[M3][`PCMUX] = `PCMUX_MDR;
                            end
                            3'b001:begin 
                                case(q)
                                    1'b0:begin//POP rp2
                                        MSTATES[M3][A_MUX] = `A_MUX_MDR;
                                        MSTATES[M3][DR_MUX] = `DR_MUX_DR;
                                        MSTATES[M3][ALU_OP] = `ALU_PASSA;
                                        MSTATES[M3][LD_REG] = 1;
                                        MSTATES[M3][SR_RP] = 1;
                                    end
                                    1'b1:begin
                                        case(p)
                                            2'b0:begin//RET
                                                MSTATES[M3][LD_PC] = 1;
                                                MSTATES[M3][PCMUX] = `PCMUX_MDR;
                                            end
                                            2'b1:begin//EXX
                                                MSTATES[M1][EXX] = 1;
                                            end
                                            2'b10:begin//JP HL
                                                MSTATES[M1][LD_PC] = 1;
                                                MSTATES[M1][PCMUX] = `PCMUX_ALU;
                                                MSTATES[M1][A_MUX] = `A_MUX_HL;
                                                MSTATES[M1][ALU_OP] = `ALU_PASSA;
                                            end
                                            2'b11:begin//LD SP, HL
                                                MSTATES[M3][A_MUX] = `A_MUX_HL;
                                                MSTATES[M3][F_stall] = 2'd2;
                                                MSTATES[M3][ALU_OP] = `ALU_PASSA;
                                                MSTATES[M3][LD_REG] = 1;
                                                MSTATES[M3][DR_MUX] = `DR_MUX_SP;
                                            end
                                        endcase
                                    end
                                endcase
                            end
                            3'b010:begin //JP cc, nn
                                MSTATES[M1][`MUX_EXEC_COND] = `MUX_EXEC_COND_Y;
                                MSTATES[M1][`LD_CMET] = 1;
                                MSTATES[M1][`DEC_MCTR_CC] = 1;
                                MSTATES[M1][`F_stall] = 2'd1;
                                MSTATES[M3][`PC_CONDLD] = 1;
                                MSTATES[M3][`PCMUX] = `PCMUX_MDR;
                            end
                            3'b011:begin
                                case(y)
                                    3'b000:begin //JP nn
                                        MSTATES[M3][`LD_PC] = 1;
                                        MSTATES[M3][`PCMUX] = `PCMUX_MDR;
                                    end
                                    3'b001:begin //CB prefix
                                        next_PLA = 2'b01;
                                        ld_PLA = 1;
                                    end
                                    3'b010:begin //OUT (n), A
                                        MSTATES[M2][`MAR_MUX] = `MAR_MUX_MDR_A;
                                        MSTATES[M2][`LD_MAR] = 1;
                                        MSTATES[M2][`LD_MDR] = 1;
                                        MSTATES[M2][`A_MUX] = `A_MUX_A;
                                        MSTATES[M2][`ALU_OP] = `ALU_PASSA;
                                    end
                                    3'b011:begin //IN A, (n)
                                        MSTATES[M2][`MAR_MUX] = `MAR_MUX_MDR_A;
                                        MSTATES[M2][`LD_MAR] = 1;
                                        MSTATES[M2][`LD_MDR] = 1;
                                        MSTATES[M2][`A_MUX] = `A_MUX_MDR;
                                        MSTATES[M3][`DR_MUX] = `DR_MUX_DR;
                                        MSTATES[M2][`ALU_OP] = `ALU_PASSA;
                                        MSTATES[M3][`LD_REG] = 1;
                                        MSTATES[M3][`A_MUX] = `A_MUX_MDR;
                                        MSTATES[M3][`ALU_OP] = `ALU_PASSA;
                                    end
                                    3'b100:begin //EX (SP), HL
                                        MSTATES[M3][`A_MUX] = `A_MUX_MDR;
                                        MSTATES[M3][`DR_MUX] = `DR_MUX_HL;
                                        MSTATES[M3][`ALU_OP] = `ALU_PASSA;
                                        MSTATES[M3][`LD_MDR] = 1;
                                        MSTATES[M3][`MDR_MUX] = 1;
                                    end
                                    3'b101:begin //EX DE, HL
                                        MSTATES[M1][EX] = 1;
                                    end
                                    3'b110:begin //DI
                                        MSTATES[M1][`INT_FF_RESET] = 1;
                                    end
                                    3'b111:begin //EI
                                        MSTATES[M1][`INT_FF_SET] = 1;
                                    end
                                endcase
                            end
                            3'b100:begin //call CC, nn
                                MSTATES[M1][`MUX_EXEC_COND] = `MUX_EXEC_COND_Y;
                                MSTATES[M1][`LD_CMET] = 1;
                                MSTATES[M1][`DEC_MCTR_CC] = 1;
                                MSTATES[M3][`LD_PC] = 1;
                                MSTATES[M3][`PCMUX] = `PCMUX_MDR;
                                MSTATES[M3][`A_MUX] = `A_MUX_PC;
                                MSTATES[M3][`ALU_OP] = `ALU_PASSA;
                                MSTATES[M3][`LD_MDR] = 1;
                                MSTATES[M3][`MDR_MUX] = 0;
                                MSTATES[M3][`CONDSTALL] = 1;
                            end
                            3'b101:begin
                                case(q)
                                    1'b0:begin //PUSH rp2
                                        MSTATES[M1][`A_MUX] = `A_MUX_SR1;
                                        MSTATES[M1][`ALU_OP] = `ALU_PASSA;
                                        MSTATES[M1][`DR_MUX] = `DR_MUX_MDR;
                                        MSTATES[M1][`LD_MDR] = 1;
                                        MSTATES[M1][`SR_RP] = 1;
                                    end
                                    1'b1:begin
                                        case(p)
                                            2'b0:begin //CALL nn
                                                MSTATES[M3][`STALL_1] = 1;
                                                MSTATES[M3][`LD_MDR] = 1;
                                                MSTATES[M3][`MDR_MUX] = 0;
                                                MSTATES[M3][`A_MUX] = `A_MUX_PC;
                                                MSTATES[M3][`ALU_OP] = `ALU_PASSA;
                                                MSTATES[M3][`LD_PC] = 1;
                                                MSTATES[M3][`PCMUX] = `PCMUX_MDR;
                                            end
                                            2'b1:begin //DD prefix
                                                next_IX_pref = 1;
                                            end
                                            2'b10:begin //ED prefix
                                                next_PLA = 2'b10;
                                                ld_PLA = 1;
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
                                        MSTATES[M2][`A_MUX] = `A_MUX_A;
                                        MSTATES[M2][`B_MUX] = `B_MUX_MDR;
                                        MSTATES[M2][`ALU_OP] = `ALU_ADD_8BIT;
                                        MSTATES[M2][`LD_ACCUM] = 1;
                                    end
                                    3'b001:begin //SUB n
                                        MSTATES[M2][`A_MUX] = `A_MUX_A;
                                        MSTATES[M2][`B_MUX] = `B_MUX_MDR;
                                        MSTATES[M2][`ALU_OP] = `ALU_SUB_8BIT;
                                        MSTATES[M2][`LD_ACCUM] = 1;
                                    end
                                    3'b010:begin //AND n
                                        MSTATES[M2][`A_MUX] = `A_MUX_A;
                                        MSTATES[M2][`B_MUX] = `B_MUX_MDR;
                                        MSTATES[M2][`ALU_OP] = `ALU_AND;
                                        MSTATES[M2][`LD_ACCUM] = 1;
                                    end
                                    3'b011:begin //OR n
                                        MSTATES[M2][`A_MUX] = `A_MUX_A;
                                        MSTATES[M2][`B_MUX] = `B_MUX_MDR;
                                        MSTATES[M2][`ALU_OP] = `ALU_OR;
                                        MSTATES[M2][`LD_ACCUM] = 1;
                                    end
                                    3'b100:begin //ADC n
                                        MSTATES[M2][`A_MUX] = `A_MUX_A;
                                        MSTATES[M2][`B_MUX] = `B_MUX_MDR;
                                        MSTATES[M2][`ALU_OP] = `ALU_ADC;
                                        MSTATES[M2][`LD_ACCUM] = 1;
                                    end
                                    3'b101:begin //SBC n
                                        MSTATES[M2][`A_MUX] = `A_MUX_A;
                                        MSTATES[M2][`B_MUX] = `B_MUX_MDR;
                                        MSTATES[M2][`ALU_OP] = `ALU_SBC;
                                        MSTATES[M2][`LD_ACCUM] = 1;
                                    end
                                    3'b110:begin //XOR n
                                        MSTATES[M2][`A_MUX] = `A_MUX_A;
                                        MSTATES[M2][`B_MUX] = `B_MUX_MDR;
                                        MSTATES[M2][`ALU_OP] = `ALU_XOR;
                                        MSTATES[M2][`LD_ACCUM] = 1;
                                    end
                                    3'b111:begin //CP n
                                        MSTATES[M2][`A_MUX] = `A_MUX_A;
                                        MSTATES[M2][`B_MUX] = `B_MUX_MDR;
                                        MSTATES[M2][`ALU_OP] = `ALU_CP;
                                        MSTATES[M2][`LD_ACCUM] = 1;
                                    end
                                endcase
                            end
                            3'b111:begin //RST y<<3
                                MSTATES[M1][`A_MUX] = `A_MUX_PC;
                                MSTATES[M1][`ALU_OP] = `ALU_PASSA;
                                MSTATES[M1][`LD_MDR] = 1;
                                MSTATES[M1][`MDR_MUX] = 0;
                                MSTATES[M1][`LD_PC] = 1;
                                MSTATES[M1][`PCMUX] = `PCMUX_Y_SHIFT;
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
                                        MSTATES[M1][`LD_MAR] = 1;
                                        MSTATES[M1][`A_MUX] = `A_MUX_HL;
                                        MSTATES[M1][`MARMUX] = 0;
                                        MSTATES[M2][`LD_MDR] = 1;
                                        MSTATES[M2][`A_MUX] = `A_MUX_MDR;
                                        MSTATES[M2][`ALU_OP] = `ALU_RLCA;
                                    end
                                    3'b001:begin //RRC (HL)
                                        MSTATES[M1][`LD_MAR] = 1;
                                        MSTATES[M1][`A_MUX] = `A_MUX_HL;
                                        MSTATES[M1][`MARMUX] = 0;
                                        MSTATES[M2][`LD_MDR] = 1;
                                        MSTATES[M2][`A_MUX] = `A_MUX_MDR;
                                        MSTATES[M2][`ALU_OP] = `ALU_RRCA;
                                    end
                                    3'b010:begin //RL (HL)
                                        MSTATES[M1][`LD_MAR] = 1;
                                        MSTATES[M1][`A_MUX] = `A_MUX_HL;
                                        MSTATES[M1][`MARMUX] = 0;
                                        MSTATES[M2][`LD_MDR] = 1;
                                        MSTATES[M2][`A_MUX] = `A_MUX_MDR;
                                        MSTATES[M2][`ALU_OP] = `ALU_RLA;
                                    end
                                    3'b011:begin //RR (HL)
                                        MSTATES[M1][`LD_MAR] = 1;
                                        MSTATES[M1][`A_MUX] = `A_MUX_HL;
                                        MSTATES[M1][`MARMUX] = 0;
                                        MSTATES[M2][`LD_MDR] = 1;
                                        MSTATES[M2][`A_MUX] = `A_MUX_MDR;
                                        MSTATES[M2][`ALU_OP] = `ALU_RRA;
                                    end
                                    3'b100:begin //SLA (HL)
                                        MSTATES[M1][`LD_MAR] = 1;
                                        MSTATES[M1][`A_MUX] = `A_MUX_HL;
                                        MSTATES[M1][`MARMUX] = 0;
                                        MSTATES[M2][`LD_MDR] = 1;
                                        MSTATES[M2][`A_MUX] = `A_MUX_MDR;
                                        MSTATES[M2][`ALU_OP] = `ALU_SLA;
                                    end
                                    3'b101:begin //SRA (HL)
                                        MSTATES[M1][`LD_MAR] = 1;
                                        MSTATES[M1][`A_MUX] = `A_MUX_HL;
                                        MSTATES[M1][`MARMUX] = 0;
                                        MSTATES[M2][`LD_MDR] = 1;
                                        MSTATES[M2][`A_MUX] = `A_MUX_MDR;
                                        MSTATES[M2][`ALU_OP] = `ALU_SRA;
                                    end
                                    3'b110:begin //SLL (HL)
                                        MSTATES[M1][`LD_MAR] = 1;
                                        MSTATES[M1][`A_MUX] = `A_MUX_HL;
                                        MSTATES[M1][`MARMUX] = 0;
                                        MSTATES[M2][`LD_MDR] = 1;
                                        MSTATES[M2][`A_MUX] = `A_MUX_MDR;
                                        MSTATES[M2][`ALU_OP] = `ALU_SLL;
                                    end
                                    3'b111:begin //SRL (HL)
                                        MSTATES[M1][`LD_MAR] = 1;
                                        MSTATES[M1][`A_MUX] = `A_MUX_HL;
                                        MSTATES[M1][`MARMUX] = 0;
                                        MSTATES[M2][`LD_MDR] = 1;
                                        MSTATES[M2][`A_MUX] = `A_MUX_MDR;
                                        MSTATES[M2][`ALU_OP] = `ALU_SRL;
                                    end
                                endcase
                            end
                            default:begin
                                case(y)
                                    3'b000:begin //RLC r[z]
                                        MSTATES[M1][`A_MUX] = `A_MUX_Z;
                                        MSTATES[M1][`ALU_OP] = `ALU_RLCA;
                                        MSTATES[M1][`LD_REG] = 1;
                                        MSTATES[M1][`DR_MUX] = `DR_MUX_Z;
                                    end
                                    3'b001:begin //RRC r[z]
                                        MSTATES[M1][`A_MUX] = `A_MUX_Z;
                                        MSTATES[M1][`ALU_OP] = `ALU_RRCA;
                                        MSTATES[M1][`LD_REG] = 1;
                                        MSTATES[M1][`DR_MUX] = `DR_MUX_Z;
                                    end
                                    3'b010:begin //RL r[z]
                                        MSTATES[M1][`A_MUX] = `A_MUX_Z;
                                        MSTATES[M1][`ALU_OP] = `ALU_RLA;
                                        MSTATES[M1][`LD_REG] = 1;
                                        MSTATES[M1][`DR_MUX] = `DR_MUX_Z;
                                    end
                                    3'b011:begin //RR r[z]
                                        MSTATES[M1][`A_MUX] = `A_MUX_Z;
                                        MSTATES[M1][`ALU_OP] = `ALU_RRA;
                                        MSTATES[M1][`LD_REG] = 1;
                                        MSTATES[M1][`DR_MUX] = `DR_MUX_Z;
                                    end
                                    3'b100:begin //SLA r[z]
                                        MSTATES[M1][`A_MUX] = `A_MUX_Z;
                                        MSTATES[M1][`ALU_OP] = `ALU_SLA;
                                        MSTATES[M1][`LD_REG] = 1;
                                        MSTATES[M1][`DR_MUX] = `DR_MUX_Z;
                                    end
                                    3'b101:begin //SRA r[z]
                                        MSTATES[M1][`A_MUX] = `A_MUX_Z;
                                        MSTATES[M1][`ALU_OP] = `ALU_SRA;
                                        MSTATES[M1][`LD_REG] = 1;
                                        MSTATES[M1][`DR_MUX] = `DR_MUX_Z;
                                    end
                                    3'b110:begin //SLL r[z]
                                        MSTATES[M1][`A_MUX] = `A_MUX_Z;
                                        MSTATES[M1][`ALU_OP] = `ALU_SLL;
                                        MSTATES[M1][`LD_REG] = 1;
                                        MSTATES[M1][`DR_MUX] = `DR_MUX_Z;
                                    end
                                    3'b111:begin //SRL r[z]
                                        MSTATES[M1][`A_MUX] = `A_MUX_Z;
                                        MSTATES[M1][`ALU_OP] = `ALU_SRL;
                                        MSTATES[M1][`LD_REG] = 1;
                                        MSTATES[M1][`DR_MUX] = `DR_MUX_Z;
                                    end
                                endcase 
                            end
                        endcase
                    end
                    2'b01:begin
                        case(z)
                            3'b110:begin //BIT y, (HL)
                                MSTATES[M1][`LD_MAR] = 1;
                                MSTA TES[M1][`A_MUX] = `A_MUX_HL;
                                MSTATES[M1][`MARMUX] = 0;
                                MSTATES[M2][`A_MUX] = `A_MUX_MDR;
                                MSTATES[M2][`ALU_OP] = `ALU_TEST_BASE + y; //this might not work
                            end
                            default:begin //BIT y, r[z]
                                MSTATES[M1][`A_MUX] = `A_MUX_Z;
                                MSTATES[M1][`ALU_OP] = `ALU_TEST_BASE + y;
                            end
                        endcase
                    end
                    2'b10:begin
                        case(z)
                            3'b110:begin //RES y, (HL)
                                MSTATES[M1][`LD_MAR] = 1;
                                MSTATES[M1][`A_MUX] = `A_MUX_HL;
                                MSTATES[M1][`MARMUX] = 0;
                                MSTATES[M2][`LD_MDR] = 1;
                                MSTATES[M2][`A_MUX] = `A_MUX_MDR;
                                MSTATES[M2][`ALU_OP] = `ALU_RES_BASE + y;
                            end
                            default:begin //RES y, r[z]
                                MSTATES[M1][`A_MUX] = `A_MUX_Z;
                                MSTATES[M1][`ALU_OP] = `ALU_RES_BASE + y;
                                MSTATES[M1][`LD_REG] = 1;
                                MSTATES[M1][`DR_MUX] = `DR_MUX_Z;
                            end
                        endcase
                    end
                    2'b11:begin
                        case(z)
                            3'b110:begin //SET y, (HL)
                                MSTATES[M1][`LD_MAR] = 1;
                                MSTATES[M1][`A_MUX] = `A_MUX_HL;
                                MSTATES[M1][`MARMUX] = 0;
                                MSTATES[M2][`LD_MDR] = 1;
                                MSTATES[M2][`A_MUX] = `A_MUX_MDR;
                                MSTATES[M2][`ALU_OP] = `ALU_SET_BASE + y;
                            end
                            default:begin //SET y, r[z]
                                MSTATES[M1][`A_MUX] = `A_MUX_Z;
                                MSTATES[M1][`ALU_OP] = `ALU_SET_BASE + y;
                                MSTATES[M1][`LD_REG] = 1;
                                MSTATES[M1][`DR_MUX] = `DR_MUX_Z;
                            end
                        endcase
                    end
                endcase
            end
            2'b10:begin //this is the extra cringe PLA
                case(z)
                    3'b000:begin
                        case(y)
                            3'b110:begin //NOP
                                //NOP
                            end
                            default:begin //IN r[y], (C)

                            end
                    end
                endcase
            end
            2'b11:begin //this is the cringe with IX or IY PLA
            end
            
        endcase
    end
    
    

    
    
    
endmodule
