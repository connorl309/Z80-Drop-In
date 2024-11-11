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
//alu signals
`define ALU_OP_0
`define ALU_OP_1
`define ALU_OP_2
`define ALU_OP_3
`define ALU_OP_4
`define ALU_OP_5
`define ALU_OP_6
`define LD_ACCUM //Loads A to be equal to result of ALU (hopefully)
`define LD_FLAG //loads flags based on result data, depending on ALUOP - April needs to add the non aluop instructions as aluops too
//notable datapath requirements we may not have: PASS A, PASS B, Set flags

//muxes
`define A_MUX   //chooses between MDR and SR2
`define B_MUX   //chooses between PC and SR1
`define MUX_EXEC_COND_0 //chooses between condition y, y-4, 0 (NZ), and 1 (Z)
`define MUX_EXEC_COND_1
`define PCMUX_0 //chooses between ALU (BUSC), IR (Absolute), PC + 1, y << 3
`define PCMUX_1
`define PC_CONDLD //if 1, only loads pc if condition met
`define CONDSTALL //if 1, useq only uses stal1 if condition met
`define SR1_MUX //chooses between 5:3 and 2:0 of opcode
`define MAR_MUX //chooses between HL and MDR
`define EXEC_COND_MUX //chooses which condition to use if ld_CMET

//register file signals
`define RP_TABLE // chooses which register pair to load from
`define I_out   //I as SR1
`define R_out   //R as SR1
`define IX_out //IX as SR1
`define IY_out //IY as SR1
`define HL_out //HL as SR1
`define BC_out //BC as SR1
`define DE_out //DE as SR1
`define ld_HL //Bus C to HL
`define ld_I //Bus C to I
`define ld_R //Bus C to R
`define EXLATCH
//bits 4-5 of opcode along with RP_TABLE select register pairs, but this doesn't get handled in RF if ALU has AF still
//sr1 outputs based on SR1_MUX uness overriden by specific register signals.
//sr2 output based on bits 5:3 of the opcode always
//Needs to be a separate port for HL

//ld signals other than reg file
`define LD_PC 
`define LD_REG
`define LD_MDR
`define LD_MAR
`define LD_CMET //loads false if condition not met (set true by default in usequencer)

//usequencer signals
`define DEC_MCTR_CC
`define HALT
`define FETCH_AGAIN
`define NEXT_PLA //latched if there is a prefix, reset on last m cycle
`define STALL_1 //we can stall either 1 or 2 cycles in certain places 
`define STALL_2 

//system signals
`define HALT    //does something in datapath somewhere
`define INT_FF_RESET //sets 
`define INT_FF_SET
`define IFF2_to_IFF1 //IFF2 --> IFF1

module decode(
    input [7:0] IR,
    input [1:0] PLA_idx,
    input IX, IY,
    output [4:0] M_states [6:0], //what are the next M-states? Could be up to 7
    output [10:0] INST_SIGNALS [6:0], // exec signals for M-states
    output [2:0] MAX_CNT, //Num M-States to follow this fetch/decode
    output [1:0] F_stall //anded into the stall signals in usequencer probably
    );
    
    
    
    
endmodule
