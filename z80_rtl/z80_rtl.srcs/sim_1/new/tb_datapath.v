`timescale 1ns / 1ps
`include "../../sources_1/new/z80_defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2024 03:10:17 PM
// Design Name: 
// Module Name: tb_datapath
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

`define RESET_SIGNALS \
    PC_MUX = 0; \
    LD_MAR = 0; \
    MREQ = 1; \
    MEM_RD = 1; \
    MEM_WR = 1; \
    SR1 = 0; \
    SR2 = 0; \
    DR = 0; \
    REG_IN = 0; \
    LD_REG = 0; \
    EXTOGGLE_DEHL = 0; \
    EXXTOGGLE = 0; \
    ALU_A_MUX = 0; \
    ALU_B_MUX = 0; \
    ALU_OP = 0; \
    FLAG_IN = 0; \
    ALU_OPA_MUX = 0; \
    ACC_IN_MUX = 0; \
    LD_ACC = 0; \
    LD_FLAG = 0; \
    FLAG_MUX = 0; \
    LD_PC = 0; \
    LD_IR = 0 

`define FETCH \
    #0; LD_MAR = 1; \
    #5; CLK = 1; \
    #1; \
    `RESET_SIGNALS; \
    #4; CLK = 0; \
    #1; MREQ = 0; \
    #0; MEM_RD = 0; \
    #4; CLK = 1; \
    #5; CLK = 0; \
    #0; LD_MDR = 1; \
    #5; CLK = 1; \
    #2; $display("Fetched 0x%h at location 0x%h", MDR, MAR); \
    #0; LD_MDR = 0; \
    #3; CLK = 0; \
    #0; MREQ = 1; \
    #0; MEM_RD = 1; \
    #0; LD_IR = 1; \
    #0; PC_MUX = 1; \
    #0; LD_PC = 1; \
    #5; CLK = 1; \
    #1; LD_IR = 0; \
    #0; PC_MUX = 0; \
    #0; LD_PC = 0; \
    #4; CLK = 0

module tb_datapath();

    reg CLK = 0;
    reg [2:0] PC_MUX = 0;
    reg LD_MAR = 0;
    reg LD_MDR = 0;
    reg MREQ = 1;
    reg MEM_RD = 1;
    reg MEM_WR = 1;
    reg [3:0] SR1 = 0;
    reg [3:0] SR2 = 0;
    reg [3:0] DR = 0;
    reg [15:0] REG_IN = 0;
    reg LD_REG = 0;
    reg EXTOGGLE_DEHL = 0;
    reg EXXTOGGLE = 0;
    reg [1:0] ALU_A_MUX = 0;
    reg [1:0] ALU_B_MUX = 0;
    reg [6:0] ALU_OP = 0;
    reg [7:0] FLAG_IN = 0;
    reg ALU_OPA_MUX = 0;
    reg [1:0] ACC_IN_MUX = 0;
    reg LD_ACC = 0;
    reg LD_FLAG = 0;
    reg FLAG_MUX = 0;
    reg LD_PC = 0;
    reg LD_IR = 0;
    
    wire [15:0] MAR;
    wire [7:0] MDR;
    wire [15:0] PC;
    wire [7:0] IR;
    wire [7:0] FLAG_OUT;
    
    datapath datapath (
         CLK,
         PC_MUX,
         LD_MAR,
         LD_MDR,
         MREQ,
         MEM_RD,
         MEM_WR,
         SR1,
         SR2,
         DR,
         REG_IN,
         LD_REG,
         EXTOGGLE_DEHL,
         EXXTOGGLE,
         ALU_A_MUX,
         ALU_B_MUX,
         ALU_OP,
         FLAG_IN,
         ALU_OPA_MUX,
         ACC_IN_MUX,
         LD_ACC,
         LD_FLAG,
         FLAG_MUX,
         LD_PC,
         LD_IR,
         
         MAR,
         MDR,
         PC,
         IR,
         FLAG_OUT
    );
    
    reg HALTED = 0;
    
    initial begin
        while (!HALTED) begin
            `FETCH;
            
            if (IR[7:6] == 2'b0 && IR[2:0] == 3'b110) begin
                // LD r,n instruction
                #1; MREQ = 0; 
                #0; MEM_RD = 0; 
                #0; LD_MAR = 1;
                #4; CLK = 1; 
                #0; LD_MAR = 0;
                // cycle 2 
                #5; CLK = 0; 
                #1; LD_MDR = 1;
                #4; CLK = 1; 
                // cycle 3 
                #2; $display("Fetched 0x%h at location 0x%h", MDR, MAR); 
                #0; LD_MDR = 0;
                #3; CLK = 0; 
                #0; MREQ = 1; 
                #0; MEM_RD = 1; 
                #0; PC_MUX = 1;
                #0; LD_PC = 1;
                
                if (IR[5:3] == 3'b111) begin
                    #0; LD_ACC = 1;
                    #0; ACC_IN_MUX = 2;
                    #0; ALU_A_MUX = 1;
                    #5; CLK = 1; 
                    #0; LD_ACC = 0;
                    #0; ACC_IN_MUX = 0;
                    #0; ALU_A_MUX = 0;
                end else begin
                    #0; DR = IR[5:3];
                    #0; LD_REG = 1;
                    #0; REG_IN = MDR;
                    #5; CLK = 1; 
                    #0; LD_REG = 0;
                    #0; DR = 0;
                    #0; REG_IN = 0;
                end
                
                #0; PC_MUX = 0;
                #0; LD_PC = 0;
                #5; CLK = 0;
                #1;
            end else if (IR[7:3] == 5'b10000) begin
                if (IR[2:0] == 3'b111) begin
                    
                end else begin
                    #0; SR1 = IR[2:0];
                end
                #0; LD_ACC = 1;
                #0; LD_FLAG = 1;
                #0; FLAG_MUX = 0;
                #0; ACC_IN_MUX = 0;
                #0; ALU_OP = `ALU_ADD_8BIT;
                #0; ALU_OPA_MUX = 0;
                #0; ALU_A_MUX = 0;
                #0; ALU_B_MUX = 0;
                #1; #1;
            end else if (IR[7:6] == 2'b11 && IR[2:0] == 3'b010) begin
                // check cc
                if ((IR[5:3] == 3'b000 && !FLAG_OUT[`FLAG_Z]) ||
                    (IR[5:3] == 3'b001 && FLAG_OUT[`FLAG_Z]) ||
                    (IR[5:3] == 3'b010 && !FLAG_OUT[`FLAG_C]) ||
                    (IR[5:3] == 3'b011 && FLAG_OUT[`FLAG_C]) ||
                    (IR[5:3] == 3'b100 && !FLAG_OUT[`FLAG_PV]) ||
                    (IR[5:3] == 3'b101 && FLAG_OUT[`FLAG_PV]) ||
                    (IR[5:3] == 3'b110 && !FLAG_OUT[`FLAG_S]) ||
                    (IR[5:3] == 3'b111 && FLAG_OUT[`FLAG_S])) begin
                        `FETCH;
                        #0; LD_REG = 1;
                        #0; DR = 6; // store low byte into W
                        #0; REG_IN = MDR;
                        `FETCH;
                        #0; SR1 = 6;
                        #0; PC_MUX = 4; // PC = {MDR, SR1(W)};
                        #1; LD_PC = 1;
                        #5; CLK = 1; // this shouldn't be here but oh well it's just a prototype
                        #0; LD_PC = 0;
                        #5; CLK = 0;
                    end
            end else if (IR[7:0] == 8'b01110110) begin
                HALTED = 1;
            end
        end
        
        // HALT NOP loop
        while (1==1) begin
           #5; CLK = 1;
           #5; CLK = 0;
        end
    end

endmodule
