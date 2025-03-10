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
    input GATE_SP_DEC
    );
    
    wire [15:0] out_wire;
    wire [15:0] MAR_PLUS = MAR + 1;
    wire [15:0] SP_MINUS = SP - 1;
    assign ADDR_OUT = out_wire;
    bufif1 bufif1_PC [15:0] (out_wire, PC, GATE_PC);
    bufif1 bufif1_MARL [15:0] (out_wire, MAR, GATE_MARL);
    bufif1 bufif1_MARH [15:0] (out_wire, MAR_PLUS, GATE_MARH);
    bufif1 bufif1_SP_INC [15:0] (out_wire, SP, GATE_SP_INC);
    bufif1 bufif1_SP_DEC [15:0] (out_wire, SP_MINUS, GATE_SP_DEC);
    
endmodule
