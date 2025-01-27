`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2025 03:50:32 PM
// Design Name: 
// Module Name: tb_uart
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


module tb_uart(

    );
    
    reg rx = 1;
    wire tx;
    reg clk = 0;
    reg reset = 1;
    
    parameter CLOCK_PERIOD = 10;
    
    parameter UART_BAUD = 115200;
    
    parameter DELAY = 1000000000 / UART_BAUD;
    
    initial begin
        $display($time, " << Starting the Simulation >>");
        reset = 1;
        clk = 0;
        #5 reset = 1'b1;
    end
    
    always #CLOCK_PERIOD clk=~clk;
    
    bd_tb_uart uart(
        .sys_clock(clk),
        .RX(rx),
        .TX(tx),
        .reset(reset)
    );
    
    initial begin
    
    end
endmodule
