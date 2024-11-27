`timescale 1ns / 1ps
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


//muxes
`define MUX_EXEC_COND_0 0//chooses between condition y, y-4, 0 (NZ), and 1 (Z)
`define MUX_EXEC_COND_1 1
`define PCMUX_0 2 //chooses between ALU (BUSC), IR (Absolute), PC + 1, y << 3
`define PCMUX_1 3
`define PC_CONDLD 4 //if 1, only loads pc if condition met
`define CONDSTALL 5 //if 1, useq only uses stal1 if condition met
`define A_MUX_0 6 //chooses between 5:3 of opcode, 2:0 of opcode, HL, BC, DE, I, R, IX, IY, PC as SR1
`define A_MUX_1 7
`define A_MUX_2 8
`define A_MUX_3 9
`define B_MUX 0 1-  //chooses between MDR and SR2
`define DR_MUX_0 11  //chooses between 5:3 of opcode, 2:0 of opcode, HL, BC, DE as DR
`define DR_MUX_1 12
`define DR_MUX_2 13
`define MAR_MUX 14//chooses between HL and MDR
`define EXEC_COND_MUX 15//chooses which condition to use if ld_CMET

//register file signals
`define RP_TABLE 16// chooses which register pair to load from
`define I_out 17   //I as SR1
`define R_out 18  //R as SR1
`define IX_out 19 //IX as SR1
`define IY_out 20//IY as SR1
`define HL_out 21//HL as SR1
`define BC_out 22//BC as SR1
`define DE_out 23//DE as SR1
`define ld_IX 24
`define ld_IY 25
`define EXLATCH 26
//bits 4-5 of opcode along with RP_TABLE select register pairs, but this doesn't get handled in RF if ALU has AF still
//sr1 outputs based on SR1_MUX uness overriden by specific register signals.
//sr2 output based on bits 5:3 of the opcode always
//Needs to be a separate port for HL

//ld signals other than reg file
`define LD_PC 27
`define LD_I 28
`define LD_R 29
`define LD_REG 30
`define LD_MDR 31
`define LD_MAR 32
`define LD_CMET 33 //loads false if condition not met (set true by default in usequencer)

//usequencer signals
`define DEC_MCTR_CC 34
`define HALT 35
`define FETCH_AGAIN 36
`define NEXT_PLA 37//latched if there is a prefix, reset on last m cycle
`define STALL_1 38//we can stall either 1 or 2 cycles in certain places 
`define STALL_2 39

//system signals
`define HALT 40   //does something in datapath somewhere
`define INT_FF_RESET 41//sets 
`define INT_FF_SET 42
`define IFF2_to_IFF1 43//IFF2 --> IFF1

//alu signals
`define ALU_OP_0 44
`define ALU_OP_1 45
`define ALU_OP_2 46
`define ALU_OP_3 47
`define ALU_OP_4 48
`define ALU_OP_5 49
`define ALU_OP_6 50
`define LD_ACCUM 51 //Loads A to be equal to result of ALU (hopefully)
`define LD_FLAG 52 //loads flags based on result data, depending on ALUOP - April needs to add the non aluop instructions as aluops too

`define CS_BITS 53

`define SET(INST, MCYCLE, OFFSET) INST[MCYCLE][OFFSET] = 1;

module decode(
    input [7:0] IR,
    input wire [1:0] PLA_idx,
    input IX_pref, IY_pref, //need to add this to microsequencer later
    output reg [4:0] M_states [6:0], //what are the next M-states? Could be up to 7
    output reg [1:0] next_PLA,
    output reg ld_PLA,
    output reg [52:0] INST_SIGNALS [6:0], // exec signals for M-states
    output reg [2:0] MAX_CNT, //Num M-States to follow this fetch/decode
    output reg [1:0] F_stall //anded into the stall signals in usequencer probably
    );
    
    wire[1:0] x, p;
    wire[2:0] y, z;
    wire q;
    assign x = IR[7:6];
    assign y = IR[5:3];
    assign p = IR[5:4];
    assign q = IR[3];
    assign z = IR[2:0];
    integer i;
    
    always @(*) begin
        for(i = 0; i < 7; i = i+1) begin
            INST_SIGNALS[i] = 53'b0;
            M_states[i] = 7'b0;
        end
        MAX_CNT = 3'b0;
        ld_PLA = 0;
        next_PLA = 0;
        F_stall = 0;
        
        
        case (PLA_idx)
            2'b00:begin //this is the default PLA
                case (x)
                    2'b00:begin //x = 0
                        case(z)
                            3'b000:begin
                                //NOP
                            end
                            3'b001:begin
                                
                            end
                            3'b010:begin
                            end
                            3'b011:begin
                            end
                            3'b100:begin
                            end
                            3'b101:begin
                            end
                            3'b110:begin
                            end
                            3'b111:begin
                            end
                        endcase
                    end
                    2'b01:begin //x = 1
                    end
                    2'b10:begin //x = 2
                    end
                    2'b11:begin //x = 3
                    end
                endcase
            end
            2'b01:begin //this is bit instructions PLA
            end
            2'b10:begin //this is the extra cringe PLA
            end
            2'b11:begin //this is the cringe with IX or IY PLA
            end
            
        endcase
    end
    
    

    
    
    
endmodule
