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
    output reg [7:0] DATA_OUT
    );
    
    reg [7:0] mem [65534:0]; // memory
    
    integer i;
    
    initial begin
        $display("Clearing Memory");
        for (i = 0; i < 65535; i = i + 1) begin
            mem[i] = 0;
        end
        $display("Loading Memory");
        $readmemh("memory.txt", mem); // will load the hex binary contained in memory.txt
    end
    
    always @(negedge CLK) begin
        if (!MREQ && !RD) begin
            DATA_OUT <= mem[ADDR];
        end else if (!MREQ && !WR) begin
            mem[ADDR] <= DATA_IN;
        end
    end
    
endmodule
