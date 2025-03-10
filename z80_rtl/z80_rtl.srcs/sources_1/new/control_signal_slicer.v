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
    input [`CS_BITS_MINUS_1:0] m_signals,
    input [`TSIGNALS - 1:0] t_signals,
    
    output [2:0] PCMUX,
    output [3:0] A_MUX,
    output [1:0] B_MUX,
    output [2:0] DR_MUX,
    output [2:0] MAR_MUX,
    output [1:0] MDR_MUX,
    output RP_TABLE,
    output EXX,
    output LD_PC,
    output INC_PC,
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
    output WR_R_RE,
    output F_SWAP,
    output LD_MDRL,
    output LD_MDRH
    );
    
    assign PCMUX = m_signals[`PCMUX];
    assign A_MUX = m_signals[`A_MUX];
    assign B_MUX = m_signals[`B_MUX];
    assign DR_MUX = m_signals[`DR_MUX];
    assign MAR_MUX = m_signals[`MAR_MUX];
    assign MDR_MUX = m_signals[`MDR_MUX];
    assign RP_TABLE = m_signals[`RP_TABLE];
    assign EXX = m_signals[`EXX];
    assign LD_PC = m_signals[`LD_PC];
    assign INC_PC = t_signals[`INC_PC];
    assign LD_I = m_signals[`LD_I];
    assign LD_R = m_signals[`LD_R];
    assign LD_REG = m_signals[`LD_REG];
    assign LD_MDR = m_signals[`LD_MDR];
    assign GATE_PC = t_signals[`GATE_PC];
    assign GATE_MARL = t_signals[`GATE_MARL];
    assign GATE_MARH = t_signals[`GATE_MARH];
    assign GATE_SP_INC = t_signals[`GATE_SP_INC];
    assign GATE_SP_DEC = t_signals[`GATE_SP_DEC];
    assign LD_SP = t_signals[`LD_SP];
    assign SP_MUX = t_signals[`SP_MUX];
    assign ALU_OP = m_signals[`ALU_OP];
    assign LD_ACCUM = m_signals[`LD_ACCUM];
    assign RP = m_signals[`RP];
    assign SEXT_MDR = m_signals[`SEXT_MDR];
    assign LD_IR = t_signals[`LD_IR];
    assign GATE_MDRL = t_signals[`GATE_MDRL];
    assign GATE_MDRH = t_signals[`GATE_MDRH];
    assign MDR_TEMP = t_signals[`MDR_TEMP];
    assign IFF1_R_TO_IFF2 = t_signals[`IFF1_R_TO_IFF2];
    assign F_SWAP = m_signals[`F_SWAP];
    assign LD_MDRL = t_signals[`LD_MDRL];
    assign LD_MDRH = t_signals[`LD_MDRH];
    
endmodule
