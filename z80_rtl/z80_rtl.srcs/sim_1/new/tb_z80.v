`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2025 12:47:13 AM
// Design Name: 
// Module Name: tb_z80
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


module tb_z80(

    );
    
    reg CLK = 0;
    reg RESET = 0;
    
    always #100 CLK = !CLK;
    
    initial begin
        #100 RESET = 1;
    end
    
    z80_test_system_wrapper test_system (CLK, RESET);
    
endmodule
