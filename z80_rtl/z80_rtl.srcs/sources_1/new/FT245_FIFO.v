`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/24/2025 04:44:36 PM
// Design Name: 
// Module Name: FT245_FIFO
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


module FT245_FIFO(
    input CLKOUT,
    inout [7:0] DATA,
    input RXF_N,
    input TXE_N,
    output RD_N,
    output WR_N,
    output OE_N
    );
    
    assign DATA = 8'h41; // A in ASCII
    assign WR_N = 1'b0;
    assign OE_N = 1'b1;
    assign RD_N = 1'b1;
endmodule
