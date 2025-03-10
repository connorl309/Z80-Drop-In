`timescale 1ns / 1ps
`include "z80_defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/23/2025 09:46:03 PM
// Design Name: 
// Module Name: z80_datapath_modules
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

module ff_8(
    input CLK,
    input RESET,
    input CE,
    input [7:0] D,
    output reg [7:0] Q
);

    always @(posedge CLK, negedge RESET) begin
        if (!RESET) begin
            Q <= 8'b0;
        end else begin
            Q <= CE ? D : Q;
        end
    end

endmodule

module ff_16(
    input CLK,
    input RESET,
    input CE,
    input [15:0] D,
    output reg [15:0] Q
);

    always @(posedge CLK, negedge RESET) begin
        if (!RESET) begin
            Q <= 16'b0;
        end else begin
            Q <= CE ? D : Q;
        end
    end

endmodule

module pc_bypass(
    input [2:0] sel,
    input INC_PC,
    input LD_PC,
    input jump_pc,
    output [2:0] sel_out,
    output LD_PC_NEW
);

    assign sel_out = (LD_PC || jump_pc) ? sel : `PCMUX_INC_PC;
    assign LD_PC_NEW = LD_PC || INC_PC;

endmodule

module shift_3(
    input [2:0] in,
    output [15:0] shifted
);

    assign shifted = {8'b0, 2'b0, in, 3'b0};

endmodule

module mux_16(
    input [15:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15,
    input [3:0] sel,
    output reg [15:0] mux_out
    );
    
    always @(*) begin
        case (sel)
            0: mux_out <= in0;
            1: mux_out <= in1;
            2: mux_out <= in2;
            3: mux_out <= in3;
            4: mux_out <= in4;
            5: mux_out <= in5;
            6: mux_out <= in6;
            7: mux_out <= in7;
            8: mux_out <= in8;
            9: mux_out <= in9;
            10: mux_out <= in10;
            11: mux_out <= in11;
            12: mux_out <= in12;
            13: mux_out <= in13;
            14: mux_out <= in14;
            15: mux_out <= in15;
        endcase
    end
endmodule

module mux_8(
    input [15:0] in0, in1, in2, in3, in4, in5, in6, in7,
    input [2:0] sel,
    output reg [15:0] mux_out
    );
    
    always @(*) begin
        case (sel)
            0: mux_out <= in0;
            1: mux_out <= in1;
            2: mux_out <= in2;
            3: mux_out <= in3;
            4: mux_out <= in4;
            5: mux_out <= in5;
            6: mux_out <= in6;
            7: mux_out <= in7;
        endcase
    end
endmodule


module mux_4(
    input [15:0] in0, in1, in2, in3,
    input [1:0] sel,
    output reg [15:0] mux_out
    );
    
    always @(*) begin
        case (sel)
            0: mux_out <= in0;
            1: mux_out <= in1;
            2: mux_out <= in2;
            3: mux_out <= in3;
        endcase
    end
endmodule

module mux_2(
    input [15:0] in0, in1,
    input sel,
    output reg [15:0] mux_out
    );
    
    always @(*) begin
        case (sel)
            0: mux_out <= in0;
            1: mux_out <= in1;
        endcase
    end
endmodule
