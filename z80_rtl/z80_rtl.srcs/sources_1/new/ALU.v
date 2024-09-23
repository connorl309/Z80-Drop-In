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
    input [5:0] ALU_OP,
    input [15:0] operand,
    input [7:0] acc,
    input [15:0] temp,
    input [7:0] flag,
    output reg [15:0] ALU_OUT,
    output reg [7:0] FLAG_OUT);
    
    localparam FLAG_S = 7;
    localparam FLAG_Z = 6;
    localparam FLAG_H = 4;
    localparam FLAG_P_V = 2;
    localparam FLAG_N = 1;
    localparam FLAG_C = 0;
    
    localparam LOAD_TEMP = 0; // load TEMP
    localparam ADD_8BIT = 1; // 8-bit add
    localparam ADD_C_8BIT = 2; // 8-bit add with carry
    wire [8:0] add_c_8bit_wire = acc + operand[7:0] + flag[FLAG_C];
    wire [8:0] add_8bit_wire = acc + operand[7:0];
    
    localparam SUB_8BIT = 3; // 8-bit sub
    localparam SUB_C_8BIT = 4; // 8-bit sub with carry
    wire [8:0] sub_c_8bit_wire = acc - operand[7:0] - flag[FLAG_C];
    wire [8:0] sub_8bit_wire = acc - operand[7:0];
    
    localparam AND_8BIT = 5; // 8-bit AND 
    wire [7:0] and_wire = acc & operand[7:0];
    
    localparam OR_8BIT = 6; // 8-bit OR 
    wire [7:0] or_wire = acc | operand[7:0];
    
    localparam XOR_8BIT = 7; // 8-bit XOR 
    wire [7:0] xor_wire = acc ^ operand[7:0];
    
    localparam CMP = 8; // 8-bit compare
    localparam INC_8BIT = 9; // 8-bit increment
    wire [8:0] inc_8bit_wire = operand[7:0] + 1;
    
    localparam DEC_8BIT = 10; // 8-bit decrement
    wire [8:0] dec_8bit_wire = operand[7:0] - 1;
    
    localparam ONES_8BIT = 11; // 8-bit one's complement negation
    wire [7:0] ones_8bit_wire = ~operand[7:0];
    
    localparam TWOS_8BIT = 12; // 8-bit two's complement negation
    wire [7:0] twos_8bit_wire = -operand[7:0];
    
    localparam INV_C = 13; // Invert carry flag
    localparam SET_C = 14; // Set carry flag
    localparam ADD_16BIT = 15; // 16-bit add 
    localparam ADD_C_16BIT = 16; // 16-bit add with carry 
    wire [16:0] add_c_16bit_wire = temp + operand[15:0] + flag[FLAG_C];
    wire [16:0] add_16bit_wire = temp + operand[15:0];
    
    localparam SUB_C_16BIT = 17; // 16-bit sub with carry
    wire [16:0] sub_c_16bit_wire = temp - operand[15:0] - flag[FLAG_C];
    
    localparam INC_16BIT = 18; // 16-bit increment
    wire [15:0] inc_16bit_wire = operand[15:0] + 1;
    
    localparam DEC_16BIT = 19; // 16-bit decrement
    wire [15:0] dec_16bit_wire = operand[15:0] - 1;
    
    localparam ROTATE_LEFT = 20; //  8-bit rotate left
    localparam ROTATE_C_LEFT = 21; // 8-bit rotate left through carry 
    localparam ROTATE_LEFT_R = 22; // 8-bit rotate left, different flag updates
    localparam ROTATE_LEFT_R_C = 23; // 8-bit rotate left through carry, different flag updates
    wire [7:0] rotate_c_left_wire = {operand[6:0], flag[FLAG_C]};
    wire [7:0] rotate_left_wire = {operand[6:0], operand[7]};
    
    localparam ROTATE_RIGHT = 24; // 8-bit rotate right
    localparam ROTATE_C_RIGHT = 25; // 8-bit rotate right through carry
    localparam ROTATE_RIGHT_R = 26; // 8-bit rotate right, different flag updates
    localparam ROTATE_RIGHT_R_C = 27; // 8-bit rotate right through carry, different flag updates
    wire [7:0] rotate_c_right_wire = {flag[FLAG_C], operand[7:1]};
    wire [7:0] rotate_right_wire = {operand[0], operand[7:1]};
    
    localparam SHIFT_A_LEFT = 28; // 8-bit arithmetic shift left
    wire [7:0] shift_left_wire = {operand[6:0], 1'b0};
    
    localparam SHIFT_A_RIGHT = 29; // 8-bit arithmetic shift right
    wire [7:0] arithmetic_shift_right_wire = {operand[7], operand[7:1]};
    
    localparam SHIFT_L_RIGHT = 30; // 8-bit logical shift right
    wire [7:0] logical_shift_right_wire = {1'b0, operand[7:1]};
    
    localparam WEIRD_ROTATE_LEFT = 31; // weird ahhh left rotate through memory location and A (RLD opcode)
    localparam WEIRD_ROTATE_RIGHT = 32; // weird ahhh right rotate through memory location and A (RRD opcode)
    // TODO make wire for this with guidance from FSM team
    
    // these are always on an 8-bit value
    // uses base ALU_OP numbers to encode the specified bit
    localparam TEST_BASE = 33;
    localparam SET_BASE = TEST_BASE + 8; 
    localparam RESET_BASE = SET_BASE + 8; 
    
    always @(*) begin
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
                FLAG_OUT[FLAG_C] <= acc < operand[7:0];
            end
            SUB_C_8BIT: begin
                ALU_OUT <= extendTo16(sub_c_8bit_wire[7:0]);
                FLAG_OUT[FLAG_S] <= sub_c_8bit_wire[7];
                FLAG_OUT[FLAG_Z] <= sub_c_8bit_wire == 0;
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_P_V] <= sub_c_8bit_wire[8];  // TODO: ???
                FLAG_OUT[FLAG_N] <= 1'b1;
                FLAG_OUT[FLAG_C] <= acc < operand[7:0];
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
            end
            INC_8BIT: begin
                ALU_OUT <= extendTo16(inc_8bit_wire);
                FLAG_OUT[FLAG_S] <= inc_8bit_wire[7];
                FLAG_OUT[FLAG_Z] <= inc_8bit_wire == 0;
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_P_V] <= operand[7:0] == 8'h7F;
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= FLAG_OUT[FLAG_C];
            end
            DEC_8BIT: begin
                ALU_OUT <= extendTo16(dec_8bit_wire);
                FLAG_OUT[FLAG_S] <= dec_8bit_wire[7];
                FLAG_OUT[FLAG_Z] <= dec_8bit_wire == 0;
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_P_V] <= operand[7:0] == 8'h80;
                FLAG_OUT[FLAG_N] <= 1;
                FLAG_OUT[FLAG_C] <= FLAG_OUT[FLAG_C];
            end
            ONES_8BIT: begin
                ALU_OUT <= extendTo16(ones_8bit_wire);
                FLAG_OUT[FLAG_S] <= FLAG_OUT[FLAG_S];
                FLAG_OUT[FLAG_Z] <= FLAG_OUT[FLAG_Z];
                FLAG_OUT[FLAG_H] <= 1;
                FLAG_OUT[FLAG_P_V] <= FLAG_OUT[FLAG_P_V];
                FLAG_OUT[FLAG_N] <= 1;
                FLAG_OUT[FLAG_C] <= FLAG_OUT[FLAG_C];
            end
            TWOS_8BIT: begin
                ALU_OUT <= extendTo16(twos_8bit_wire);
                FLAG_OUT[FLAG_S] <= twos_8bit_wire[7];
                FLAG_OUT[FLAG_Z] <= twos_8bit_wire == 0;
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_P_V] <= operand[7:0] == 8'h80;
                FLAG_OUT[FLAG_N] <= 1;
                FLAG_OUT[FLAG_C] <= operand[7:0] == 8'h00;
            end
            INV_C: begin
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_C] <= !FLAG_OUT[FLAG_C];
            end
            SET_C: begin
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_C] <= 1;
            end
            ADD_16BIT: begin
                ALU_OUT <= add_16bit_wire;
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
                FLAG_OUT[FLAG_C] <= temp < (17'b0 + operand[15:0] + flag[FLAG_C]);
            end
            INC_16BIT: begin
                 ALU_OUT <= inc_16bit_wire;
                 FLAG_OUT[FLAG_H] <= 0; // TODO
            end
            DEC_16BIT: begin
                ALU_OUT <= dec_16bit_wire;
                FLAG_OUT[FLAG_H] <= 0; // TODO
            end
            ROTATE_LEFT: begin
                ALU_OUT <= rotate_left_wire;
                FLAG_OUT[FLAG_S] <= rotate_left_wire[7];
                FLAG_OUT[FLAG_H] <= 0; 
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operand[7];
            end
            ROTATE_C_LEFT: begin
                ALU_OUT <= rotate_c_left_wire;
                FLAG_OUT[FLAG_H] <= 0; 
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operand[7];
            end
            ROTATE_LEFT_R: begin
                ALU_OUT <= rotate_left_wire;
                FLAG_OUT[FLAG_S] <= rotate_left_wire[7];
                FLAG_OUT[FLAG_Z] <= rotate_left_wire == 0;
                FLAG_OUT[FLAG_H] <= 0;
                FLAG_OUT[FLAG_P_V] <= !(^rotate_left_wire);
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operand[7];
            end
            ROTATE_LEFT_R_C: begin
                ALU_OUT <= rotate_c_left_wire;
                FLAG_OUT[FLAG_S] <= rotate_c_left_wire[7];
                FLAG_OUT[FLAG_Z] <= rotate_c_left_wire == 0;
                FLAG_OUT[FLAG_H] <= 0;
                FLAG_OUT[FLAG_P_V] <= !(^rotate_c_left_wire);
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operand[7];
            end
            ROTATE_RIGHT: begin
                ALU_OUT <= rotate_right_wire;
                FLAG_OUT[FLAG_H] <= 0; 
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operand[0];
            end
            ROTATE_C_RIGHT: begin
                ALU_OUT <= rotate_c_right_wire;
                FLAG_OUT[FLAG_H] <= 0; 
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operand[0];
            end
            ROTATE_RIGHT_R: begin
                ALU_OUT <= rotate_right_wire;
                FLAG_OUT[FLAG_S] <= rotate_right_wire[7];
                FLAG_OUT[FLAG_Z] <= rotate_right_wire == 0;
                FLAG_OUT[FLAG_H] <= 0;
                FLAG_OUT[FLAG_P_V] <= !(^rotate_right_wire);
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operand[0];
            end
            ROTATE_RIGHT_R_C: begin
                ALU_OUT <= rotate_c_right_wire;
                FLAG_OUT[FLAG_S] <= rotate_c_right_wire[7];
                FLAG_OUT[FLAG_Z] <= rotate_c_right_wire == 0;
                FLAG_OUT[FLAG_H] <= 0;
                FLAG_OUT[FLAG_P_V] <= !(^rotate_c_right_wire);
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operand[0];
            end
            SHIFT_A_LEFT: begin
                ALU_OUT <= shift_left_wire;
                FLAG_OUT[FLAG_S] <= shift_left_wire[7];
                FLAG_OUT[FLAG_Z] <= shift_left_wire == 0;
                FLAG_OUT[FLAG_H] <= 0;
                FLAG_OUT[FLAG_P_V] <= !(^shift_left_wire);
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operand[7];
            end
            SHIFT_A_RIGHT: begin
                ALU_OUT <=  arithmetic_shift_right_wire;
                FLAG_OUT[FLAG_S] <= arithmetic_shift_right_wire[7];
                FLAG_OUT[FLAG_Z] <= arithmetic_shift_right_wire == 0;
                FLAG_OUT[FLAG_P_V] <= !(^arithmetic_shift_right_wire);
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operand[0];
            end
            SHIFT_L_RIGHT: begin
                ALU_OUT <= logical_shift_right_wire;
                FLAG_OUT[FLAG_S] <= 0;
                FLAG_OUT[FLAG_Z] <= logical_shift_right_wire == 0;
                FLAG_OUT[FLAG_H] <= 0; // TODO
                FLAG_OUT[FLAG_P_V] <= !(^logical_shift_right_wire);
                FLAG_OUT[FLAG_N] <= 0;
                FLAG_OUT[FLAG_C] <= operand[0];
            end
        endcase
        if (ALU_OP >= TEST_BASE && ALU_OP < SET_BASE) begin
            FLAG_OUT[FLAG_Z] <= (operand[7:0] & (ALU_OP - TEST_BASE)) == 0;
            FLAG_OUT[FLAG_H] <= 0;
            FLAG_OUT[FLAG_N] <= 0;
        end else if (ALU_OP >= SET_BASE && ALU_OP < RESET_BASE) begin
            ALU_OUT <= operand[7:0] | (1'b1 << (ALU_OP - SET_BASE));
            FLAG_OUT[FLAG_H] <= 0; // TODO
        end else if (ALU_OP >= RESET_BASE && ALU_OP < RESET_BASE + 8) begin
            ALU_OUT <= operand[7:0] & ~(8'b0 + (1'b1 << (ALU_OP - SET_BASE)));
            FLAG_OUT[FLAG_H] <= 0; // TODO
        end else begin
            ALU_OUT <= 0;
            FLAG_OUT <= flag;
        end
    end  
endmodule

module ALU(
    input CLK,
    input [15:0] INT_DATA_BUS,
    input [7:0] EXT_DATA_BUS,
    input [5:0] ALU_OP,
    input ALU_STABLE,
    input [1:0] ALU_IN_MUX,
    input [1:0] ACC_IN_MUX,
    input LD_ACCUM,
    input ACTIVE_REGS,
    output wire [15:0] ALU_OUT,
    output wire [7:0] FLAG_OUT,
    output [7:0] ACC_OUT
    );

    // F Register
    reg [7:0] flag, flag_prime;
    wire [7:0] FLAG_OUT_int = ACTIVE_REGS ? flag_prime : flag;
    reg load_flag;
    reg [7:0] alu_flags;
    localparam FLAG_S = 7;
    localparam FLAG_Z = 6;
    localparam FLAG_H = 4;
    localparam FLAG_P_V = 2;
    localparam FLAG_N = 1;
    localparam FLAG_C = 0;
    always @(posedge CLK) begin
        if (load_flag) begin
            if (ACTIVE_REGS)
                flag <= alu_flags;
            else
                flag_prime <= alu_flags;
        end
    end
    
    // A Register
    reg [7:0] acc, acc_prime;
    wire [7:0] ACC_OUT_int = ACTIVE_REGS ? acc_prime : acc;
    assign ACC_OUT = ACTIVE_REGS ? acc_prime : acc;
    reg load_acc;
    reg [7:0] alu_acc_out;
    wire [7:0] acc_in_mux = ACC_IN_MUX == 0 ? INT_DATA_BUS[7:0] : (ACC_IN_MUX == 1 ? {8'b0, EXT_DATA_BUS} : (ACC_IN_MUX == 2 ? alu_acc_out : 0));
    always @(posedge CLK) begin
        if (load_acc) begin
            if (ACTIVE_REGS)
                acc <= alu_acc_out;
            else
                acc_prime <= alu_acc_out;
        end
    end
    
    // ALU operand mux
    wire [15:0] operand_mux = ALU_IN_MUX == 0 ? {8'b0, EXT_DATA_BUS} : (ALU_IN_MUX == 1 ? {8'b0, acc} : INT_DATA_BUS[7:0]);
    
    // ALU Core
    reg [15:0] reg_alu_out, temp; // used for 16 bit adds, we should fetch the first register pair over the internal data bus and store it here before then fetching the HL reg pair over the internal data bus in the next clock cycle
    reg [7:0] alu_flag_out;
    //assign ALU_OUT = reg_alu_out;
    
    ALU_Core core(.ALU_OP(ALU_OP), .operand(operand_mux), .acc(ACC_OUT_int), .temp(temp), .flag(FLAG_OUT_int), .ALU_OUT(ALU_OUT), .FLAG_OUT(FLAG_OUT));
    
    
endmodule
