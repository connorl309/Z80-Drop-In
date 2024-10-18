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

`define assert(signal, value, string) \
        if (signal !== value) \
            $display("ASSERTION FAILED in %m: signal != value for case %s", string)
            
module tb_ALU(
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
        ALU_OP = `ALU_ADD_8BIT;
        operandA[7:0] = 5;
        operandB[7:0] = 11;
        flag = 0;
        #10;
        `assert(ALU_OUT[7:0], 16, "ALU ADD1");
        `assert(FLAG_OUT, {1'b0, 1'b0, ALU_OUT[5], 1'b1, ALU_OUT[3], 1'b0, 1'b0, 1'b0}, "FLAG ADD1");
        
        operandA[7:0] = 5;
        operandB[7:0] = -6;
        flag = 0;
        #10;
        `assert(ALU_OUT[7:0], 8'hFF, "ALU ADD2");
        `assert(FLAG_OUT, {1'b1, 1'b0, ALU_OUT[5], 1'b0, ALU_OUT[3], 1'b0, 1'b0, 1'b0}, "FLAG ADD2");
        
        operandA[7:0] = 127;
        operandB[7:0] = 1;
        flag = 0;
        #10;
        `assert(ALU_OUT[7:0], 8'h80, "ALU ADD3");
        `assert(FLAG_OUT, {1'b1, 1'b0, ALU_OUT[5], 1'b1, ALU_OUT[3], 1'b1, 1'b0, 1'b0}, "FLAG ADD3");
        
        operandA[7:0] = -1;
        operandB[7:0] = 1;
        flag = 0;
        #10;
        `assert(ALU_OUT[7:0], 0, "ALU ADD4");
        `assert(FLAG_OUT, {1'b0, 1'b1, ALU_OUT[5], 1'b1, ALU_OUT[3], 1'b0, 1'b0, 1'b1}, "FLAG ADD4");
        
        
        // ADC 8bit
        ALU_OP = `ALU_ADC_8BIT;
        operandA[7:0] = 5;
        operandB[7:0] = 11;
        flag[`FLAG_C] = 1;
        #10;
        `assert(ALU_OUT[7:0], 17, "ALU ADC1");
        `assert(FLAG_OUT, {1'b0, 1'b0, ALU_OUT[5], 1'b1, ALU_OUT[3], 1'b0, 1'b0, 1'b0}, "FLAG ADC1");
        
        operandA[7:0] = 5;
        operandB[7:0] = -7;
        flag[`FLAG_C] = 1;
        #10;
        `assert(ALU_OUT[7:0], 8'hFF, "ALU ADC2");
        `assert(FLAG_OUT, {1'b1, 1'b0, ALU_OUT[5], 1'b0, ALU_OUT[3], 1'b0, 1'b0, 1'b0}, "FLAG ADC2");
        
        operandA[7:0] = 127;
        operandB[7:0] = 0;
        flag[`FLAG_C] = 1;
        #10;
        `assert(ALU_OUT[7:0], 8'h80, "ALU ADC3");
        `assert(FLAG_OUT, {1'b1, 1'b0, ALU_OUT[5], 1'b1, ALU_OUT[3], 1'b1, 1'b0, 1'b0}, "FLAG ADC3");
        
        operandA[7:0] = -1;
        operandB[7:0] = 0;
        flag[`FLAG_C] = 1;
        #10;
        `assert(ALU_OUT[7:0], 0, "ALU ADD4");
        `assert(FLAG_OUT, {1'b0, 1'b1, ALU_OUT[5], 1'b1, ALU_OUT[3], 1'b0, 1'b0, 1'b1}, "FLAG ADC4");
        
        
        // SUB 8bit
        ALU_OP = `ALU_SUB_8BIT;
        operandA[7:0] = 11;
        operandB[7:0] = 5;
        flag = 0;
        #10;
        `assert(ALU_OUT[7:0], 6, "ALU SUB1");
        
        operandA[7:0] = 5;
        operandB[7:0] = -6;
        flag = 0;
        #10;
        `assert(ALU_OUT[7:0], 11, "ALU SUB2");
        
        operandA[7:0] = 0;
        operandB[7:0] = 1;
        flag = 0;
        #10;
        `assert(ALU_OUT[7:0], 8'hFF, "ALU SUB3");
        
        operandA[7:0] = -1;
        operandB[7:0] = 1;
        flag = 0;
        #10;
        `assert(ALU_OUT[7:0], 8'hFE, "ALU SUB4");
        
        // SBC 8bit
        ALU_OP = `ALU_SBC_8BIT;
        operandA[7:0] = 11;
        operandB[7:0] = 5;
        flag[`FLAG_C] = 1;
        #10;
        `assert(ALU_OUT[7:0], 5, "ALU SBC1");
        
        operandA[7:0] = 5;
        operandB[7:0] = -5;
        flag[`FLAG_C] = 1;
        #10;
        `assert(ALU_OUT[7:0], 9, "ALU SBC2");
        
        operandA[7:0] = 0;
        operandB[7:0] = 0;
        flag[`FLAG_C] = 1;
        #10;
        `assert(ALU_OUT[7:0], 8'hFF, "ALU SBC3");
        
        operandA[7:0] = -1;
        operandB[7:0] = 0;
        flag[`FLAG_C] = 1;
        #10;
        `assert(ALU_OUT[7:0], 8'hFE, "ALU SBC4");
    end
endmodule
