`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2025 01:33:40 PM
// Design Name: 
// Module Name: tb_z80_system
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

module tb_z80_system
   (CLK,
    RESET);
  input CLK;
  input RESET;

  wire CLK;
  wire RESET;

  z80_test_system_wrapper z80
       (.CLK(CLK),
        .RESET(RESET));
endmodule