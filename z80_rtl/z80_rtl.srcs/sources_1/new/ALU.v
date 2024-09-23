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
    localparam FLAG_X2 = 5;
    localparam FLAG_H = 4;
    localparam FLAG_X1 = 3;
    localparam FLAG_P_V = 2;
    localparam FLAG_N = 1;
    localparam FLAG_C = 0;
    
    localparam ADD_8BIT = 0; // 8-bit add
    localparam ADD_C_8BIT = 1; // 8-bit add with carry
    wire [8:0] add_c_8bit_wire = operandA[7:0] + operandB[7:0] + flag[FLAG_C];
    wire [8:0] add_8bit_wire = operandA[7:0] + operandB[7:0];
    
    localparam SUB_8BIT = 2; // 8-bit sub
    localparam SUB_C_8BIT = 3; // 8-bit sub with carry
    wire [8:0] sub_c_8bit_wire = operandA[7:0] - operandB[7:0] - flag[FLAG_C];
    wire [8:0] sub_8bit_wire = operandA[7:0] - operandB[7:0];
    
    localparam AND_8BIT = 4; // 8-bit AND 
    wire [7:0] and_wire = operandA[7:0] & operandB[7:0];
    
    localparam OR_8BIT = 5; // 8-bit OR 
    wire [7:0] or_wire = operandA[7:0] | operandB[7:0];
    
    localparam XOR_8BIT = 6; // 8-bit XOR 
    wire [7:0] xor_wire = operandA[7:0] ^ operandB[7:0];
    
    localparam CMP = 7; // 8-bit compare
    localparam INC_8BIT = 8; // 8-bit increment
    wire [8:0] inc_8bit_wire = operandB[7:0] + 1;
    
    localparam DEC_8BIT = 9; // 8-bit decrement
    wire [8:0] dec_8bit_wire = operandB[7:0] - 1;
    
    localparam ONES_8BIT = 10; // 8-bit one's complement negation
    wire [7:0] ones_8bit_wire = ~operandB[7:0];
    
    localparam TWOS_8BIT = 11; // 8-bit two's complement negation
    wire [7:0] twos_8bit_wire = -operandB[7:0];
    
    localparam INV_C = 12; // Invert carry flag
    localparam SET_C = 13; // Set carry flag
    localparam ADD_16BIT = 14; // 16-bit add 
    localparam ADD_C_16BIT = 15; // 16-bit add with carry 
    wire [16:0] add_c_16bit_wire = operandA[15:0] + operandB[15:0] + flag[FLAG_C];
    wire [16:0] add_16bit_wire = operandA[15:0] + operandB[15:0];
    
    localparam SUB_C_16BIT = 16; // 16-bit sub with carry
    wire [16:0] sub_c_16bit_wire = operandA[15:0] - operandB[15:0] - flag[FLAG_C];
    
    localparam INC_16BIT = 17; // 16-bit increment
    wire [15:0] inc_16bit_wire = operandB[15:0] + 1;
    
    localparam DEC_16BIT = 18; // 16-bit decrement
    wire [15:0] dec_16bit_wire = operandB[15:0] - 1;
    
    localparam ROTATE_LEFT = 19; //  8-bit rotate left
    localparam ROTATE_C_LEFT = 20; // 8-bit rotate left through carry 
    localparam ROTATE_LEFT_R = 21; // 8-bit rotate left, different flag updates
    localparam ROTATE_LEFT_R_C = 22; // 8-bit rotate left through carry, different flag updates
    wire [7:0] rotate_c_left_wire = {operandB[6:0], flag[FLAG_C]};
    wire [7:0] rotate_left_wire = {operandB[6:0], operandB[7]};
    
    localparam ROTATE_RIGHT = 23; // 8-bit rotate right
    localparam ROTATE_C_RIGHT = 24; // 8-bit rotate right through carry
    localparam ROTATE_RIGHT_R = 25; // 8-bit rotate right, different flag updates
    localparam ROTATE_RIGHT_R_C = 26; // 8-bit rotate right through carry, different flag updates
    wire [7:0] rotate_c_right_wire = {flag[FLAG_C], operandB[7:1]};
    wire [7:0] rotate_right_wire = {operandB[0], operandB[7:1]};
    
    localparam SHIFT_A_LEFT = 27; // 8-bit arithmetic shift left
    wire [7:0] shift_left_wire = {operandB[6:0], 1'b0};
    
    localparam SHIFT_A_RIGHT = 28; // 8-bit arithmetic shift right
    wire [7:0] arithmetic_shift_right_wire = {operandB[7], operandB[7:1]};
    
    localparam SHIFT_L_RIGHT = 29; // 8-bit logical shift right
    wire [7:0] logical_shift_right_wire = {1'b0, operandB[7:1]};
    
    localparam WEIRD_ROTATE_LEFT = 30; // weird ahhh left rotate through memory location and A (RLD opcode)
    localparam WEIRD_ROTATE_RIGHT = 31; // weird ahhh right rotate through memory location and A (RRD opcode)
    // TODO make wire for this with guidance from FSM team
    
    // these are always on an 8-bit value
    // bits 2:0 specify what bit
    // bits 6:5 decide what operation (01 = Test, 10 = Set, 11 = Reset)
    localparam TEST_BASE = 32;
    localparam SET_BASE = 64; 
    localparam RESET_BASE = 96; 
    
    always @(*) begin
        FLAG_OUT[FLAG_X1] <= 0;
        FLAG_OUT[FLAG_X2] <= 0;
        case (ALU_OP)
            ADD_8BIT: begin
                ALU_OUT <= extendTo16(add_8bit_wire[7:0]);
                FLAG_OUT[FLAG_S] <= add_8bit_wire[7];
                FLAG_OUT[FLAG_Z] <= add_8bit_wire == 0;
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_P_V] <= add_8bit_wire[8]; 
                FLAG_OUT[FLAG_N] <= 1'b0;
                FLAG_OUT[FLAG_C] <= add_8bit_wire[8]; 
            end
            ADD_C_8BIT: begin
                ALU_OUT <= extendTo16(add_c_8bit_wire[7:0]);
                FLAG_OUT[FLAG_S] <= add_c_8bit_wire[7];
                FLAG_OUT[FLAG_Z] <= add_c_8bit_wire == 0;
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_P_V] <= add_c_8bit_wire[8]; 
                FLAG_OUT[FLAG_N] <= 1'b0;
                FLAG_OUT[FLAG_C] <= add_c_8bit_wire[8]; 
            end
            SUB_8BIT: begin
                ALU_OUT <= extendTo16(sub_8bit_wire[7:0]);
                FLAG_OUT[FLAG_S] <= sub_8bit_wire[7];
                FLAG_OUT[FLAG_Z] <= sub_8bit_wire == 0;
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_P_V] <= sub_8bit_wire[8]; // TODO: ???
                FLAG_OUT[FLAG_N] <= 1'b1;
                FLAG_OUT[FLAG_C] <= operandA[7:0] < operandB[7:0];
            end
            SUB_C_8BIT: begin
                ALU_OUT <= extendTo16(sub_c_8bit_wire[7:0]);
                FLAG_OUT[FLAG_S] <= sub_c_8bit_wire[7];
                FLAG_OUT[FLAG_Z] <= sub_c_8bit_wire == 0;
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_P_V] <= sub_c_8bit_wire[8];  // TODO: ???
                FLAG_OUT[FLAG_N] <= 1'b1;
                FLAG_OUT[FLAG_C] <= operandA[7:0] < operandB[7:0];
            end
            AND_8BIT: begin
                ALU_OUT <= {8'b0, and_wire};
                FLAG_OUT[FLAG_S] <= and_wire[7];
                FLAG_OUT[FLAG_Z] <= and_wire == 0;
                FLAG_OUT[FLAG_H] <= 1;
                FLAG_OUT[FLAG_P_V] <= 0; // TODO: ????????
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= 0;
            end
            OR_8BIT: begin
                ALU_OUT <= {8'b0, or_wire};
                FLAG_OUT[FLAG_S] <= or_wire[7];
                FLAG_OUT[FLAG_Z] <= or_wire == 0;
                FLAG_OUT[FLAG_H] <= 0;
                FLAG_OUT[FLAG_P_V] <= 0; // TODO: ????????
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= 0;
            end
            XOR_8BIT: begin
                ALU_OUT <= {8'b0, xor_wire};
                FLAG_OUT[FLAG_S] <= xor_wire[7];
                FLAG_OUT[FLAG_Z] <= xor_wire == 0;
                FLAG_OUT[FLAG_H] <= 0;
                FLAG_OUT[FLAG_P_V] <= !(^xor_wire); // even parity
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= 0;
            end
            CMP: begin
                // TODO: ?????
                ALU_OUT <= 0;
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                FLAG_OUT[FLAG_H] <= flag[FLAG_H];
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= flag[FLAG_N];
                FLAG_OUT[FLAG_C] <= flag[FLAG_C];
            end
            INC_8BIT: begin
                ALU_OUT <= extendTo16(inc_8bit_wire);
                FLAG_OUT[FLAG_S] <= inc_8bit_wire[7];
                FLAG_OUT[FLAG_Z] <= inc_8bit_wire == 0;
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_P_V] <= operandB[7:0] == 8'h7F;
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= flag[FLAG_C];
            end
            DEC_8BIT: begin
                ALU_OUT <= extendTo16(dec_8bit_wire);
                FLAG_OUT[FLAG_S] <= dec_8bit_wire[7];
                FLAG_OUT[FLAG_Z] <= dec_8bit_wire == 0;
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_P_V] <= operandB[7:0] == 8'h80;
                FLAG_OUT[FLAG_N] <= 1;
                FLAG_OUT[FLAG_C] <= flag[FLAG_C];
            end
            ONES_8BIT: begin
                ALU_OUT <= extendTo16(ones_8bit_wire);
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                FLAG_OUT[FLAG_H] <= 1;
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= 1;
                FLAG_OUT[FLAG_C] <= flag[FLAG_C];
            end
            TWOS_8BIT: begin
                ALU_OUT <= extendTo16(twos_8bit_wire);
                FLAG_OUT[FLAG_S] <= twos_8bit_wire[7];
                FLAG_OUT[FLAG_Z] <= twos_8bit_wire == 0;
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_P_V] <= operandB[7:0] == 8'h80;
                FLAG_OUT[FLAG_N] <= 1;
                FLAG_OUT[FLAG_C] <= operandB[7:0] == 8'h00;
            end
            INV_C: begin
                ALU_OUT <= 0;
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_C] <= !flag[FLAG_C];
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= flag[FLAG_N];
            end
            SET_C: begin
                ALU_OUT <= 0;
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= flag[FLAG_N];
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_C] <= 1;
            end
            ADD_16BIT: begin
                ALU_OUT <= add_16bit_wire;
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= 1'b0;
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_C] <= add_16bit_wire[15]; 
            end
            ADD_C_16BIT: begin
                ALU_OUT <= add_c_16bit_wire;
                FLAG_OUT[FLAG_S] <= add_c_16bit_wire[15];
                FLAG_OUT[FLAG_Z] <= add_c_16bit_wire == 0;
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_P_V] <= add_c_16bit_wire[16];
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= add_c_16bit_wire[16];
            end
            SUB_C_16BIT: begin
                ALU_OUT <= sub_c_16bit_wire;
                FLAG_OUT[FLAG_S] <= sub_c_16bit_wire[15];
                FLAG_OUT[FLAG_Z] <= sub_c_16bit_wire == 0;
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_P_V] <= sub_c_16bit_wire[16]; // TODO: ???
                FLAG_OUT[FLAG_N] <= 1;
                FLAG_OUT[FLAG_C] <= operandA[15:0] < (17'b0 + operandB[15:0] + flag[FLAG_C]);
            end
            INC_16BIT: begin
                ALU_OUT <= inc_16bit_wire;
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= flag[FLAG_N];
                FLAG_OUT[FLAG_C] <= flag[FLAG_C];
            end
            DEC_16BIT: begin
                ALU_OUT <= dec_16bit_wire;
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= flag[FLAG_N];
                FLAG_OUT[FLAG_C] <= flag[FLAG_C];
            end
            ROTATE_LEFT: begin
                ALU_OUT <= rotate_left_wire;
                FLAG_OUT[FLAG_S] <= rotate_left_wire[7];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                FLAG_OUT[FLAG_H] <= 0; 
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operandB[7];
            end
            ROTATE_C_LEFT: begin
                ALU_OUT <= rotate_c_left_wire;
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                FLAG_OUT[FLAG_H] <= 0; 
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operandB[7];
            end
            ROTATE_LEFT_R: begin
                ALU_OUT <= rotate_left_wire;
                FLAG_OUT[FLAG_S] <= rotate_left_wire[7];
                FLAG_OUT[FLAG_Z] <= rotate_left_wire == 0;
                FLAG_OUT[FLAG_H] <= 0;
                FLAG_OUT[FLAG_P_V] <= !(^rotate_left_wire);
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operandB[7];
            end
            ROTATE_LEFT_R_C: begin
                ALU_OUT <= rotate_c_left_wire;
                FLAG_OUT[FLAG_S] <= rotate_c_left_wire[7];
                FLAG_OUT[FLAG_Z] <= rotate_c_left_wire == 0;
                FLAG_OUT[FLAG_H] <= 0;
                FLAG_OUT[FLAG_P_V] <= !(^rotate_c_left_wire);
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operandB[7];
            end
            ROTATE_RIGHT: begin
                ALU_OUT <= rotate_right_wire;
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                FLAG_OUT[FLAG_H] <= 0;
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operandB[0];
            end
            ROTATE_C_RIGHT: begin
                ALU_OUT <= rotate_c_right_wire;
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                FLAG_OUT[FLAG_H] <= 0; 
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operandB[0];
            end
            ROTATE_RIGHT_R: begin
                ALU_OUT <= rotate_right_wire;
                FLAG_OUT[FLAG_S] <= rotate_right_wire[7];
                FLAG_OUT[FLAG_Z] <= rotate_right_wire == 0;
                FLAG_OUT[FLAG_H] <= 0;
                FLAG_OUT[FLAG_P_V] <= !(^rotate_right_wire);
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operandB[0];
            end
            ROTATE_RIGHT_R_C: begin
                ALU_OUT <= rotate_c_right_wire;
                FLAG_OUT[FLAG_S] <= rotate_c_right_wire[7];
                FLAG_OUT[FLAG_Z] <= rotate_c_right_wire == 0;
                FLAG_OUT[FLAG_H] <= 0;
                FLAG_OUT[FLAG_P_V] <= !(^rotate_c_right_wire);
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operandB[0];
            end
            SHIFT_A_LEFT: begin
                ALU_OUT <= shift_left_wire;
                FLAG_OUT[FLAG_S] <= shift_left_wire[7];
                FLAG_OUT[FLAG_Z] <= shift_left_wire == 0;
                FLAG_OUT[FLAG_H] <= 0;
                FLAG_OUT[FLAG_P_V] <= !(^shift_left_wire);
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operandB[7];
            end
            SHIFT_A_RIGHT: begin
                ALU_OUT <=  arithmetic_shift_right_wire;
                FLAG_OUT[FLAG_S] <= arithmetic_shift_right_wire[7];
                FLAG_OUT[FLAG_Z] <= arithmetic_shift_right_wire == 0;
                FLAG_OUT[FLAG_H] <= flag[FLAG_H];
                FLAG_OUT[FLAG_P_V] <= !(^arithmetic_shift_right_wire);
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operandB[0];
            end
            SHIFT_L_RIGHT: begin
                ALU_OUT <= logical_shift_right_wire;
                FLAG_OUT[FLAG_S] <= 0;
                FLAG_OUT[FLAG_Z] <= logical_shift_right_wire == 0;
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_P_V] <= !(^logical_shift_right_wire);
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operandB[0];
            end
            TEST_BASE, 
            TEST_BASE + 1,
            TEST_BASE + 2,
            TEST_BASE + 3,
            TEST_BASE + 4,
            TEST_BASE + 5,
            TEST_BASE + 6,
            TEST_BASE + 7: begin
                ALU_OUT <= 0;
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= (operandB[7:0] & (1'b1 << ALU_OP[2:0])) == 0;
                FLAG_OUT[FLAG_H] <= 0;
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
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
                ALU_OUT <= operandB[7:0] | (1'b1 << ALU_OP[2:0]);
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                FLAG_OUT[FLAG_H] <= 0; // TODO
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
                ALU_OUT <= operandB[7:0] & ~(8'b0 + (1'b1 << ALU_OP[2:0]));
                FLAG_OUT[FLAG_S] <= flag[FLAG_S];
                FLAG_OUT[FLAG_Z] <= flag[FLAG_Z];
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_P_V] <= flag[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= flag[FLAG_N];
                FLAG_OUT[FLAG_C] <= flag[FLAG_C];
            end
            default: begin
                ALU_OUT <= 0; // allegedly later assignments win so the later bit test/set/reset ifs should work
                FLAG_OUT <= flag;
            end         
        endcase
    end  
endmodule

module ALU(
    input CLK,
    input [15:0] INT_DATA_BUS_A,
    input [15:0] INT_DATA_BUS_B,
    input [5:0] ALU_OP,
    input ALU_STABLE,
    input ALU_OPA_MUX,
    input ALU_OPB_MUX,
    input [1:0] ACC_IN_MUX,
    input LD_ACCUM,
    input ACTIVE_REGS,
    output [15:0] ALU_OUT,
    output [7:0] FLAG_OUT,
    output [7:0] ACC_OUT
    );

    wire [7:0] alu_flag_out;
    assign FLAG_OUT = alu_flag_out;
    wire [15:0] ALU_OUT_int;
    assign ALU_OUT = ALU_OUT_int;

    // F Register
    reg [7:0] flag, flag_prime;
    wire [7:0] FLAG_OUT_int = ACTIVE_REGS ? flag_prime : flag;
    reg load_flag;
    always @(posedge CLK) begin
        if (load_flag) begin
            if (ACTIVE_REGS)
                flag <= alu_flag_out;
            else
                flag_prime <= alu_flag_out;
        end
    end
    
    // A Register
    reg [7:0] acc, acc_prime;
    reg [7:0] ACC_OUT_int;
    assign ACC_OUT = ACTIVE_REGS ? acc_prime : acc;
    reg load_acc;
    wire [7:0] acc_in_mux_out = ACC_IN_MUX == 0 ? ALU_OUT_int[7:0] : (ACC_IN_MUX == 1 ? INT_DATA_BUS_A[7:0] : (ACC_IN_MUX == 2 ? INT_DATA_BUS_B : 0));
    always @(posedge CLK) begin
        if (load_acc) begin
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
    
endmodule
