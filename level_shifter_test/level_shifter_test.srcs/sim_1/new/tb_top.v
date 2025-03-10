`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2025 01:42:48 PM
// Design Name: 
// Module Name: tb_top
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


module tb_top(

    );
    
    wire [15:0] A, D;
    wire BUSAK, BUSRQ, HALT, INT2, IORQ, M1, MREQ, NMI, RD, RESET2, RFSH, WAIT2, WR, CLK_OUT;
    reg clk = 0;
    reg reset = 0;
    
    top_wrapper top_mod (A, BUSAK, BUSRQ, CLK_OUT, D, HALT, INT2, IORQ, M1, MREQ, NMI, RD, RESET2, RFSH, WAIT2, WR, reset, clk);
    
    always begin
        #10 clk = !clk;
    end
    
    initial begin
        reset = 1;
        #10;
        reset = 0;
        #1000;
    end
    
endmodule
