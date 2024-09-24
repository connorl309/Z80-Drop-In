`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2024 01:36:33 PM
// Design Name: 
// Module Name: ALU
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

function [15:0] extendTo16;
    input [7:0] num;
    begin
        extendTo16 = {num[7] ? 8'hFF : 8'b0, num};
    end
endfunction

// Gates to the buses should be made outside of the module
module ALU_Core(
    input [6:0] ALU_OP,
    input [15:0] operandA,
    input [15:0] operandB,
    input [7:0] flag,
    output reg [15:0] ALU_OUT,
    output reg [7:0] FLAG_OUT);
    
    localparam FLAG_S = 7;
    localparam FLAG_Z = 6;
    localparam FLAG_Y = 5;
    localparam FLAG_H = 4;
    localparam FLAG_X = 3;
    localparam FLAG_P_V = 2;
    localparam FLAG_N = 1;
    localparam FLAG_C = 0;
    
    localparam ADD_8BIT = 0; // 8-bit add
    localparam ADD_C_8BIT = 1; // 8-bit add with carry
    wire [7:0] operandB8_plus_carry = operandB[7:0] + flag[FLAG_C];
    wire [8:0] add_c_8bit_wire = operandA[7:0] + operandB[7:0] + flag[FLAG_C];
    wire [8:0] add_8bit_wire = operandA[7:0] + operandB[7:0];
    wire [4:0] add_8bit_half = operandA[3:0] + operandB[3:0];
    wire [4:0] add_c_8bit_half = operandA[3:0] + operandB[3:0] + flag[FLAG_C];
    wire add_8bit_H = add_8bit_half[4]; // carry from bit 3
    wire add_c_8bit_H = add_c_8bit_half[4]; // carry from bit 3  
    wire add_8bit_overflow = !(operandA[7] ^ operandB[7]) && (operandA[7] ^ add_8bit_wire[7]);
    wire add_c_8bit_overflow = !(operandA[7] ^ operandB8_plus_carry[7]) && (operandA[7] ^ add_c_8bit_wire[7]);
    
    localparam SUB_8BIT = 2; // 8-bit sub
    localparam SUB_C_8BIT = 3; // 8-bit sub with carry
    wire [8:0] sub_c_8bit_wire = operandA[7:0] - (operandB[7:0] + flag[FLAG_C]);
    wire [8:0] sub_8bit_wire = operandA[7:0] - operandB[7:0];
    wire sub_8bit_H = $signed(operandA[3:0]) < $signed(operandB[3:0]);
    wire sub_c_8bit_H = $signed(operandA[3:0]) < $signed(operandB8_plus_carry[3:0]);
    wire sub_8bit_overflow = (operandA[7] ^ operandB[7]) && !(operandA[7] ^ sub_8bit_wire[7]);
    wire sub_c_8bit_overflow = (operandA[7] ^ operandB8_plus_carry[7]) && !(operandA[7] ^ sub_c_8bit_wire[7]);
    
    localparam AND_8BIT = 4; // 8-bit AND 
    wire [7:0] and_wire = operandA[7:0] & operandB[7:0];
    
    localparam OR_8BIT = 5; // 8-bit OR 
    wire [7:0] or_wire = operandA[7:0] | operandB[7:0];
    
    localparam XOR_8BIT = 6; // 8-bit XOR 
    wire [7:0] xor_wire = operandA[7:0] ^ operandB[7:0];
    
    localparam CMP = 7; // 8-bit compare
    
    localparam INC_8BIT = 8; // 8-bit increment
    wire [4:0] inc_8bit_half = operandA[3:0] + 1;
    wire inc_8bit_H = inc_8bit_half[4];
    wire [8:0] inc_8bit_wire = operandA[7:0] + 1;
    
    localparam DEC_8BIT = 9; // 8-bit decrement
    wire [8:0] dec_8bit_wire = operandA[7:0] - 1;
    
    localparam BCD_NONSENSE = 10;
    wire [7:0] BCD_CASE_1 = {operandA[7:4] + 4'h0, operandA[3:0] + 4'h0};
    wire [7:0] BCD_CASE_2 = {operandA[7:4] + 4'h0, operandA[3:0] + 4'h6};
    wire [7:0] BCD_CASE_3 = {operandA[7:4] + 4'h0, operandA[3:0] + 4'h6};
    wire [7:0] BCD_CASE_4 = {operandA[7:4] + 4'h6, operandA[3:0] + 4'h0};
    wire [7:0] BCD_CASE_5 = {operandA[7:4] + 4'h6, operandA[3:0] + 4'h0};
    wire [7:0] BCD_CASE_6 = {operandA[7:4] + 4'h6, operandA[3:0] + 4'h6};
    wire [7:0] BCD_CASE_7 = {operandA[7:4] + 4'h6, operandA[3:0] + 4'h6};
    wire [7:0] BCD_CASE_8 = {operandA[7:4] + 4'h6, operandA[3:0] + 4'h6};
    wire [7:0] BCD_CASE_9 = {operandA[7:4] + 4'h6, operandA[3:0] + 4'h6};
    
    localparam ONES_8BIT = 11; // 8-bit one's complement negation
    wire [7:0] ones_8bit_wire = ~operandA[7:0];
    
    localparam TWOS_8BIT = 12; // 8-bit two's complement negation
    wire [7:0] twos_8bit_wire = -operandA[7:0];
    
    localparam INV_C = 13; // Invert carry flag
    localparam SET_C = 14; // Set carry flag
    localparam ADD_16BIT = 15; // 16-bit add 
    localparam ADD_C_16BIT = 16; // 16-bit add with carry
    wire [15:0] operandB16_plus_carry = operandB[15:0] + flag[FLAG_C]; 
    wire [16:0] add_c_16bit_wire = operandA[15:0] + operandB[15:0] + flag[FLAG_C];
    wire [16:0] add_16bit_wire = operandA[15:0] + operandB[15:0];
    wire [12:0] add_16bit_half = operandA[11:0] + operandB[11:0];
    wire [12:0] add_c_16bit_half = operandA[11:0] + operandB[11:0] + flag[FLAG_C];
    wire add_16bit_H = add_16bit_half[12];
    wire add_c_16bit_H = add_c_16bit_half[12];
    wire add_c_16bit_overflow = !(operandA[15] ^ operandB16_plus_carry[15]) && (operandA[15] ^ add_c_16bit_wire[15]);
    
    localparam SUB_C_16BIT = 17; // 16-bit sub with carry
    wire [16:0] sub_c_16bit_wire = operandA[15:0] - operandB16_plus_carry[15:0];
    wire sub_c_16bit_H = $signed(operandA[11:0]) < $signed(operandB16_plus_carry[11:0]);
    wire sub_c_16bit_overflow = (operandA[15] ^ operandB16_plus_carry[15]) && !(operandA[15] ^ sub_c_16bit_wire[15]);
    
    localparam INC_16BIT = 18; // 16-bit increment
    wire [15:0] inc_16bit_wire = operandA[15:0] + 1;
    
    localparam DEC_16BIT = 19; // 16-bit decrement
    wire [15:0] dec_16bit_wire = operandA[15:0] - 1;
    
    localparam ROTATE_LEFT = 20; //  8-bit rotate left
    localparam ROTATE_C_LEFT = 21; // 8-bit rotate left through carry 
    localparam ROTATE_LEFT_R = 22; // 8-bit rotate left, different flag updates
    localparam ROTATE_LEFT_R_C = 23; // 8-bit rotate left through carry, different flag updates
    wire [7:0] rotate_c_left_wire = {operandA[6:0], flag[FLAG_C]};
    wire [7:0] rotate_left_wire = {operandA[6:0], operandA[7]};
    
    localparam ROTATE_RIGHT = 24; // 8-bit rotate right
    localparam ROTATE_C_RIGHT = 25; // 8-bit rotate right through carry
    localparam ROTATE_RIGHT_R = 26; // 8-bit rotate right, different flag updates
    localparam ROTATE_RIGHT_R_C = 27; // 8-bit rotate right through carry, different flag updates
    wire [7:0] rotate_c_right_wire = {flag[FLAG_C], operandA[7:1]};
    wire [7:0] rotate_right_wire = {operandB[0], operandA[7:1]};
    
    localparam SHIFT_A_LEFT = 28; // 8-bit arithmetic shift left
    wire [7:0] shift_left_wire = {operandA[6:0], 1'b0};
    
    localparam SHIFT_A_RIGHT = 29; // 8-bit arithmetic shift right
    wire [7:0] arithmetic_shift_right_wire = {operandA[7], operandA[7:1]};
    
    localparam SHIFT_L_RIGHT = 30; // 8-bit logical shift right
    wire [7:0] logical_shift_right_wire = {1'b0, operandA[7:1]};
    
    localparam WEIRD_ROTATE_LEFT = 31; // weird ahhh left rotate through memory location and A (RLD opcode)
    localparam WEIRD_ROTATE_RIGHT = 32; // weird ahhh right rotate through memory location and A (RRD opcode)
    
    // these are always on an 8-bit value
    localparam TEST_BASE = 33;
    wire [7:0] TEST_wire = (operandA[7:0] & (1'b1 << (ALU_OP - TEST_BASE)));
    localparam SET_BASE = TEST_BASE + 8; 
    wire [7:0] set_wire = operandA[7:0] | (ALU_OP - SET_BASE);
    localparam RESET_BASE = SET_BASE + 8; 
    wire [7:0] reset_wire = operandA[7:0] & ~(8'b0 + (1'b1 << (ALU_OP - RESET_BASE)));
    
    always @(*) begin
        FLAG_OUT[FLAG_Y] <= 0;
        FLAG_OUT[FLAG_X] <= 0;
        case (ALU_OP)
            ADD_8BIT: begin
                ALU_OUT <= extendTo16(add_8bit_wire[7:0]);
                FLAG_OUT[FLAG_S] <= add_8bit_wire[7];
                FLAG_OUT[FLAG_Z] <= add_8bit_wire == 0;
                // FLAG_OUT[FLAG_Y] <= add_8bit_wire[5];
                FLAG_OUT[FLAG_H] <= add_8bit_H; 
                // FLAG_OUT[FLAG_X] <= add_8bit_wire[3];
                FLAG_OUT[FLAG_P_V] <= add_8bit_overflow; 
                FLAG_OUT[FLAG_N] <= 1'b0;
                FLAG_OUT[FLAG_C] <= add_8bit_wire[8]; 
            end
            ADD_C_8BIT: begin
                ALU_OUT <= extendTo16(add_c_8bit_wire[7:0]);
                FLAG_OUT[FLAG_S] <= add_c_8bit_wire[7];
                FLAG_OUT[FLAG_Z] <= add_c_8bit_wire == 0;
                // FLAG_OUT[FLAG_Y] <= add_c_8bit_wire[5];
                FLAG_OUT[FLAG_H] <= add_c_8bit_H;
                // FLAG_OUT[FLAG_X] <= add_c_8bit_wire[3];
                FLAG_OUT[FLAG_P_V] <= add_c_8bit_overflow; 
                FLAG_OUT[FLAG_N] <= 1'b0;
                FLAG_OUT[FLAG_C] <= add_c_8bit_wire[8]; 
            end
            SUB_8BIT: begin
                ALU_OUT <= extendTo16(sub_8bit_wire[7:0]);
                FLAG_OUT[FLAG_S] <= sub_8bit_wire[7];
                FLAG_OUT[FLAG_Z] <= sub_8bit_wire == 0;
                // FLAG_OUT[FLAG_Y] <= sub_8bit_wire[5];
                FLAG_OUT[FLAG_H] <= sub_8bit_H;
                // FLAG_OUT[FLAG_X] <= sub_8bit_wire[3];
                FLAG_OUT[FLAG_P_V] <= sub_8bit_overflow;
                FLAG_OUT[FLAG_N] <= 1'b1;
                FLAG_OUT[FLAG_C] <= $signed(operandA[7:0]) < $signed(operandB[7:0]);
            end
            SUB_C_8BIT: begin
                ALU_OUT <= extendTo16(sub_c_8bit_wire[7:0]);
                FLAG_OUT[FLAG_S] <= sub_c_8bit_wire[7];
                FLAG_OUT[FLAG_Z] <= sub_c_8bit_wire == 0;
                // FLAG_OUT[FLAG_Y] <= sub_c_8bit_wire[5];
                FLAG_OUT[FLAG_H] <= sub_c_8bit_H;
                // FLAG_OUT[FLAG_X] <= sub_c_8bit_wire[3];
                FLAG_OUT[FLAG_P_V] <= sub_c_8bit_overflow;
                FLAG_OUT[FLAG_N] <= 1'b1;
                FLAG_OUT[FLAG_C] <= $signed(operandA[7:0]) < $signed(operandB[7:0]);
            end
            AND_8BIT: begin
                ALU_OUT <= {8'b0, and_wire};
                FLAG_OUT[FLAG_S] <= and_wire[7];
                FLAG_OUT[FLAG_Z] <= and_wire == 0;
                // FLAG_OUT[FLAG_Y] <= and_wire[5];
                FLAG_OUT[FLAG_H] <= 1;
                // FLAG_OUT[FLAG_X] <= and_wire[3];
                FLAG_OUT[FLAG_P_V] <= !(^and_wire); // even parity according to P/V subsection
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= 0;
            end
            OR_8BIT: begin
                ALU_OUT <= {8'b0, or_wire};
                FLAG_OUT[FLAG_S] <= or_wire[7];
                FLAG_OUT[FLAG_Z] <= or_wire == 0;
                // FLAG_OUT[FLAG_Y] <= or_wire[5];
                FLAG_OUT[FLAG_H] <= 0;
                // FLAG_OUT[FLAG_X] <= or_wire[3];
                FLAG_OUT[FLAG_P_V] <= !(^or_wire);
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= 0;
            end
            XOR_8BIT: begin
                ALU_OUT <= {8'b0, xor_wire};
                FLAG_OUT[FLAG_S] <= xor_wire[7];
                FLAG_OUT[FLAG_Z] <= xor_wire == 0;
                // FLAG_OUT[FLAG_Y] <= xor_wire[5];
                FLAG_OUT[FLAG_H] <= 0;
                // FLAG_OUT[FLAG_X] <= xor_wire[3];
                FLAG_OUT[FLAG_P_V] <= !(^xor_wire); // even parity
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= 0;
            end
            CMP: begin
                ALU_OUT <= {8'b0, operandB}; // see undocumented 8.4
                FLAG_OUT[FLAG_S] <= sub_8bit_wire[7];
                FLAG_OUT[FLAG_Z] <= sub_8bit_wire == 0;
                // FLAG_OUT[FLAG_Y] <= 0;
                FLAG_OUT[FLAG_H] <= sub_8bit_H;
                // FLAG_OUT[FLAG_X] <= 0;
                FLAG_OUT[FLAG_P_V] <= sub_8bit_overflow;
                FLAG_OUT[FLAG_N] <= 1;
                FLAG_OUT[FLAG_C] <= $signed(operandA[7:0]) < $signed(operandB[7:0]);
            end
            INC_8BIT: begin
                ALU_OUT <= extendTo16(inc_8bit_wire);
                FLAG_OUT[FLAG_S] <= inc_8bit_wire[7];
                FLAG_OUT[FLAG_Z] <= inc_8bit_wire == 0;
                // FLAG_OUT[FLAG_Y] <= inc_8bit_wire[5];
                FLAG_OUT[FLAG_H] <= inc_8bit_H;
                // FLAG_OUT[FLAG_X] <= inc_8bit_wire[3];
                FLAG_OUT[FLAG_P_V] <= operandA[7:0] == 8'h7F;
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= flag[FLAG_C];
            end
            DEC_8BIT: begin
                ALU_OUT <= extendTo16(dec_8bit_wire);
                FLAG_OUT[FLAG_S] <= dec_8bit_wire[7];
                FLAG_OUT[FLAG_Z] <= dec_8bit_wire == 0;
                // FLAG_OUT[FLAG_Y] <= dec_8bit_wire[5];
                FLAG_OUT[FLAG_H] <= operandB[3:0] == 0;
                // FLAG_OUT[FLAG_X] <= dec_8bit_wire[3];
                FLAG_OUT[FLAG_P_V] <= operandA[7:0] == 8'h80;
                FLAG_OUT[FLAG_N] <= 1;
                FLAG_OUT[FLAG_C] <= flag[FLAG_C];
            end
            BCD_NONSENSE: begin
                // page 18 of https://datasheets.chipdb.org/Zilog/Z80/z80-documented-0.90.pdf 
                
                // Adjusted value
                if (flag[FLAG_C] == 0 && operandA[7:4] <= 4'h9 && flag[FLAG_H] == 0 && operandA[3:0] <= 4'h9) begin
                    ALU_OUT <= {8'b0, BCD_CASE_1};
                    FLAG_OUT[FLAG_S] <= operandA[7];
                    FLAG_OUT[FLAG_Z] <= operandA[7:0] == 0;
                    FLAG_OUT[FLAG_P_V] <= !(^operandA[7:0]);
                end else if (flag[FLAG_C] == 0 && operandA[7:4] <= 4'h9 && flag[FLAG_H] == 1 && operandA[3:0] <= 4'h9) begin
                    ALU_OUT <= {8'b0, BCD_CASE_2};
                    FLAG_OUT[FLAG_S] <= operandA[7];
                    FLAG_OUT[FLAG_Z] <= BCD_CASE_2 == 0;
                    FLAG_OUT[FLAG_P_V] <= !(^BCD_CASE_2);
                end else if (flag[FLAG_C] == 0 && operandA[7:4] <= 4'h8 && operandA[3:0] >= 4'hA) begin
                    ALU_OUT <= {8'b0, BCD_CASE_3};
                    FLAG_OUT[FLAG_S] <= operandA[7];
                    FLAG_OUT[FLAG_Z] <= BCD_CASE_3 == 0;
                    FLAG_OUT[FLAG_P_V] <= !(^BCD_CASE_3);
                end else if (flag[FLAG_C] == 0 && operandA[7:4] >= 4'hA && flag[FLAG_H] == 0 && operandA[3:0] <= 4'h9) begin
                    ALU_OUT <= {8'b0, BCD_CASE_4};
                    FLAG_OUT[FLAG_S] <= BCD_CASE_4[7];
                    FLAG_OUT[FLAG_Z] <= BCD_CASE_4 == 0;
                    FLAG_OUT[FLAG_P_V] <= !(^BCD_CASE_4);
                end else if (flag[FLAG_C] == 1 && flag[FLAG_H] == 0 && operandA[3:0] <= 4'h9) begin
                    ALU_OUT <= {8'b0, BCD_CASE_5};
                    FLAG_OUT[FLAG_S] <= BCD_CASE_5[7];
                    FLAG_OUT[FLAG_Z] <= BCD_CASE_5 == 0;
                    FLAG_OUT[FLAG_P_V] <= !(^BCD_CASE_5);
                end else if (flag[FLAG_C] == 1 && flag[FLAG_H] == 1 && operandA[3:0] <= 4'h9) begin
                    ALU_OUT <= {8'b0, BCD_CASE_6};
                    FLAG_OUT[FLAG_S] <= BCD_CASE_6[7];
                    FLAG_OUT[FLAG_Z] <= BCD_CASE_6 == 0;
                    FLAG_OUT[FLAG_P_V] <= !(^BCD_CASE_6);
                end else if (flag[FLAG_C] == 1 && operandA[3:0] >= 4'hA) begin
                    ALU_OUT <= {8'b0, BCD_CASE_7};
                    FLAG_OUT[FLAG_S] <= BCD_CASE_7[7];
                    FLAG_OUT[FLAG_Z] <= BCD_CASE_7 == 0;
                    FLAG_OUT[FLAG_P_V] <= !(^BCD_CASE_7);
                end else if (flag[FLAG_C] == 0 && operandA[7:4] >= 4'h9 && operandA[3:0] >= 4'hA) begin
                    ALU_OUT <= {8'b0, BCD_CASE_8};
                    FLAG_OUT[FLAG_S] <= BCD_CASE_8[7];
                    FLAG_OUT[FLAG_Z] <= BCD_CASE_8 == 0;
                    FLAG_OUT[FLAG_P_V] <= !(^BCD_CASE_8);
                end else if (flag[FLAG_C] == 0 && operandA[7:4] >= 4'hA && flag[FLAG_H] == 1 && operandA[3:0] <= 4'h9) begin
                    ALU_OUT <= {8'b0, BCD_CASE_9};
                    FLAG_OUT[FLAG_S] <= BCD_CASE_9[7];
                    FLAG_OUT[FLAG_Z] <= BCD_CASE_9 == 0;
                    FLAG_OUT[FLAG_P_V] <= !(^BCD_CASE_9);
                end else begin
                    ALU_OUT <= {8'b0, operandA[7:0]};
                    FLAG_OUT[FLAG_S] <= operandA[7];
                    FLAG_OUT[FLAG_Z] <= operandA[7:0] == 0;
                    FLAG_OUT[FLAG_P_V] <= !(^operandA[7:0]);
                end
                
                // Carry Flag
                if (flag[FLAG_C] == 0 && operandA[7:4] <= 4'h9 && operandA[3:0] <= 4'h9)
                    FLAG_OUT[FLAG_C] <= 0;
                else if (flag[FLAG_C] == 0 && operandA[7:4] <= 4'h8 && operandA[3:0] >= 4'hA)
                    FLAG_OUT[FLAG_C] <= 0;
                else if (flag[FLAG_C] == 0 && operandA[7:4] >= 4'h9 && operandA[3:0] >= 4'hA)
                    FLAG_OUT[FLAG_C] <= 1;
                else if (flag[FLAG_C] == 0 && operandA[7:4] >= 4'hA && operandA[3:0] <= 4'h9)
                    FLAG_OUT[FLAG_C] <= 1;
                else if (flag[FLAG_C] == 1)
                    FLAG_OUT[FLAG_C] <= 1;
                else
                    FLAG_OUT[FLAG_C] <= flag[FLAG_C];
                
                // Half Carry Flag
                if (flag[FLAG_N] == 0 && operandA[3:0] <= 4'h9)
                    FLAG_OUT[FLAG_H] <= 0;
                else if (flag[FLAG_N] == 0 && operandA[3:0] >= 4'hA)
                    FLAG_OUT[FLAG_H] <= 1;
                else if (flag[FLAG_N] == 1 && flag[FLAG_H] == 0)
                    FLAG_OUT[FLAG_H] <= 0;
                else if (flag[FLAG_N] == 1 && flag[FLAG_H] == 1 && operandA[3:0] >= 4'h6)
                    FLAG_OUT[FLAG_H] <= 0;
                else if (flag[FLAG_N] == 1 && flag[FLAG_H] == 1 && operandA[3:0] <= 4'h5)
                    FLAG_OUT[FLAG_H] <= 1;
                else
                    FLAG_OUT[FLAG_H] <= flag[FLAG_H];
                    
                // other flags
                FLAG_OUT[FLAG_N] <= flag[FLAG_N];
                
            end
            ONES_8BIT: begin
                ALU_OUT <= extendTo16(ones_8bit_wire);
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                // FLAG_OUT[FLAG_Y] <= ones_8bit_wire[5];
                FLAG_OUT[FLAG_H] <= 1;
                // FLAG_OUT[FLAG_X] <= ones_8bit_wire[3];
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= 1;
                FLAG_OUT[FLAG_C] <= flag[FLAG_C];
            end
            TWOS_8BIT: begin
                ALU_OUT <= extendTo16(twos_8bit_wire);
                FLAG_OUT[FLAG_S] <= twos_8bit_wire[7];
                FLAG_OUT[FLAG_Z] <= twos_8bit_wire == 0;
                // FLAG_OUT[FLAG_Y] <= twos_8bit_wire[5];
                FLAG_OUT[FLAG_H] <= 0 < $signed(operandA[3:0]); // allegedly
                // FLAG_OUT[FLAG_X] <= twos_8bit_wire[3];
                FLAG_OUT[FLAG_P_V] <= operandA[7:0] == 8'h80;
                FLAG_OUT[FLAG_N] <= 1;
                FLAG_OUT[FLAG_C] <= operandA[7:0] == 8'h00;
            end
            INV_C: begin
                ALU_OUT <= {8'b0, operandA}; // The A register must be exposed to operandA for this instruction
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                // FLAG_OUT[FLAG_Y] <= 0;
                FLAG_OUT[FLAG_H] <= flag[FLAG_H];
                // FLAG_OUT[FLAG_X] <= 0;
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= !flag[FLAG_C];
            end
            SET_C: begin
                ALU_OUT <= {8'b0, operandA}; // The A register must be exposed to operandA for this instruction
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                // FLAG_OUT[FLAG_Y] <= 0;
                FLAG_OUT[FLAG_H] <= 0;
                // FLAG_OUT[FLAG_X] <= 0;
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= 1;
            end
            ADD_16BIT: begin
                ALU_OUT <= add_16bit_wire[15:0]; // TODO Y and X should pull from the high byte of this
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                // FLAG_OUT[FLAG_Y] <= add_16bit_wire[5];
                FLAG_OUT[FLAG_H] <= add_16bit_H;
                // FLAG_OUT[FLAG_X] <= add_16bit_wire[3];
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= add_16bit_wire[15]; 
            end
            ADD_C_16BIT: begin
                ALU_OUT <= add_c_16bit_wire[15:0];
                FLAG_OUT[FLAG_S] <= add_c_16bit_wire[15];
                FLAG_OUT[FLAG_Z] <= add_c_16bit_wire == 0;
                // FLAG_OUT[FLAG_Y] <= add_c_16bit_wire[5];
                FLAG_OUT[FLAG_H] <= add_c_16bit_H; 
                // FLAG_OUT[FLAG_X] <= add_c_16bit_wire[3];
                FLAG_OUT[FLAG_P_V] <= add_c_16bit_overflow;
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= add_c_16bit_wire[16];
            end
            SUB_C_16BIT: begin
                ALU_OUT <= sub_c_16bit_wire[15:0];
                FLAG_OUT[FLAG_S] <= sub_c_16bit_wire[15];
                FLAG_OUT[FLAG_Z] <= sub_c_16bit_wire == 0;
                // FLAG_OUT[FLAG_Y] <= sub_c_16bit_wire[5];
                FLAG_OUT[FLAG_H] <= sub_c_16bit_H;
                // FLAG_OUT[FLAG_X] <= sub_c_16bit_wire[3];
                FLAG_OUT[FLAG_P_V] <= sub_c_16bit_overflow;
                FLAG_OUT[FLAG_N] <= 1;
                FLAG_OUT[FLAG_C] <= $signed(operandA[15:0]) < $signed(operandB16_plus_carry[15:0]);
            end
            INC_16BIT: begin
                ALU_OUT <= inc_16bit_wire[15:0];
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                // FLAG_OUT[FLAG_Y] <= inc_16bit_wire[5];
                FLAG_OUT[FLAG_H] <= flag[FLAG_H];
                // FLAG_OUT[FLAG_X] <= inc_16bit_wire[3];
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= flag[FLAG_N];
                FLAG_OUT[FLAG_C] <= flag[FLAG_C];
            end
            DEC_16BIT: begin
                ALU_OUT <= dec_16bit_wire[15:0];
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                // FLAG_OUT[FLAG_Y] <= dec_16bit_wire[5];
                FLAG_OUT[FLAG_H] <= flag[FLAG_H];
                // FLAG_OUT[FLAG_X] <= dec_16bit_wire[3];
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= flag[FLAG_N];
                FLAG_OUT[FLAG_C] <= flag[FLAG_C];
            end
            ROTATE_LEFT: begin
                ALU_OUT <= {8'b0, rotate_left_wire};
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                // FLAG_OUT[FLAG_Y] <= rotate_left_wire[5];
                FLAG_OUT[FLAG_H] <= 0; 
                // FLAG_OUT[FLAG_X] <= rotate_left_wire[3];
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operandA[7];
            end
            ROTATE_C_LEFT: begin
                ALU_OUT <= {8'b0, rotate_c_left_wire};
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                // FLAG_OUT[FLAG_Y] <= rotate_c_left_wire[5];
                FLAG_OUT[FLAG_H] <= 0; 
                // FLAG_OUT[FLAG_X] <= rotate_c_left_wire[3];
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operandA[7];
            end
            ROTATE_LEFT_R: begin
                ALU_OUT <= {8'b0, rotate_left_wire};
                FLAG_OUT[FLAG_S] <= rotate_left_wire[7];
                FLAG_OUT[FLAG_Z] <= rotate_left_wire == 0;
                // FLAG_OUT[FLAG_Y] <= rotate_left_wire[5];
                FLAG_OUT[FLAG_H] <= 0;
                // FLAG_OUT[FLAG_X] <= rotate_left_wire[3];
                FLAG_OUT[FLAG_P_V] <= !(^rotate_left_wire);
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operandA[7];
            end
            ROTATE_LEFT_R_C: begin
                ALU_OUT <= {8'b0, rotate_c_left_wire};
                FLAG_OUT[FLAG_S] <= rotate_c_left_wire[7];
                FLAG_OUT[FLAG_Z] <= rotate_c_left_wire == 0;
                // FLAG_OUT[FLAG_Y] <= rotate_c_left_wire[5];
                FLAG_OUT[FLAG_H] <= 0;
                // FLAG_OUT[FLAG_X] <= rotate_c_left_wire[3];
                FLAG_OUT[FLAG_P_V] <= !(^rotate_c_left_wire);
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operandA[7];
            end
            ROTATE_RIGHT: begin
                ALU_OUT <= {8'b0, rotate_right_wire};
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                // FLAG_OUT[FLAG_Y] <= rotate_right_wire[5];
                FLAG_OUT[FLAG_H] <= 0;
                // FLAG_OUT[FLAG_X] <= rotate_right_wire[3];
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operandA[0];
            end
            ROTATE_C_RIGHT: begin
                ALU_OUT <= {8'b0, rotate_c_right_wire};
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                // FLAG_OUT[FLAG_Y] <= rotate_c_right_wire[5];
                FLAG_OUT[FLAG_H] <= 0; 
                // FLAG_OUT[FLAG_X] <= rotate_c_right_wire[3];
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operandA[0];
            end
            ROTATE_RIGHT_R: begin
                ALU_OUT <= {8'b0, rotate_right_wire};
                FLAG_OUT[FLAG_S] <= rotate_right_wire[7];
                FLAG_OUT[FLAG_Z] <= rotate_right_wire == 0;
                // FLAG_OUT[FLAG_Y] <= rotate_right_wire[5];
                FLAG_OUT[FLAG_H] <= 0;
                // FLAG_OUT[FLAG_X] <= rotate_right_wire[3];
                FLAG_OUT[FLAG_P_V] <= !(^rotate_right_wire);
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operandA[0];
            end
            ROTATE_RIGHT_R_C: begin
                ALU_OUT <= {8'b0, rotate_c_right_wire};
                FLAG_OUT[FLAG_S] <= rotate_c_right_wire[7];
                FLAG_OUT[FLAG_Z] <= rotate_c_right_wire == 0;
                // FLAG_OUT[FLAG_Y] <= rotate_c_right_wire[5];
                FLAG_OUT[FLAG_H] <= 0;
                // FLAG_OUT[FLAG_X] <= rotate_c_right_wire[3];
                FLAG_OUT[FLAG_P_V] <= !(^rotate_c_right_wire);
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operandA[0];
            end
            SHIFT_A_LEFT: begin
                ALU_OUT <= extendTo16(shift_left_wire);
                FLAG_OUT[FLAG_S] <= shift_left_wire[7];
                FLAG_OUT[FLAG_Z] <= shift_left_wire == 0;
                // FLAG_OUT[FLAG_Y] <= shift_left_wire[5];
                FLAG_OUT[FLAG_H] <= 0;
                // FLAG_OUT[FLAG_X] <= shift_left_wire[3];
                FLAG_OUT[FLAG_P_V] <= !(^shift_left_wire);
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operandA[7];
            end
            SHIFT_A_RIGHT: begin
                ALU_OUT <= extendTo16(arithmetic_shift_right_wire);
                FLAG_OUT[FLAG_S] <= arithmetic_shift_right_wire[7];
                FLAG_OUT[FLAG_Z] <= arithmetic_shift_right_wire == 0;
                // FLAG_OUT[FLAG_Y] <= arithmetic_shift_right_wire[5];
                FLAG_OUT[FLAG_H] <= 0;
                // FLAG_OUT[FLAG_X] <= arithmetic_shift_right_wire[3];
                FLAG_OUT[FLAG_P_V] <= !(^arithmetic_shift_right_wire);
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operandA[0];
            end
            SHIFT_L_RIGHT: begin
                ALU_OUT <= extendTo16(logical_shift_right_wire);
                FLAG_OUT[FLAG_S] <= 0;
                FLAG_OUT[FLAG_Z] <= logical_shift_right_wire == 0;
                // FLAG_OUT[FLAG_Y] <= logical_shift_right_wire[5];
                FLAG_OUT[FLAG_H] <= 0;
                // FLAG_OUT[FLAG_X] <= logical_shift_right_wire[3];
                FLAG_OUT[FLAG_P_V] <= !(^logical_shift_right_wire);
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operandA[0];
            end
            // these reotates output what goes to the accumulator to the high order byte and what goes back to memory to the low order byte
            WEIRD_ROTATE_LEFT: begin
                ALU_OUT[15:12] <= operandA[7:4];
                ALU_OUT[11:8] <= operandB[7:4];
                ALU_OUT[7:4] <= operandB[3:0];
                ALU_OUT[3:0] <= operandA[3:0];
                
                FLAG_OUT[FLAG_S] <= operandA[7];
                FLAG_OUT[FLAG_Z] <= {operandA[7:4], operandB[7:4]} == 0;
                FLAG_OUT[FLAG_H] <= 0;
                FLAG_OUT[FLAG_P_V] <= !(^{operandA[7:4], operandB[7:4]});
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= flag[FLAG_C];
            end
            WEIRD_ROTATE_RIGHT: begin
                ALU_OUT[15:12] <= operandA[7:4];
                ALU_OUT[11:8] <= operandB[3:0];
                ALU_OUT[7:4] <= operandA[3:0];
                ALU_OUT[3:0] <= operandB[7:4];
                
                FLAG_OUT[FLAG_S] <= operandA[7];
                FLAG_OUT[FLAG_Z] <= {operandA[7:4], operandB[3:0]} == 0;
                FLAG_OUT[FLAG_H] <= 0;
                FLAG_OUT[FLAG_P_V] <= !(^{operandA[7:4], operandB[3:0]});
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= flag[FLAG_C];
            end
            TEST_BASE, 
            TEST_BASE + 1,
            TEST_BASE + 2,
            TEST_BASE + 3,
            TEST_BASE + 4,
            TEST_BASE + 5,
            TEST_BASE + 6,
            TEST_BASE + 7: begin
                ALU_OUT <= {8'b0, TEST_wire};
                FLAG_OUT[FLAG_S] <= ALU_OP == TEST_BASE + 7 && operandA[7] == 1; // see undocumented
                FLAG_OUT[FLAG_Z] <= TEST_wire == 0;
                // FLAG_OUT[FLAG_Y] <= 0;
                FLAG_OUT[FLAG_H] <= 1;
                // FLAG_OUT[FLAG_X] <= 0;
                FLAG_OUT[FLAG_P_V] <= TEST_wire == 0;
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= flag[FLAG_C];
            end
            SET_BASE,
            SET_BASE + 1,
            SET_BASE + 2,
            SET_BASE + 3,
            SET_BASE + 4,
            SET_BASE + 5,
            SET_BASE + 6,
            SET_BASE + 7: begin
                ALU_OUT <= {8'b0, set_wire};
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                // FLAG_OUT[FLAG_Y] <= set_wire[5];
                FLAG_OUT[FLAG_H] <= flag[FLAG_H];
                // FLAG_OUT[FLAG_X] <= set_wire[3];
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= flag[FLAG_N];
                FLAG_OUT[FLAG_C] <= flag[FLAG_C];
            end
            RESET_BASE,
            RESET_BASE + 1,
            RESET_BASE + 2,
            RESET_BASE + 3,
            RESET_BASE + 4,
            RESET_BASE + 5,
            RESET_BASE + 6,
            RESET_BASE + 7: begin
                ALU_OUT <= {8'b0, reset_wire};
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                // FLAG_OUT[FLAG_Y] <= reset_wire[5];
                FLAG_OUT[FLAG_H] <= flag[FLAG_H]; 
                // FLAG_OUT[FLAG_X] <= reset_wire[3];
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= flag[FLAG_N];
                FLAG_OUT[FLAG_C] <= flag[FLAG_C];
            end
            default: begin
                ALU_OUT <= 16'b0; // allegedly later assignments win so the later bit test/set/reset ifs should work
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                // FLAG_OUT[FLAG_Y] <= 0;
                FLAG_OUT[FLAG_H] <= flag[FLAG_H]; 
                // FLAG_OUT[FLAG_X] <= 0;
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= flag[FLAG_N];
                FLAG_OUT[FLAG_C] <= flag[FLAG_C];
            end         
        endcase
    end  
endmodule

module ALU(
    input CLK,
    input [15:0] INT_DATA_BUS_A,
    input [15:0] INT_DATA_BUS_B,
    input [6:0] ALU_OP,
    input ALU_OPA_MUX,
    input [1:0] ACC_IN_MUX,
    input LD_ACCUM,
    input LD_FLAG,
    input [7:0] FLAG_IN,
    input FLAG_MUX,
    input ACTIVE_REGS,
    output [15:0] ALU_OUT,
    output [7:0] FLAG_OUT,
    output [7:0] ACC_OUT
    );

    wire [7:0] alu_flag_out;
    wire [15:0] ALU_OUT_int;
    assign ALU_OUT = ALU_OUT_int;

    // F Register
    reg [7:0] flag, flag_prime;
    wire [7:0] flag_mux = FLAG_MUX ? FLAG_IN : alu_flag_out;
    wire [7:0] FLAG_OUT_int = ACTIVE_REGS ? flag_prime : flag;
    always @(posedge CLK) begin
        if (LD_FLAG) begin
            if (ACTIVE_REGS)
                flag <= alu_flag_out;
            else
                flag_prime <= alu_flag_out;
        end
    end
    
    // A Register
    reg [7:0] acc, acc_prime;
    wire [7:0] ACC_OUT_int = ACTIVE_REGS ? acc_prime : acc;
    assign ACC_OUT = ACC_OUT_int;
    wire [7:0] acc_in_mux_out = ACC_IN_MUX == 0 ? ALU_OUT_int[7:0] : (ACC_IN_MUX == 1 ? ALU_OUT_int[15:8] : (ACC_IN_MUX == 2 ? INT_DATA_BUS_A[7:0] : INT_DATA_BUS_B[7:0]));
    always @(posedge CLK) begin
        if (LD_ACCUM) begin
            if (ACTIVE_REGS)
                acc <= acc_in_mux_out;
            else
                acc_prime <= acc_in_mux_out;
        end
    end
    
    // ALU operand muxes
    wire [15:0] operandA = ALU_OPA_MUX == 0 ? extendTo16(ACC_OUT_int) : INT_DATA_BUS_A[15:0];
    wire [15:0] operandB = INT_DATA_BUS_B[15:0];
    
    // ALU Core
    ALU_Core core(.ALU_OP(ALU_OP), .operandA(operandA), .operandB(operandB), .flag(FLAG_OUT_int), .ALU_OUT(ALU_OUT_int), .FLAG_OUT(alu_flag_out));
    
    wire [7:0] alu_flag_out_fixed = {alu_flag_out[7:6], ALU_OUT_int[5], alu_flag_out[4], ALU_OUT_int[3], alu_flag_out[2:0]};
    assign FLAG_OUT = alu_flag_out_fixed;
    
endmodule
