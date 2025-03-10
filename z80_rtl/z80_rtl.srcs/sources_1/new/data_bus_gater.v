`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2025 08:56:08 PM
// Design Name: 
// Module Name: data_bus_gater
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


module data_bus_gater(
    output [7:0] D_OUT,
    input [7:0] MDRL,
    input GATE_MDRL,
    input [7:0] MDRH,
    input GATE_MDRH
    );
    
    wire [7:0] out_wire;
    assign D_OUT = out_wire;
    bufif1 bufif1_MDRL [7:0] (out_wire, MDRL, GATE_MDRL);
    bufif1 bufif1_MDRH [7:0] (out_wire, MDRH, GATE_MDRH);

endmodule
