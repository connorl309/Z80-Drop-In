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
        
        
        // AND
        ALU_OP = `ALU_AND_8BIT;
        operandA[7:0] = 8'b10110110;
        operandB[7:0] = 8'b11110000;
        #10;
        `assert(ALU_OUT[7:0], 8'b10110000, "ALU AND");
        
        
        // OR
        ALU_OP = `ALU_OR_8BIT;
        operandA[7:0] = 8'b10110110;
        operandB[7:0] = 8'b11110000;
        #10;
        `assert(ALU_OUT[7:0], 8'b11110110, "ALU OR");
        
        
        // XOR
        ALU_OP = `ALU_XOR_8BIT;
        operandA[7:0] = 8'b10110110;
        operandB[7:0] = 8'b11110000;
        #10;
        `assert(ALU_OUT[7:0], 8'b01000110, "ALU XOR");
        
        
        // CP
        ALU_OP = `ALU_CP;
        operandA[7:0] = 8'b10110110;
        operandB[7:0] = 8'b11110000;
        #10;
        `assert(FLAG_OUT[`FLAG_Z], 0, "ALU CP1");
        
        operandA[7:0] = 8'b11110000;
        operandB[7:0] = 8'b11110000;
        #10;
        `assert(FLAG_OUT[`FLAG_Z], 1, "ALU CP2");
        
        
        // INC
        ALU_OP = `ALU_INC_8BIT;
        operandA[7:0] = 8'b10110110;
        #10;
        `assert(ALU_OUT[7:0], 8'b10110111, "ALU INC");
        
        
        // DEC
        ALU_OP = `ALU_DEC_8BIT;
        operandA[7:0] = 8'b10110110;
        #10;
        `assert(ALU_OUT[7:0], 8'b10110101, "ALU DEC");
        
        
        // CPL
        ALU_OP = `ALU_CPL;
        operandA[7:0] = 8'b10110110;
        #10;
        `assert(ALU_OUT[7:0], 8'b01001001, "ALU CPL");
        
        
        // NEG
        ALU_OP = `ALU_NEG;
        operandA[7:0] = 8'b10110110;
        #10;
        `assert(ALU_OUT[7:0], 8'b01001010, "ALU NEG");
        
        
        // CCF
        ALU_OP = `ALU_CCF;
        operandA[7:0] = 8'b10110110;
        flag[`FLAG_C] = 1;
        #10;
        `assert(FLAG_OUT[`FLAG_C], 0, "ALU CCF1");
        
        flag[`FLAG_C] = 0;
        #10;
        `assert(FLAG_OUT[`FLAG_C], 1, "ALU CCF2");
        
        
        // SCF
        ALU_OP = `ALU_SCF;
        operandA[7:0] = 8'b10110110;
        flag[`FLAG_C] = 1;
        #10;
        `assert(FLAG_OUT[`FLAG_C], 1, "ALU SCF1");
        
        flag[`FLAG_C] = 0;
        #10;
        `assert(FLAG_OUT[`FLAG_C], 1, "ALU SCF2");
        
        
        // DAA TODO
        
        
        // RLCA
        ALU_OP = `ALU_RLCA;
        operandA[7:0] = 8'b10110110;
        flag[`FLAG_C] = 0;
        #10;
        `assert(ALU_OUT[7:0], 8'b01101101, "ALU RLCA");
        `assert(FLAG_OUT[`FLAG_C], 1, "FLAG RLCA");
        
        
        // RLA
        ALU_OP = `ALU_RLA;
        operandA[7:0] = 8'b10110110;
        flag[`FLAG_C] = 0;
        #10;
        `assert(ALU_OUT[7:0], 8'b01101100, "ALU RLA");
        `assert(FLAG_OUT[`FLAG_C], 1, "FLAG RLA");
        
        
        // RLC
        ALU_OP = `ALU_RLC;
        operandA[7:0] = 8'b10110110;
        flag[`FLAG_C] = 0;
        #10;
        `assert(ALU_OUT[7:0], 8'b01101101, "ALU RLC");
        `assert(FLAG_OUT[`FLAG_C], 1, "FLAG RLC");
        
        
        // RL
        ALU_OP = `ALU_RL;
        operandA[7:0] = 8'b10110110;
        flag[`FLAG_C] = 0;
        #10;
        `assert(ALU_OUT[7:0], 8'b01101100, "ALU RL");
        `assert(FLAG_OUT[`FLAG_C], 1, "FLAG RL");
        
        
        // RRCA
        ALU_OP = `ALU_RRCA;
        operandA[7:0] = 8'b10110110;
        flag[`FLAG_C] = 1;
        #10;
        `assert(ALU_OUT[7:0], 8'b01011011, "ALU RRCA");
        `assert(FLAG_OUT[`FLAG_C], 0, "FLAG RRCA");
        
        
        // RRA
        ALU_OP = `ALU_RRA;
        operandA[7:0] = 8'b10110110;
        flag[`FLAG_C] = 1;
        #10;
        `assert(ALU_OUT[7:0], 8'b11011011, "ALU RRA");
        `assert(FLAG_OUT[`FLAG_C], 0, "FLAG RRA");
        
        
        // RRC
        ALU_OP = `ALU_RRC;
        operandA[7:0] = 8'b10110110;
        flag[`FLAG_C] = 1;
        #10;
        `assert(ALU_OUT[7:0], 8'b01011011, "ALU RRC");
        `assert(FLAG_OUT[`FLAG_C], 0, "FLAG RRC");
        
        
        // RR
        ALU_OP = `ALU_RR;
        operandA[7:0] = 8'b10110110;
        flag[`FLAG_C] = 1;
        #10;
        `assert(ALU_OUT[7:0], 8'b11011011, "ALU RR");
        `assert(FLAG_OUT[`FLAG_C], 0, "FLAG RR");
        
        
        // SLA
        ALU_OP = `ALU_SLA;
        operandA[7:0] = 8'b10110110;
        #10;
        `assert(ALU_OUT[7:0], 8'b01101100, "ALU SLA");
        
        
        // SLL
        ALU_OP = `ALU_SLL;
        operandA[7:0] = 8'b10110110;
        #10;
        `assert(ALU_OUT[7:0], 8'b01101101, "ALU SLL");
        
        
        // SRA
        ALU_OP = `ALU_SRA;
        operandA[7:0] = 8'b10110110;
        #10;
        `assert(ALU_OUT[7:0], 8'b11011011, "ALU SRA");
        
        
        // SRL
        ALU_OP = `ALU_SRL;
        operandA[7:0] = 8'b10110110;
        #10;
        `assert(ALU_OUT[7:0], 8'b01011011, "ALU SRL");
        
        
        // BIT
        
        ALU_OP = `ALU_LD_TEMP;
        operandA[7:0] = 8'h77;
        #10;
        
        ALU_OP = `ALU_TEST_BASE + 2;
        operandA[7:0] = 8'b10110110;
        #10;
        `assert(FLAG_OUT[`FLAG_Z], 1, "ALU BIT1");
        ALU_OP = `ALU_TEST_BASE;
        #10;
        `assert(FLAG_OUT[`FLAG_Z], 0, "ALU BIT2");
        
        ALU_OP = `ALU_TEST_IX_BASE + 2;
        operandA[7:0] = 8'b10110110;
        #10;
        `assert(FLAG_OUT[`FLAG_Z], 1, "ALU BIT3");
        ALU_OP = `ALU_TEST_IX_BASE;
        #10;
        `assert(FLAG_OUT[`FLAG_Z], 0, "ALU BIT4");
        
        ALU_OP = `ALU_TEST_HL_BASE + 2;
        operandA[7:0] = 8'b10110110;
        #10;
        `assert(FLAG_OUT[`FLAG_Z], 1, "ALU BIT5");
        ALU_OP = `ALU_TEST_HL_BASE;
        #10;
        `assert(FLAG_OUT[`FLAG_Z], 0, "ALU BIT6");
        
        
        // SET
        ALU_OP = `ALU_SET_BASE + 3;
        operandA[7:0] = 8'b00000000;
        #10;
        `assert(ALU_OUT[7:0], 8'b00001000, "ALU SET");
        
        
        // RESET
        ALU_OP = `ALU_RESET_BASE + 3;
        operandA[7:0] = 8'b11111111;
        #10;
        `assert(ALU_OUT[7:0], 8'b11110111, "ALU RESET");
    end
endmodule
