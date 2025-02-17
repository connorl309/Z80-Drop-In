`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2025 09:09:25 PM
// Design Name: 
// Module Name: addr_bus_gater
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


module addr_bus_gater(
    output [15:0] ADDR_OUT,
    
    input [15:0] PC,
    input GATE_PC,
    
    input [15:0] MAR,
    input GATE_MARL,
    input GATE_MARH,
    
    input [15:0] SP,
    input GATE_SP_INC,
    input GATE_SP_DEC,
    
    input [15:0] REG_ADDR_BUS
    );
endmodule
