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


module z80RegisterFile(

    input CLK,
    input RFSH, //increment R register when RFSH is high
    
    input [2:0] SR1_MUX, //chooses which regsiter/reg pair to use from r/rp tables
    input [2:0] SR2_MUX, //chooses which register/reg pair to use from r/rp tables
    input RP_SR1,
    input RP_SR2,
    input [2:0] DR_MUX, //chooses between r[y], r[z] of opcode, HL, BC, DE, SP, and B as DR
    input RP_TABLE, //chooses between RP1 and RP2 for loads, RP1 if 0 and RP2 if 1
    input RP, //when set, r[y] is now RP[p] for dr_mux (essentially just makes it a 16 bit write)        
    input LD_REG, //signals a destination register to be written to  
    input LD_ACCUM, //Should load A or A' w/ result of ALU arith/logic operations
    input LD_FLAG, //Should load register F or F'
    input LD_I, //should load I during posedge of clock cycle
    input LD_R, //should load R
    input LD_W, //load W with part of instruction (temporary storage)
    input LD_Z, //load Z with part of isntruction (temporary storage)
    input Gate_SP, //puts SP on ADDR_BUS
    input Gate_SP_INC, //puts SP + 1 into SP then puts it onto ADDR_BUS 
    input Gate_SP_DEC, //puts SP - 1 into SP then puts it onto ADDR_BUS
    input [2:0] OPCODE_Y, //this is just bits [5:3] of the current opcode
    input [2:0] OPCODE_Z, //this is [2:0] of the current opcode
    
    input [15:0] LATCH_BUS,
    input [7:0] DATA_BUS_HIGH, //bits [15:8] of data bus
    input [7:0] DATA_BUS_LOW, //bits [7:0] of data bus

    input [15:0] ALU_OUT, //output from ALU to reg file and other blocks
    input [7:0] ACC_OUT, //output from ALU containing data to be put in Accumulator register
    input [7:0] FLAG_OUT, //FLAG output from ALU
    input DD_PREFIX, //when high, IX is used in place of HL
    input FD_PREFIX, //when high, IY is used in place of HL

    input AF_SWAP, //should be high during an EX instruction that switches A for A' or F for F'. ***A AND F ARE ALWAYS SWAPPED TOGETHER***
    input DEHL_SWAP, //should be high during an EX instruction that switches DE with HL
    input DEPHLP_SWAP, //should be high during an EX instruction that switches DE' with HL'
    input EXX, //should be high during EXX instruction execution

    output reg [15:0] TO_ALUA_MUX, //SR2 out, port to ALUA MUX
    output reg [15:0] TO_ALUB_MUX, //SR1 out, port to ALUB MUX / MARMUX (I'm following the drawio datapath diagram)
    output reg [15:0] TO_LATCH, //idk
    output reg [15:0] ADDR_BUS, //port directly to address bus (for (HL) stuff)

    //Separate register read ports    
    output [15:0] BC_out,
    output [15:0] DE_out,
    output [15:0] HL_out,
    output [15:0] SP_out,
    output [7:0] ry_out, 
    output [7:0] rz_out,
    output [7:0] B_out,
    output [7:0] R_out,
    output [7:0] I_out,
    output [7:0] W_out,
    output [7:0] Z_out,
    output [7:0] F_out,
    output [7:0] A_out
    
    );
      
    reg  [7:0] W = 0; 
    reg  [7:0] Z = 0;    
    reg  [7:0] I = 0;
    reg  [7:0] R = 0;  
    
    reg  [7:0] A = 0;
    reg  [7:0] F = 0;   
    reg  [7:0] B = 0; 
    reg  [7:0] C = 0; 
    reg  [7:0] D = 0;
    reg  [7:0] E = 0; 
    reg  [7:0] H = 0;  
    reg  [7:0] L = 0;

    reg  [7:0] Ap = 0;
    reg  [7:0] Fp = 0;
    reg  [7:0] Bp = 0;
    reg  [7:0] Cp = 0; 
    reg  [7:0] Dp = 0;
    reg  [7:0] Ep = 0; 
    reg  [7:0] Hp = 0;  
    reg  [7:0] Lp = 0;
    
    reg [15:0] IX = 0;
    reg [15:0] IY = 0;
    reg [15:0] SP = 0;
        
   
    reg [15:0] RP_TABLE_SELECTION; //holds a 16 bit entry from either RP1 or RP2
    wire [15:0] REG_BUS_INTERNAL_IN;
    reg [15:0] REG_BUS_INTERNAL_OUT;
    reg [15:0] REG_MUX_OUT;// ALU_MUX_OUT;
    reg [15:0] SPECIAL_REG_OUT_T;
    
    /*  flipflops that toggle during register exchange operations (EX, EXX)
         - AF_TOGGLE: if high, A and F are swapped to A' and F'
         - DEHL_TOGGLE: if low, DE instruction goes to DE. if high, DE instruction goes to HL and vise versa
         - DEPHLP_TOGGLE: if low, DE' goes to DE'. if low, DE' goes to HL' and vise versa
         - BIG_TOGGLE: if high, BC/DE/HL goes instead to BC'/DE'/HL' and vise versa
    */
    reg DEHL_TOGGLE = 0, DEPHLP_TOGGLE = 0, EXX_TOGGLE = 0, AF_TOGGLE = 0; 
    
    
    assign REG_BUS_INTERNAL_IN = LATCH_BUS;    
   
            
    //register writes 
    always @(posedge CLK) begin
    
        //flip flops for register exchanges
        AF_TOGGLE <= AF_SWAP ? ~AF_TOGGLE : AF_TOGGLE;
        EXX_TOGGLE <= EXX ? ~EXX_TOGGLE : EXX_TOGGLE;
        DEHL_TOGGLE <= DEHL_SWAP ? ~DEHL_TOGGLE : DEHL_TOGGLE;
        DEPHLP_TOGGLE <= DEPHLP_SWAP ? ~DEPHLP_TOGGLE : DEPHLP_TOGGLE;
                
                           
        if(LD_W) begin W <= REG_BUS_INTERNAL_IN[15:8]; end// make sure you know where (IR) is coming from
        if(LD_Z) begin Z <= REG_BUS_INTERNAL_IN[7:0]; end
    
        //Load I w/ ALU output
        if(LD_I) begin I <= DATA_BUS_LOW; end      
    
        //R register
        if(LD_R) R <= DATA_BUS_LOW;
        if(RFSH) begin //increment
            R <= (R + 1) & 7'h7F;
        end
        
        //put data from ALU in register A
        if(LD_ACCUM) begin
            if(AF_SWAP) begin Ap <= ACC_OUT; end
            else begin A <= ACC_OUT; end
        end
        
        //F register
        if(LD_FLAG) begin
            if(AF_SWAP) begin Fp <= FLAG_OUT; end
            else begin F <= FLAG_OUT; end
        end
        
        if(LD_REG) begin      
           //DESTINATION REGISTER WRITES
            case (DR_MUX)
                0: begin //DR_MUX_DR
                        if(RP) begin //use RP instead of r[y] 
                            case(OPCODE_Y >> 1)
                                0: begin 
                                        if(EXX_TOGGLE) begin Bp <= DATA_BUS_HIGH; Cp <= DATA_BUS_LOW; end
                                        else begin B <= DATA_BUS_HIGH; C <= DATA_BUS_LOW; end
                                   end
                                   
                                1: begin //DE
                                        if(!EXX_TOGGLE) begin if(!DEHL_TOGGLE) begin D <= DATA_BUS_HIGH; E <= DATA_BUS_LOW; end 
                                                                          else begin H <= DATA_BUS_HIGH; L <= DATA_BUS_LOW; end
                                        end
                                        else begin if(!DEPHLP_TOGGLE) begin Dp <= DATA_BUS_HIGH; Ep <= DATA_BUS_LOW; end
                                                                 else begin Hp <= DATA_BUS_HIGH; Lp <= DATA_BUS_LOW; end
                                        end                                        
                                   end
                                   
                                2: begin //HL
                                        if(DD_PREFIX) begin IX <= {DATA_BUS_HIGH, DATA_BUS_LOW}; end
                                        else if(FD_PREFIX) begin IY <= {DATA_BUS_HIGH,DATA_BUS_LOW}; end 
                                        else if(!EXX_TOGGLE) begin if(!DEHL_TOGGLE) begin H <= DATA_BUS_HIGH; L <= DATA_BUS_LOW; end 
                                                                          else begin D <= DATA_BUS_HIGH; E <= DATA_BUS_LOW; end
                                        end
                                        else begin if(!DEPHLP_TOGGLE) begin Hp <= DATA_BUS_HIGH; Lp <= DATA_BUS_LOW; end
                                                                 else begin Dp <= DATA_BUS_HIGH; Ep <= DATA_BUS_LOW; end
                                        end    
                                   end
                                   
                                3: begin SP <= {DATA_BUS_HIGH, DATA_BUS_LOW}; end 
                                
                            endcase                    
                        end 
                        
                        else begin
                            case(OPCODE_Y) //8 bit
                                0: begin if(!EXX_TOGGLE) begin B <= DATA_BUS_LOW; end else begin Bp <= DATA_BUS_LOW; end end
                                1: begin if(!EXX_TOGGLE) begin C <= DATA_BUS_LOW; end else begin Cp <= DATA_BUS_LOW; end end
                                
                                2: begin if(!EXX_TOGGLE) begin if(!DEHL_TOGGLE) begin D <= DATA_BUS_LOW; end else begin H <= DATA_BUS_LOW; end end
                                         else begin if(!DEPHLP_TOGGLE) begin Dp <= DATA_BUS_LOW; end else begin Hp <= DATA_BUS_LOW; end end
                                   end
                                
                                3: begin if(!EXX_TOGGLE) begin if(!DEHL_TOGGLE) begin E <= DATA_BUS_LOW; end else begin L <= DATA_BUS_LOW; end end
                                         else begin if(!DEPHLP_TOGGLE) begin Ep <= DATA_BUS_LOW; end else begin Lp <= DATA_BUS_LOW; end end
                                   end
                                   
                                4: begin if(DD_PREFIX) begin IX[15:8] <= DATA_BUS_LOW; end
                                         else if(FD_PREFIX) begin IY[15:8] <= DATA_BUS_LOW; end
                                         else if(!EXX_TOGGLE) begin if(!DEHL_TOGGLE) begin H <= DATA_BUS_LOW; end else begin D <= DATA_BUS_LOW; end end
                                         else begin if(!DEPHLP_TOGGLE) begin Hp <= DATA_BUS_LOW; end else begin Dp <= DATA_BUS_LOW; end end
                                   end
                                   
                                5: begin if(DD_PREFIX) begin IX[7:0] <= DATA_BUS_LOW; end
                                         else if(FD_PREFIX) begin IY[7:0] <= DATA_BUS_LOW; end 
                                         else if(!EXX_TOGGLE) begin if(!DEHL_TOGGLE) begin L <= DATA_BUS_LOW; end else begin E <= DATA_BUS_LOW; end end
                                         else begin if(!DEPHLP_TOGGLE) begin Lp <= DATA_BUS_LOW; end else begin Ep <= DATA_BUS_LOW; end end
                                   end
                                   
                                6: begin  
                                        ADDR_BUS <= (!EXX_TOGGLE) ? (!DEHL_TOGGLE ? {H,L} : {D,E}) : (!DEPHLP_TOGGLE ? {Hp,Lp} : {Dp,Ep});
                                   end 
                                
                                7: begin if(!AF_TOGGLE) begin A <= DATA_BUS_LOW; end else begin Ap <= DATA_BUS_LOW; end end
                                
                            endcase
                        end
                   end
                
                1: begin //r[z]
                        case(OPCODE_Z) 
                            0: begin if(!EXX_TOGGLE) begin B <= DATA_BUS_LOW; end else begin Bp <= DATA_BUS_LOW; end end
                            1: begin if(!EXX_TOGGLE) begin C <= DATA_BUS_LOW; end else begin Cp <= DATA_BUS_LOW; end end
                            
                            2: begin if(!EXX_TOGGLE) begin if(!DEHL_TOGGLE) begin D <= DATA_BUS_LOW; end else begin H <= DATA_BUS_LOW; end end
                                     else begin if(!DEPHLP_TOGGLE) begin Dp <= DATA_BUS_LOW; end else begin Hp <= DATA_BUS_LOW; end end
                               end
                            
                            3: begin if(!EXX_TOGGLE) begin if(!DEHL_TOGGLE) begin E <= DATA_BUS_LOW; end else begin L <= DATA_BUS_LOW; end end
                                     else begin if(!DEPHLP_TOGGLE) begin Ep <= DATA_BUS_LOW; end else begin Lp <= DATA_BUS_LOW; end end
                               end
                               
                            4: begin if(DD_PREFIX) begin IX[15:8] <= DATA_BUS_LOW; end
                                     else if(FD_PREFIX) begin IY[15:8] <= DATA_BUS_LOW; end
                                     else if(!EXX_TOGGLE) begin if(!DEHL_TOGGLE) begin H <= DATA_BUS_LOW; end else begin D <= DATA_BUS_LOW; end end
                                     else begin if(!DEPHLP_TOGGLE) begin Hp <= DATA_BUS_LOW; end else begin Dp <= DATA_BUS_LOW; end end
                               end
                                   
                            5: begin if(DD_PREFIX) begin IX[7:0] <= DATA_BUS_LOW; end
                                     else if(FD_PREFIX) begin IY[7:0] <= DATA_BUS_LOW; end 
                                     else if(!EXX_TOGGLE) begin if(!DEHL_TOGGLE) begin L <= DATA_BUS_LOW; end else begin E <= DATA_BUS_LOW; end end
                                     else begin if(!DEPHLP_TOGGLE) begin Lp <= DATA_BUS_LOW; end else begin Ep <= DATA_BUS_LOW; end end
                               end
                               
                            6: begin 
                                    ADDR_BUS <= (!EXX_TOGGLE) ? (!DEHL_TOGGLE ? {H,L} : {D,E}) : (!DEPHLP_TOGGLE ? {Hp,Lp} : {Dp,Ep});
                               end 
                            
                            7: begin if(!AF_TOGGLE) begin A <= DATA_BUS_LOW; end else begin Ap <= DATA_BUS_LOW; end end
                            
                        endcase          
                   end
                
                2: begin //DR_MUX_HL
                    if(DD_PREFIX) begin IX <= {DATA_BUS_HIGH, DATA_BUS_LOW}; end
                    else if(FD_PREFIX) begin IY <= {DATA_BUS_HIGH, DATA_BUS_LOW}; end 
                    else if(!EXX_TOGGLE) begin if(!DEHL_TOGGLE) 
                            begin
                                H <= DATA_BUS_HIGH;
                                L <= DATA_BUS_LOW;
                            end
                            else begin 
                                D <= DATA_BUS_HIGH;
                                E <= DATA_BUS_LOW;
                            end
                        end
                        else begin if(!DEPHLP_TOGGLE) 
                            begin 
                                Hp <= DATA_BUS_HIGH;
                                Lp <= DATA_BUS_LOW;
                            end
                            else begin
                                Dp <= DATA_BUS_HIGH;
                                Ep <= DATA_BUS_LOW;
                            end
                        end    
                   end 
                   
                3: begin //DR_MUX_BC
                     if(!EXX_TOGGLE) begin B <= DATA_BUS_HIGH; C <= DATA_BUS_LOW; end 
                     else begin Bp <= DATA_BUS_HIGH; Cp <= DATA_BUS_LOW; end
                   end
                
                4: begin //DR_MUX_DE
                        if(!EXX_TOGGLE) begin if(!DEHL_TOGGLE) 
                            begin
                                D <= DATA_BUS_HIGH;
                                E <= DATA_BUS_LOW;
                            end
                            else begin 
                                H <= DATA_BUS_HIGH;
                                L <= DATA_BUS_LOW;
                            end
                        end
                        else begin if(!DEPHLP_TOGGLE) 
                            begin 
                                Dp <= DATA_BUS_HIGH;
                                Ep <= DATA_BUS_LOW;
                            end
                            else begin
                                Hp <= DATA_BUS_HIGH;
                                Lp <= DATA_BUS_LOW;
                            end
                        end    
                   end 
                
                5: begin //DR_MUX_SP
                    SP <= {DATA_BUS_HIGH, DATA_BUS_LOW};
                   end
    
                6: begin //DR_MUX_B
                    if(!EXX_TOGGLE) begin B <= DATA_BUS_LOW; end else begin Bp <= DATA_BUS_LOW; end 
                   end
            
            endcase
        end
    end 
    
