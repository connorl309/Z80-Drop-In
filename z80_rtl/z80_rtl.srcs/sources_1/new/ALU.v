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
module ALU(
    input CLK,
    input [15:0] INT_DATA_BUS,
    input [7:0] EXT_DATA_BUS,
    input [5:0] ALU_OP,
    input ALU_STABLE,
    input ALU_IN_MUX,
    input [1:0] ACC_IN_MUX,
    input LD_ACCUM,
    input ACTIVE_REGS,
    output [15:0] ALU_OUT,
    output [7:0] FLAG_OUT,
    input [7:0] ACC_OUT
    );

    // F Register
    reg [7:0] flag, flag_prime;
    assign FLAG_OUT = ACTIVE_REGS ? flag_prime : flag;
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
    wire [15:0] operand_mux = ALU_IN_MUX ? {8'b0, EXT_DATA_BUS} : INT_DATA_BUS[7:0];
    
    // ALU Core
    reg [15:0] reg_alu_out, temp; // used for 16 bit adds, we should fetch the first register pair over the internal data bus and store it here before then fetching the HL reg pair over the internal data bus in the next clock cycle
    reg [7:0] alu_flag_out;
    assign ALU_OUT = reg_alu_out;
    assign FLAG_OUT = alu_flag_out;
    
    localparam NOP = 0; // NOP, duh
    localparam LOAD_TEMP = 1; // load TEMP
    localparam ADD_8BIT = 2; // 8-bit add
    localparam ADD_C_8BIT = 3; // 8-bit add with carry
    wire [8:0] add_c_8bit_wire = acc + operand_mux[7:0] + flag[FLAG_C];
    wire [8:0] add_8bit_wire = acc + operand_mux[7:0];
    
    localparam SUB_8BIT = 4; // 8-bit sub
    localparam SUB_C_8BIT = 5; // 8-bit sub with carry
    wire [8:0] sub_c_8bit_wire = acc - operand_mux[7:0] - flag[FLAG_C];
    wire [8:0] sub_8bit_wire = acc - operand_mux[7:0];
    
    localparam AND_8BIT = 6; // 8-bit AND 
    wire [7:0] and_wire = acc & operand_mux[7:0];
    
    localparam OR_8BIT = 7; // 8-bit OR 
    wire [7:0] or_wire = acc | operand_mux[7:0];
    
    localparam XOR_8BIT = 8; // 8-bit XOR 
    wire [7:0] xor_wire = acc ^ operand_mux[7:0];
    
    localparam CMP = 9; // 8-bit compare
    localparam INC_8BIT = 10; // 8-bit increment
    wire [8:0] inc_8bit_wire = operand_mux[7:0] + 1;
    
    localparam DEC_8BIT = 11; // 8-bit decrement
    wire [8:0] dec_8bit_wire = operand_mux[7:0] - 1;
    
    localparam ONES_8BIT = 12; // 8-bit one's complement negation
    wire [7:0] ones_8bit_wire = ~operand_mux[7:0];
    
    localparam TWOS_8BIT = 13; // 8-bit two's complement negation
    wire [7:0] twos_8bit_wire = -operand_mux[7:0];
    
    localparam INV_C = 14; // Invert carry flag
    localparam SET_C = 15; // Set carry flag
    localparam ADD_16BIT = 16; // 16-bit add 
    localparam ADD_C_16BIT = 17; // 16-bit add with carry 
    wire [16:0] add_c_16bit_wire = temp + operand_mux[15:0] + flag[FLAG_C];
    wire [16:0] add_16bit_wire = temp + operand_mux[15:0];
    
    localparam SUB_C_16BIT = 18; // 16-bit sub with carry
    wire [16:0] sub_c_16bit_wire = temp - operand_mux[15:0] - flag[FLAG_C];
    
    localparam INC_16BIT = 19; // 16-bit increment
    wire [15:0] inc_16bit_wire = operand_mux[15:0] + 1;
    
    localparam DEC_16BIT = 20; // 16-bit decrement
    wire [15:0] dec_16bit_wire = operand_mux[15:0] - 1;
    
    localparam ROTATE_LEFT = 21; //  8-bit rotate left
    localparam ROTATE_C_LEFT = 22; // 8-bit rotate left through carry 
    wire [7:0] rotate_left_wire = {operand_mux[6:0], operand_mux[7]};
    
    localparam ROTATE_RIGHT = 23; // 8-bit rotate right
    localparam ROTATE_C_RIGHT = 24; // 8-bit rotate right through carry
    wire [7:0] rotate_right_wire = {operand_mux[0], operand_mux[7:1]};
    
    localparam SHIFT_A_LEFT = 25; // 8-bit arithmetic shift left
    wire [7:0] shift_left_wire = {operand_mux[6:0], 1'b0};
    
    localparam SHIFT_A_RIGHT = 26; // 8-bit arithmetic shift right
    wire [7:0] arithmetic_shift_right_wire = {operand_mux[7], operand_mux[7:1]};
    
    localparam SHIFT_L_RIGHT = 27; // 8-bit logical shift right
    wire [7:0] logical_shift_right_wire = {1'b0, operand_mux[7:1]};
    
    localparam WEIRD_ROTATE_LEFT = 28; // weird ahhh left rotate through memory location and A (RLD opcode)
    localparam WEIRD_ROTATE_RIGHT = 29; // weird ahhh right rotate through memory location and A (RRD opcode)
    // TODO make wire for this
    
    localparam TEST_BIT = 30; // test a bit numbered by TEMP
    localparam SET_BIT = 31; // set a bit numbered by TEMP
    localparam RESET_BIT = 32; // reset a bit numbered by TEMP

    // TODO: confirm behavior of C and P/V flags during add/sub
    // TODO: H flag
    
    /*
                reg_alu_out <= 
                alu_flag_out[FLAG_S] <= 
                alu_flag_out[FLAG_Z] <= 
                alu_flag_out[FLAG_P_V] <= 
                alu_flag_out[FLAG_N] <= 
                alu_flag_out[FLAG_C] <= 
    */
   
    always @(posedge CLK) begin
        case (ALU_OP)
            LOAD_TEMP:
                temp <= operand_mux;
            ADD_8BIT: begin
                reg_alu_out <= extendTo16(add_8bit_wire[7:0]);
                alu_flag_out[FLAG_S] <= add_8bit_wire[7];
                alu_flag_out[FLAG_Z] <= add_8bit_wire == 0;
                alu_flag_out[FLAG_P_V] <= add_8bit_wire[8]; 
                alu_flag_out[FLAG_N] <= 1'b0;
                alu_flag_out[FLAG_C] <= add_8bit_wire[8]; 
            end
            ADD_C_8BIT: begin
                reg_alu_out <= extendTo16(add_c_8bit_wire[7:0]);
                alu_flag_out[FLAG_S] <= add_c_8bit_wire[7];
                alu_flag_out[FLAG_Z] <= add_c_8bit_wire == 0;
                alu_flag_out[FLAG_P_V] <= add_c_8bit_wire[8]; 
                alu_flag_out[FLAG_N] <= 1'b0;
                alu_flag_out[FLAG_C] <= add_c_8bit_wire[8]; 
            end
            SUB_8BIT: begin
                reg_alu_out <= extendTo16(sub_8bit_wire[7:0]);
                alu_flag_out[FLAG_S] <= sub_8bit_wire[7];
                alu_flag_out[FLAG_Z] <= sub_8bit_wire == 0;
                alu_flag_out[FLAG_P_V] <= sub_8bit_wire[8]; // TODO: ???
                alu_flag_out[FLAG_N] <= 1'b1;
                alu_flag_out[FLAG_C] <= acc < operand_mux[7:0];
            end
            SUB_C_8BIT: begin
                reg_alu_out <= extendTo16(sub_c_8bit_wire[7:0]);
                alu_flag_out[FLAG_S] <= sub_c_8bit_wire[7];
                alu_flag_out[FLAG_Z] <= sub_c_8bit_wire == 0;
                alu_flag_out[FLAG_P_V] <= sub_c_8bit_wire[8];  // TODO: ???
                alu_flag_out[FLAG_N] <= 1'b1;
                alu_flag_out[FLAG_C] <= acc < operand_mux[7:0];
            end
            AND_8BIT: begin
                reg_alu_out <= {8'b0, and_wire};
                alu_flag_out[FLAG_S] <= and_wire[7];
                alu_flag_out[FLAG_Z] <= and_wire == 0;
                alu_flag_out[FLAG_H] <= 1;
                alu_flag_out[FLAG_P_V] <= 0; // TODO: ????????
                alu_flag_out[FLAG_N] <= 0;
                alu_flag_out[FLAG_C] <= 0;
            end
            OR_8BIT: begin
                reg_alu_out <= {8'b0, or_wire};
                alu_flag_out[FLAG_S] <= or_wire[7];
                alu_flag_out[FLAG_Z] <= or_wire == 0;
                alu_flag_out[FLAG_H] <= 0;
                alu_flag_out[FLAG_P_V] <= 0; // TODO: ????????
                alu_flag_out[FLAG_N] <= 0;
                alu_flag_out[FLAG_C] <= 0;
            end
            XOR_8BIT: begin
                reg_alu_out <= {8'b0, xor_wire};
                alu_flag_out[FLAG_S] <= xor_wire[7];
                alu_flag_out[FLAG_Z] <= xor_wire == 0;
                alu_flag_out[FLAG_H] <= 0;
                alu_flag_out[FLAG_P_V] <= !(^xor_wire); // even parity
                alu_flag_out[FLAG_N] <= 0;
                alu_flag_out[FLAG_C] <= 0;
            end
            CMP: begin
                // TODO: ?????
            end
            INC_8BIT: begin
                reg_alu_out <= extendTo16(inc_8bit_wire);
                alu_flag_out[FLAG_S] <= inc_8bit_wire[7];
                alu_flag_out[FLAG_Z] <= inc_8bit_wire == 0;
                alu_flag_out[FLAG_P_V] <= operand_mux[7:0] == 8'h7F;
                alu_flag_out[FLAG_N] <= 0;
                alu_flag_out[FLAG_C] <= alu_flag_out[FLAG_C];
            end
            DEC_8BIT: begin
                reg_alu_out <= extendTo16(dec_8bit_wire);
                alu_flag_out[FLAG_S] <= dec_8bit_wire[7];
                alu_flag_out[FLAG_Z] <= dec_8bit_wire == 0;
                alu_flag_out[FLAG_P_V] <= operand_mux[7:0] == 8'h80;
                alu_flag_out[FLAG_N] <= 1;
                alu_flag_out[FLAG_C] <= alu_flag_out[FLAG_C];
            end
            ONES_8BIT: begin
                reg_alu_out <= extendTo16(ones_8bit_wire);
                alu_flag_out[FLAG_S] <= alu_flag_out[FLAG_S];
                alu_flag_out[FLAG_Z] <= alu_flag_out[FLAG_Z];
                alu_flag_out[FLAG_H] <= 1;
                alu_flag_out[FLAG_P_V] <= alu_flag_out[FLAG_P_V];
                alu_flag_out[FLAG_N] <= 1;
                alu_flag_out[FLAG_C] <= alu_flag_out[FLAG_C];
            end
            TWOS_8BIT: begin
                reg_alu_out <= extendTo16(twos_8bit_wire);
                alu_flag_out[FLAG_S] <= twos_8bit_wire[7];
                alu_flag_out[FLAG_Z] <= twos_8bit_wire == 0;
                alu_flag_out[FLAG_P_V] <= operand_mux[7:0] == 8'h80;
                alu_flag_out[FLAG_N] <= 1;
                alu_flag_out[FLAG_C] <= operand_mux[7:0] == 8'h00;
            end
            INV_C: begin
                alu_flag_out[FLAG_C] <= !alu_flag_out[FLAG_C];
            end
            SET_C: begin
                alu_flag_out[FLAG_C] <= 1;
            end
            ADD_16BIT: begin
                reg_alu_out <= add_16bit_wire;
                alu_flag_out[FLAG_N] <= 1'b0;
                alu_flag_out[FLAG_C] <= add_16bit_wire[15]; 
            end
            ADD_C_16BIT: begin
                reg_alu_out <= add_c_16bit_wire;
                alu_flag_out[FLAG_S] <= add_c_16bit_wire[15];
                alu_flag_out[FLAG_Z] <= add_c_16bit_wire == 0;
                alu_flag_out[FLAG_P_V] <= add_c_16bit_wire[16];
                alu_flag_out[FLAG_N] <= 0;
                alu_flag_out[FLAG_C] <= add_c_16bit_wire[16];
            end
            SUB_C_16BIT: begin
                reg_alu_out <= sub_c_16bit_wire;
                alu_flag_out[FLAG_S] <= sub_c_16bit_wire[15];
                alu_flag_out[FLAG_Z] <= sub_c_16bit_wire == 0;
                alu_flag_out[FLAG_P_V] <= sub_c_16bit_wire[16]; // TODO: ???
                alu_flag_out[FLAG_N] <= 1;
                alu_flag_out[FLAG_C] <= temp < (17'b0 + operand_mux[15:0] + flag[FLAG_C]);
            end
            INC_16BIT: begin
                 reg_alu_out <= inc_16bit_wire;
            end
            DEC_16BIT: begin
                reg_alu_out <= dec_16bit_wire;
            end
            
        endcase    
    end
    
    
endmodule
