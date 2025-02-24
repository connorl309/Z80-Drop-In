`timescale 1ns / 1ps
`include "z80_defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2025 08:47:26 PM
// Design Name: 
// Module Name: control_signal_slicer
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


module control_signal_slicer(
    input [48:0] m_signals,
    
    output [`PCMUX] PCMUX,
    output [`A_MUX] A_MUX,
    output [`B_MUX] B_MUX,
    output [`DR_MUX] DR_MUX,
    output [`MAR_MUX] MAR_MUX,
    output [`MDR_MUX] MDR_MUX,
    output RP_TABLE,
    output EXX,
    output LD_PC,
    output LD_I,
    output LD_R,
    output LD_REG,
    output LD_MDR,
    output LD_MAR,
    output GATE_PC,
    output GATE_MARL,
    output GATE_MARH,
    output GATE_SP_INC,
    output GATE_SP_DEC,
    output LD_SP,
    output SP_MUX,
    output [`ALU_OP] ALU_OP,
    output LD_ACCUM,
    output RP,
    output SEXT_MDR,
    output LD_IR,
    output GATE_MDRL,
    output GATE_MDRH,
    output MDR_TEMP,
    output IFF1_R_TO_IFF2,
    output RD_R_RE,
    output WR_R_RE
    );
endmodule
