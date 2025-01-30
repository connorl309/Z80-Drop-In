`timescale 1ns / 1ps
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

module mux_16(
    input [15:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15,
    input [3:0] sel,
    output reg [15:0] out
    );
    
    always @(*) begin
        case (sel)
            0: out <= in0;
            1: out <= in1;
            2: out <= in2;
            3: out <= in3;
            4: out <= in4;
            5: out <= in5;
            6: out <= in6;
            7: out <= in7;
            8: out <= in8;
            9: out <= in9;
            10: out <= in10;
            11: out <= in11;
            12: out <= in12;
            13: out <= in13;
            14: out <= in14;
            15: out <= in15;
        endcase
    end
endmodule

module mux_8(
    input [15:0] in0, in1, in2, in3, in4, in5, in6, in7,
    input [2:0] sel,
    output reg [15:0] out
    );
    
    always @(*) begin
        case (sel)
            0: out <= in0;
            1: out <= in1;
            2: out <= in2;
            3: out <= in3;
            4: out <= in4;
            5: out <= in5;
            6: out <= in6;
            7: out <= in7;
        endcase
    end
endmodule


module mux_4(
    input [15:0] in0, in1, in2, in3,
    input [1:0] sel,
    output reg [15:0] out
    );
    
    always @(*) begin
        case (sel)
            0: out <= in0;
            1: out <= in1;
            2: out <= in2;
            3: out <= in3;
        endcase
    end
endmodule

module mux_2(
    input [15:0] in0, in1,
    input sel,
    output reg [15:0] out
    );
    
    always @(*) begin
        case (sel)
            0: out <= in0;
            1: out <= in1;
        endcase
    end
endmodule
