`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/22/2024 04:25:13 PM
// Design Name: 
// Module Name: z80_RegisterFile
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


module reg_file(
    
    input CLK,
    input [3:0] SR1,
    input [3:0] SR2,
    input [3:0] DR,
    input [15:0] REG_IN,
    input LD_REG, //writes data from data bus   
    input EXTOGGLE_DEHL, //should be high during EX instruction execution (for register renaming), toggles DE HL latch if high
    input EXXTOGGLE, //should be high during EXX instruction execution
    output reg [15:0] SR1_OUT,
    output reg [15:0] SR2_OUT
    );
    
    localparam REG_B = 0;
    localparam REG_C = 1;
    localparam REG_D = 2;
    localparam REG_E = 3;
    localparam REG_H = 4;
    localparam REG_L = 5;
    localparam REG_W = 6;
    localparam REG_Z = 7;
    localparam REG_BC = 8;
    localparam REG_DE = 9;
    localparam REG_HL = 10;
    localparam REG_SP = 11;
    localparam REG_IX = 12;
    localparam REG_IY = 13;
    
    reg [7:0] B = 0; reg [7:0] Bp = 0;
    reg [7:0] C = 0; reg [7:0] Cp = 0;
    reg [7:0] D = 0; reg [7:0] Dp = 0;
    reg [7:0] E = 0; reg [7:0] Ep = 0;
    reg [7:0] H = 0; reg [7:0] Hp = 0;
    reg [7:0] L = 0; reg [7:0] Lp = 0;
    reg [7:0] W = 0;
    reg [7:0] Z = 0;
    
    reg [15:0] SP = 0;
    reg [15:0] IX = 0;
    reg [15:0] IY = 0;
    
    always @(*) begin
        case (SR1)
            REG_B:      SR1_OUT <= {8'b0, B};
            REG_C:      SR1_OUT <= {8'b0, C};
            REG_D:      SR1_OUT <= {8'b0, D};
            REG_E:      SR1_OUT <= {8'b0, E};
            REG_H:      SR1_OUT <= {8'b0, H};
            REG_L:      SR1_OUT <= {8'b0, L};
            REG_W:      SR1_OUT <= {8'b0, W};
            REG_Z:      SR1_OUT <= {8'b0, Z};
            REG_BC:     SR1_OUT <= {B, C}; 
            REG_DE:     SR1_OUT <= {D, E};  
            REG_HL:     SR1_OUT <= {H, L}; 
            REG_SP:     SR1_OUT <= SP; 
            REG_IX:     SR1_OUT <= IX; 
            REG_IY:     SR1_OUT <= IY; 
            default:    SR1_OUT <= 0;
        endcase
        
        case (SR2)
            REG_B:      SR2_OUT <= {8'b0, B};
            REG_C:      SR2_OUT <= {8'b0, C};
            REG_D:      SR2_OUT <= {8'b0, D};
            REG_E:      SR2_OUT <= {8'b0, E};
            REG_H:      SR2_OUT <= {8'b0, H};
            REG_L:      SR2_OUT <= {8'b0, L};
            REG_W:      SR2_OUT <= {8'b0, W};
            REG_Z:      SR2_OUT <= {8'b0, Z};
            REG_BC:     SR2_OUT <= {B, C}; 
            REG_DE:     SR2_OUT <= {D, E};  
            REG_HL:     SR2_OUT <= {H, L}; 
            REG_SP:     SR2_OUT <= SP; 
            REG_IX:     SR2_OUT <= IX; 
            REG_IY:     SR2_OUT <= IY; 
            default:    SR2_OUT <= 0;
        endcase
    end
        
    always @(posedge CLK) begin
           
        if (LD_REG) begin 
            case (DR)
                REG_B:          B <= REG_IN[7:0];
                REG_C:          C <= REG_IN[7:0];
                REG_D:          D <= REG_IN[7:0];
                REG_E:          E <= REG_IN[7:0];
                REG_H:          H <= REG_IN[7:0];
                REG_L:          L <= REG_IN[7:0];
                REG_W:          W <= REG_IN[7:0];
                REG_Z:          Z <= REG_IN[7:0];
                REG_BC: begin   B <= REG_IN[15:8]; C <= REG_IN[7:0]; end
                REG_DE: begin   D <= REG_IN[15:8]; E <= REG_IN[7:0]; end
                REG_HL: begin   H <= REG_IN[15:8]; L <= REG_IN[7:0]; end
                REG_SP:         SP <= REG_IN[15:0]; 
                REG_IX:         IX <= REG_IN[15:0];
                REG_IY:         IY <= REG_IN[15:0];
            endcase
        end
        
        
        
        if (EXTOGGLE_DEHL) begin
            H <= D;
            L <= E;
            D <= H;
            E <= L;
        end else if (EXXTOGGLE) begin
            B <= Bp;
            C <= Cp;
            D <= Dp;
            E <= Ep;
            H <= Hp;
            L <= Lp;
        end
    end 


endmodule
