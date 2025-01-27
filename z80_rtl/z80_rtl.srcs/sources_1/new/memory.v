`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2024 06:08:14 PM
// Design Name: 
// Module Name: memory
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


module memory(
    input CLK,
    input MREQ,
    input RD,
    input WR,
    input [15:0] ADDR,
    input [7:0] DATA_IN,
    output [7:0] DATA_OUT
    );

    blk_mem_gen_0 RAM (
        .clka(CLK),
        .addra(ADDR),
        .dina(DATA_IN),
        .douta(DATA_OUT),
        .ena(!MREQ && !RD),
        .wea(!MREQ && !WR)
    );
    
endmodule