//register reads
    
    always @(negedge CLK) begin

        //SP
        if(Gate_SP) begin ADDR_BUS <= SP; end
        if(Gate_SP_INC) begin SP = SP + 1; ADDR_BUS <= SP; end
        if(Gate_SP_DEC) begin SP = SP - 1; ADDR_BUS <= SP; end
        

            if(RP_SR1) begin
                case(SR1_MUX)
                    0: begin TO_ALUB_MUX <= !EXX_TOGGLE ? {B,C} : {Bp,Cp}; end
                    1: begin TO_ALUB_MUX <= !EXX_TOGGLE ? (!DEHL_TOGGLE ? {D,E} : {H,L}) : (!DEPHLP_TOGGLE ? {Dp,Ep} : {Hp,Lp}); end
                    2: begin
                        if(DD_PREFIX) begin TO_ALUB_MUX <= IX; end
                        else if(FD_PREFIX) begin TO_ALUB_MUX <= IY; end
                        else begin TO_ALUB_MUX <= !EXX_TOGGLE ? (!DEHL_TOGGLE ? {H,L} : {D,E}) : (!DEPHLP_TOGGLE ? {Hp,Lp} : {Dp,Ep}); end end
                    3: begin TO_ALUB_MUX <= !RP_TABLE ? SP : (!AF_TOGGLE ? {A,F} : {Ap,Fp}); end
                    default: TO_ALUB_MUX <= 16'b0;
                endcase
            end
            else begin
                case(SR1_MUX)
                    0: begin TO_ALUB_MUX <= !EXX_TOGGLE ? {8'b0,B} : {8'b0,Bp}; end
                    1: begin TO_ALUB_MUX <= !EXX_TOGGLE ? {8'b0,C} : {8'b0,Cp}; end
                    2: begin TO_ALUB_MUX <= !EXX_TOGGLE ? (!DEHL_TOGGLE ? {8'b0,D} : {8'b0,H}) : (!DEPHLP_TOGGLE ? {8'b0,Dp} : {8'b0,Hp}); end
                    3: begin TO_ALUB_MUX <= !EXX_TOGGLE ? (!DEHL_TOGGLE ? {8'b0,E} : {8'b0,L}) : (!DEPHLP_TOGGLE ? {8'b0,Ep} : {8'b0,Lp}); end
                    4: begin 
                            if(DD_PREFIX) begin TO_ALUB_MUX <= {8'b0, IX[15:8]}; end
                            else if (FD_PREFIX) begin TO_ALUB_MUX <= {8'b0, IY[15:8]}; end
                            else begin TO_ALUB_MUX <= !EXX_TOGGLE ? (!DEHL_TOGGLE ? {8'b0,H} : {8'b0,D}) : (!DEPHLP_TOGGLE ? {8'b0,Hp} : {8'b0,Dp}); end
                       end
                    5: begin if(DD_PREFIX) begin TO_ALUB_MUX <= {8'b0, IX[7:0]}; end 
                            else if(FD_PREFIX) begin TO_ALUB_MUX <= {8'b0,IY[7:0]}; end
                            else begin TO_ALUB_MUX <= !EXX_TOGGLE ? (!DEHL_TOGGLE ? {8'b0,L} : {8'b0,E}) : (!DEPHLP_TOGGLE ? {8'b0,Lp} : {8'b0,Ep}); end
                       end
                    //I don't think (HL) is usable in this context
                    7: begin TO_ALUB_MUX <= !EXX_TOGGLE ? ({8'b0, A}) : ({8'b0, Ap}); end
                    default: TO_ALUB_MUX <= 16'b0;
                endcase 
            end

            if(RP_SR2) begin
                case(SR2_MUX)
                    0: begin TO_ALUA_MUX <= !EXX_TOGGLE ? {B,C} : {Bp,Cp}; end
                    1: begin TO_ALUA_MUX <= !EXX_TOGGLE ? (!DEHL_TOGGLE ? {D,E} : {H,L}) : (!DEPHLP_TOGGLE ? {Dp,Ep} : {Hp,Lp}); end
                    2: begin
                        if(DD_PREFIX) begin TO_ALUA_MUX <= IX; end
                        else if(FD_PREFIX) begin TO_ALUA_MUX <= IY; end
                        else begin TO_ALUA_MUX <= !EXX_TOGGLE ? (!DEHL_TOGGLE ? {H,L} : {D,E}) : (!DEPHLP_TOGGLE ? {Hp,Lp} : {Dp,Ep}); end end
                    3: begin TO_ALUA_MUX <= !RP_TABLE ? SP : (!AF_TOGGLE ? {A,F} : {Ap,Fp}); end
                    default: TO_ALUA_MUX <= 16'b0;
                endcase
            end
            else begin
                case(SR2_MUX)
                    0: begin TO_ALUA_MUX <= !EXX_TOGGLE ? {8'b0,B} : {8'b0,Bp}; end
                    1: begin TO_ALUA_MUX <= !EXX_TOGGLE ? {8'b0,C} : {8'b0,Cp}; end
                    2: begin TO_ALUA_MUX <= !EXX_TOGGLE ? (!DEHL_TOGGLE ? {8'b0,D} : {8'b0,H}) : (!DEPHLP_TOGGLE ? {8'b0,Dp} : {8'b0,Hp}); end
                    3: begin TO_ALUA_MUX <= !EXX_TOGGLE ? (!DEHL_TOGGLE ? {8'b0,E} : {8'b0,L}) : (!DEPHLP_TOGGLE ? {8'b0,Ep} : {8'b0,Lp}); end
                    4: begin 
                            if(DD_PREFIX) begin TO_ALUA_MUX <= {8'b0, IX[15:8]}; end
                            else if (FD_PREFIX) begin TO_ALUA_MUX <= {8'b0, IY[15:8]}; end
                            else begin TO_ALUA_MUX <= !EXX_TOGGLE ? (!DEHL_TOGGLE ? {8'b0,H} : {8'b0,D}) : (!DEPHLP_TOGGLE ? {8'b0,Hp} : {8'b0,Dp}); end
                       end
                    5: begin if(DD_PREFIX) begin TO_ALUA_MUX <= {8'b0, IX[7:0]}; end 
                            else if(FD_PREFIX) begin TO_ALUA_MUX <= {8'b0,IY[7:0]}; end
                            else begin TO_ALUA_MUX <= !EXX_TOGGLE ? (!DEHL_TOGGLE ? {8'b0,L} : {8'b0,E}) : (!DEPHLP_TOGGLE ? {8'b0,Lp} : {8'b0,Ep}); end
                       end
                    //I don't think (HL) is usable in this context
                    7: begin TO_ALUA_MUX <= !EXX_TOGGLE ? ({8'b0, A}) : ({8'b0, Ap}); end
                    default: TO_ALUA_MUX <= 16'b0;
                endcase 
            end
        
        
//        //read r(y)
//        case(OPCODE_Y)
//            0: 
//        endcase
        
//        case(OPCODE_Z)
        
//        endcase   
    end
       

    //Register outputs to ports
    assign A_out = (AF_TOGGLE)? Ap : A;
    assign F_out = (AF_TOGGLE)? Fp : F;
    assign B_out = (EXX_TOGGLE)? Bp : B;
    assign R_out = R;
    assign I_out = I;    
    
    // these should really take into account EXX
    assign BC_out = {B, C};
    assign DE_out = {D, E};
    assign HL_out = {H, L};
    assign SP_out = SP;
    //assign ry_out = ;
    //assign rz_out = ;

endmodule
