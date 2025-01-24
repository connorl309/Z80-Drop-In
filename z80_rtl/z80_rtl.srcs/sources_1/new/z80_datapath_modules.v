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
            default: out <= 0;
        endcase
    end
endmodule

module mux_3(
    input [15:0] in0, in1, in2,
    input [1:0] sel,
    output reg [15:0] out
    );
    
    always @(*) begin
        case (sel)
            0: out <= in0;
            1: out <= in1;
            2: out <= in2;
            default: out <= 0;
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
            default: out <= 0;
        endcase
    end
endmodule
