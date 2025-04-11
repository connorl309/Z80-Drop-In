`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2025 11:12:43 PM
// Design Name: 
// Module Name: double_edger_mdr
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


module double_edger_mdr(
    input CLK,
    input RESET,
    input [15:0] MDR_MUX,
    input [7:0] D,
    input LD_MDR_RE,
    input LD_MDRL_FE,
    input LD_MDRH_FE,
    output reg [15:0] OUT_OUTWARD,
    output reg [15:0] OUT
    );
    
    initial begin
        OUT_OUTWARD <= 0;
        OUT <= 0;
    end
    
    always @(posedge CLK) begin
        if (!RESET) begin
            OUT_OUTWARD <= 0;
        end else begin
            if (LD_MDR_RE) begin
                OUT_OUTWARD <= MDR_MUX;
            end
        end
    end
    
    always @(negedge CLK) begin
        if (!RESET) begin
            OUT <= 0;
        end else begin
            if (LD_MDRL_FE) begin
                OUT[7:0] <= D;
            end else if (LD_MDRH_FE) begin
                OUT[15:8] <= D;
            end
        end
    end
endmodule
