`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/23/2025 06:31:46 PM
// Design Name: 
// Module Name: top
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


module top(
    input CLK1,
    input RESET,
    input RXD,
    output TXD
    );
    
    bd_tb_uart test (
        .sys_clock(CLK1),
        .reset(RESET),
        .RX(RXD),
        .TX(TXD)
    );
endmodule
