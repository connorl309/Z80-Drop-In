`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2024 08:11:56 PM
// Design Name: 
// Module Name: datapath
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

`define PC_MUX_INC 0
`define PC_MUX_MINUS_TWO 1
`define PC_MUX_RST 2
`define PC_MUX_ALU 3
`define PC_MUX_REG 4


module datapath(
    input CLK,
    input [2:0] PC_MUX,
    input LD_MAR,
    input LD_MDR,
    input MREQ,
    input MEM_RD,
    input MEM_WR,
    input [3:0] SR1,
    input [3:0] SR2,
    input [3:0] DR,
    input [15:0] REG_IN,
    input LD_REG,
    input EXTOGGLE_DEHL,
    input EXXTOGGLE,
    input [1:0] ALU_A_MUX,
    input [1:0] ALU_B_MUX,
    input [6:0] ALU_OP,
    input [7:0] FLAG_IN,
    input ALU_OPA_MUX,
    input [1:0] ACC_IN_MUX,
    input LD_ACC,
    input LD_FLAG,
    input FLAG_MUX,
    input LD_PC,
    input LD_IR,
    
    output reg [15:0] MAR,
    output reg [7:0] MDR,
    output reg [15:0] PC,
    output reg [7:0] IR,
    output [7:0] FLAG_OUT
    );
    
    // MAR
    always @(posedge CLK) begin
        MAR <= LD_MAR ? PC : MAR;
    end
    
    initial begin
        MAR = 0;
        PC = 0;
        IR = 0;
    end
    
    // external buses
    (* KEEP = "TRUE" *)
    reg [15:0] ADDR_BUS = 0;
    (* KEEP = "TRUE" *)
    reg [7:0] DATA_BUS = 0;
    
    // Memory
//    blk_mem_gen_0 mem (
//        .clka(CLK),
//        .
//    );

    (* KEEP = "TRUE" *)
    wire [7:0] MEM_OUT;

    always @(posedge CLK) begin
        MDR <= LD_MDR ? MEM_OUT : MDR;
    end
    
    (* KEEP_HIERARCHY = "TRUE" *)
    memory mem (
        .CLK(!CLK),
        .MREQ(MREQ),
        .RD(MEM_RD),
        .WR(MEM_WR),
        .ADDR(MAR),
        .DATA_IN(MDR),
        .DATA_OUT(MEM_OUT)
    );
    
    // reg file
    (* KEEP = "TRUE" *)
    wire [15:0] SR1_OUT;
    (* KEEP = "TRUE" *)
    wire [15:0] SR2_OUT;
    
    // datapath modules
    (* KEEP_HIERARCHY = "TRUE" *)
    reg_file reg_file (
        .CLK(CLK),
        .SR1(SR1),
        .SR2(SR2),
        .DR(DR),
        .REG_IN(REG_IN),
        .LD_REG(LD_REG),
        .EXTOGGLE_DEHL(EXTOGGLE_DEHL),
        .EXXTOGGLE(EXXTOGGLE),
        .SR1_OUT(SR1_OUT),
        .SR2_OUT(SR2_OUT));
    
    // ALU
    (* KEEP = "TRUE" *)
    wire [15:0] ALU_A = ALU_A_MUX == 0 ? SR2_OUT :
                        ALU_A_MUX == 1 ? MDR : 
                                        SR2_OUT;
    (* KEEP = "TRUE" *)                                    
    wire [15:0] ALU_B = ALU_B_MUX == 0 ? SR1_OUT :
                        ALU_B_MUX == 1 ? PC : 
                                         MDR;
    (* KEEP = "TRUE" *)
    wire [15:0] ALU_OUT_wire;
    (* KEEP = "TRUE" *)
    wire [7:0] ACC_OUT;
    
    (* KEEP_HIERARCHY = "TRUE" *)
    ALU alu (
        .CLK(CLK),
        .INT_DATA_BUS_A(ALU_A),
        .INT_DATA_BUS_B(ALU_B),
        .ALU_OP(ALU_OP),
        .ALU_OPA_MUX(ALU_OPA_MUX),
        .ACC_IN_MUX(ACC_IN_MUX),
        .LD_ACC(LD_ACC),
        .LD_FLAG(LD_FLAG),
        .FLAG_IN(FLAG_IN),
        .FLAG_MUX(FLAG_MUX),
        .ALU_OUT(ALU_OUT_wire),
        .FLAG_OUT(FLAG_OUT),
        .ACC_OUT(ACC_OUT));
        
        
        
    // PC
    (* KEEP = "TRUE" *)
    wire [15:0] PC_in = PC_MUX == `PC_MUX_INC ? PC + 1 :
                        PC_MUX == `PC_MUX_MINUS_TWO ? PC - 2 :
                        PC_MUX == `PC_MUX_RST ? IR << 3 :
                        PC_MUX == `PC_MUX_ALU ? ALU_OUT_wire :
                        PC_MUX == `PC_MUX_REG ? {MDR, SR1_OUT[7:0]} : 0;
                        
    always @(posedge CLK) begin
        PC <= LD_PC ? PC_in : PC;
    end
    
    // IR
    always @(posedge CLK) begin
        IR <= LD_IR ? MDR : IR;
    end
    
endmodule
