`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2025 09:12:53 PM
// Design Name: 
// Module Name: flipper
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


module flipper(
    input clk,
    input reset,
    output flip_out,
    output [15:0] out16
    );
    
    reg [1:0] div = 0;
    
    assign flip_out = div[1];
    assign out16 = {16{div[1]}};
    
    always @(posedge clk) begin
        div = reset ? 0 : div + 1;
    end
endmodule
