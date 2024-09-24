`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2024 01:03:09 PM
// Design Name: 
// Module Name: tb_ALU
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

`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %m: signal != value"); \
            $finish; \
        end

module tb_ALU(
    input CLK
    );
    
    
    
    reg [6:0] ALU_OP;
    reg [15:0] operandA;
    reg [15:0] operandB;
    reg [7:0] flag;
    
    wire [15:0] ALU_OUT;
    wire [7:0] FLAG_OUT;
    
    ALU_Core alu (ALU_OP, operandA, operandB, flag, ALU_OUT, FLAG_OUT);
    
    initial begin
    
        operandA = 0;
        operandB = 0;
        
        // ADD 8bit
        ALU_OP = 0;
        operandA[7:0] = 5;
        operandB[7:0] = 11;
        flag = 0;
        #10;
        `assert(ALU_OUT[7:0], 16);
        `assert(FLAG_OUT, {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0});
        
        operandA[7:0] = 5;
        operandB[7:0] = -6;
        flag = 0;
        #10;
        `assert(ALU_OUT[7:0], 8'hFF);
        `assert(FLAG_OUT, {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0});
        
        operandA[7:0] = 127;
        operandB[7:0] = 1;
        flag = 0;
        #10;
        `assert(ALU_OUT[7:0], 8'h80);
        `assert(FLAG_OUT, {1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0});
        
        operandA[7:0] = -1;
        operandB[7:0] = 1;
        flag = 0;
        #10;
        `assert(ALU_OUT[7:0], 0);
        `assert(FLAG_OUT, {1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1});
    end
endmodule
