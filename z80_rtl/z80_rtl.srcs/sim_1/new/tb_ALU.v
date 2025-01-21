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
    
    ALU_Core alu_core (ALU_OP, operandA, operandB, flag, ALU_OUT, FLAG_OUT);
    
    wire [15:0] ALU_OUT_E2E;
    wire [7:0] FLAG_OUT_E2E;
    wire [7:0] ACC;
    
    reg CLK, opA_mux, ld_acc, ld_flag, flag_mux;
    reg [1:0] acc_in_mux;
    reg [15:0] dataA, dataB;
    
    ALU alu (CLK, dataA, dataB, ALU_OP, opA_mux, acc_in_mux, ld_acc, ld_flag, flag, flag_mux, ALU_OUT_E2E, FLAG_OUT_E2E, ACC);
    
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
        
        
        // ADD 16-BIT
        ALU_OP = `ALU_ADD_16BIT;
        operandA = 300;
        operandB = 567;
        #10;
        `assert(ALU_OUT, 16'h363, "ALU ADD 16BIT 1");
        
        operandA = 65535;
        operandB = 1;
        #10;
        `assert(ALU_OUT, 16'h0, "ALU ADD 16BIT 2");
        
        operandA = -10;
        operandB = 11;
        #10;
        `assert(ALU_OUT, 16'h1, "ALU ADD 16BIT 3");
        
        
        // ADC 16-BIT
        ALU_OP = `ALU_ADC_16BIT;
        operandA = 300;
        operandB = 567;
        flag[`FLAG_C] = 1;
        #10;
        `assert(ALU_OUT, 16'h364, "ALU ADC 16BIT 1");
        
        operandA = 65535;
        operandB = 0;
        flag[`FLAG_C] = 1;
        #10;
        `assert(ALU_OUT, 16'h0, "ALU ADC 16BIT 2");
        
        operandA = -10;
        operandB = 11;
        flag[`FLAG_C] = 1;
        #10;
        `assert(ALU_OUT, 16'h2, "ALU ADC 16BIT 3");
        
        
        // SBC 16-BIT
        ALU_OP = `ALU_SBC_16BIT;
        operandA = 300;
        operandB = 567;
        flag[`FLAG_C] = 1;
        #10;
        `assert(ALU_OUT, 16'hFEF4, "ALU SBC 16BIT 1");
        
        operandA = 0;
        operandB = 0;
        flag[`FLAG_C] = 1;
        #10;
        `assert(ALU_OUT, 16'hFFFF, "ALU SBC 16BIT 2");
        
        operandA = 10;
        operandB = 11;
        flag[`FLAG_C] = 1;
        #10;
        `assert(ALU_OUT, 16'hFFFE, "ALU SBC 16BIT 3");
        
        
        // INC 16-BIT
        ALU_OP = `ALU_INC_16BIT;
        operandA = 555;
        #10;
        `assert(ALU_OUT, 556, "ALU INC 16BIT 1");
        
        operandA = 65535;
        #10;
        `assert(ALU_OUT, 0, "ALU INC 16BIT 2");
        
        
        // DEC 16-BIT
        ALU_OP = `ALU_DEC_16BIT;
        operandA = 555;
        #10;
        `assert(ALU_OUT, 554, "ALU DEC 16BIT 1");
        
        operandA = 0;
        #10;
        `assert(ALU_OUT, 16'hFFFF, "ALU DEC 16BIT 2");
        
        // RLD
        ALU_OP = `ALU_RLD;
        operandA = 8'hDE;
        operandB = 8'hAD;
        #10;
        `assert(ALU_OUT, 16'hDADE, "ALU RLD");
        
        
        // RRD
        ALU_OP = `ALU_RRD;
        operandA = 8'hDE;
        operandB = 8'hAD;
        #10;
        `assert(ALU_OUT, 16'hDDEA, "ALU RRD");
        
        
        // End to end testing with DAA
        // this will execute a series of BCD operations as if they were performed by the state machine
        
        CLK = 0;
        #10;
        dataA = 0;
        dataB = 0;
        ALU_OP = 0;
        opA_mux = 0;
        acc_in_mux = 2;
        ld_acc = 1;
        ld_flag = 1;
        flag_mux = 1;
        flag = 0;
        #5;
        CLK = 1;
        #5;
        CLK = 0;
        #5;
        
        acc_in_mux = 2;
        dataA = 16'h57;
        ld_acc = 1;
        ld_flag = 0;
        #5;
        CLK = 1;
        #5;
        CLK = 0;
        #5;
        
        ALU_OP = `ALU_ADD_8BIT;
        opA_mux = 0;
        dataB = 16'h4;
        ld_acc = 1;
        acc_in_mux = 0;
        ld_flag = 1;
        flag_mux = 0;
        #5;
        CLK = 1;
        #5;
        CLK = 0;
        #5;
        
        ALU_OP = `ALU_DAA;
        opA_mux = 0;
        ld_acc = 1;
        acc_in_mux = 0;
        ld_flag = 1;
        flag_mux = 0;
        #5;
        CLK = 1;
        #5;
        CLK = 0;
        #5;
        
        `assert(ACC, 8'h61, "ALU DAA 1");
        
        ALU_OP = `ALU_SUB_8BIT;
        opA_mux = 0;
        dataB = 16'h2;
        ld_acc = 1;
        acc_in_mux = 0;
        ld_flag = 1;
        flag_mux = 0;
        #5;
        CLK = 1;
        #5;
        CLK = 0;
        #5;
        
        ALU_OP = `ALU_DAA;
        opA_mux = 0;
        ld_acc = 1;
        acc_in_mux = 0;
        ld_flag = 1;
        flag_mux = 0;
        #5;
        CLK = 1;
        #5;
        CLK = 0;
        #5;
        
        `assert(ACC, 8'h59, "ALU DAA 2");
        
        ALU_OP = `ALU_ADD_8BIT;
        opA_mux = 0;
        dataB = 16'h42;
        ld_acc = 1;
        acc_in_mux = 0;
        ld_flag = 1;
        flag_mux = 0;
        #5;
        CLK = 1;
        #5;
        CLK = 0;
        #5;
        
        ALU_OP = `ALU_DAA;
        opA_mux = 0;
        ld_acc = 1;
        acc_in_mux = 0;
        ld_flag = 1;
        flag_mux = 0;
        #5;
        CLK = 1;
        #5;
        CLK = 0;
        #5;
        
        `assert(ACC, 8'h01, "ALU DAA 3");
        
        ALU_OP = `ALU_SUB_8BIT;
        opA_mux = 0;
        dataB = 16'h35;
        ld_acc = 1;
        acc_in_mux = 0;
        ld_flag = 1;
        flag_mux = 0;
        #5;
        CLK = 1;
        #5;
        CLK = 0;
        #5;
        
        ALU_OP = `ALU_DAA;
        opA_mux = 0;
        ld_acc = 1;
        acc_in_mux = 0;
        ld_flag = 1;
        flag_mux = 0;
        #5;
        CLK = 1;
        #5;
        CLK = 0;
        #5;
        
        `assert(ACC, 8'h66, "ALU DAA 4");
    end
endmodule
