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

    input [15:0] TEMP_IN, //information to be stored in W (15 thru 8) or Z (7 thru 0), this is just optional temporary storage for parts of an instruction    
    input [7:0] DATA_BUS_HIGH, //bits [15:8] of data bus
    input [7:0] DATA_BUS_LOW, //bits [7:0] of data bus

    input [7:0] ACC_OUT, //output from ALU containing data to be put in Accumulator register
    input [7:0] FLAG_OUT, //FLAG output from ALU
    input DD_PREFIX, //when high, IX is used in place of HL
    input FD_PREFIX, //when high, IY is used in place of HL

    input AF_SWAP, //should be high during an EX instruction that switches A for A' or F for F'. ***A AND F ARE ALWAYS SWAPPED TOGETHER***
    input DEHL_SWAP, //should be high during an EX instruction that switches DE with HL
    input DEPHLP_SWAP, //should be high during an EX instruction that switches DE' with HL'
    input EXX, //should be high during EXX instruction execution
    
    output reg [15:0] ADDR_BUS, //port directly to address bus (for (HL) and SP stuff)

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
    
    reg [7:0] RY = 0; 
    reg [7:0] RZ = 0;        
   
    reg [15:0] RP_TABLE_SELECTION; //holds a 16 bit entry from either RP1 or RP2
    reg sig_rfsh = 0;
    
    
    /*  flipflops that toggle during register exchange operations (EX, EXX)
         - AF_TOGGLE: if high, A and F are swapped to A' and F'
         - DEHL_TOGGLE: if low, DE instruction goes to DE. if high, DE instruction goes to HL and vise versa
         - DEPHLP_TOGGLE: if low, DE' goes to DE'. if low, DE' goes to HL' and vise versa
         - BIG_TOGGLE: if high, BC/DE/HL goes instead to BC'/DE'/HL' and vise versa
    */
    reg DEHL_TOGGLE = 0, DEPHLP_TOGGLE = 0, EXX_TOGGLE = 0, AF_TOGGLE = 0; 
               
            
    always @(negedge RFSH) begin 
        sig_rfsh = 1'b1;
    end
            
    //register writes 
    always @(posedge CLK) begin
    
        //flip flops for register exchanges
        AF_TOGGLE <= AF_SWAP ? ~AF_TOGGLE : AF_TOGGLE;
        EXX_TOGGLE <= EXX ? ~EXX_TOGGLE : EXX_TOGGLE;
        DEHL_TOGGLE <= DEHL_SWAP ? ~DEHL_TOGGLE : DEHL_TOGGLE;
        DEPHLP_TOGGLE <= DEPHLP_SWAP ? ~DEPHLP_TOGGLE : DEPHLP_TOGGLE;
                
                           
        if(LD_W) begin W <= TEMP_IN[15:8]; end
        if(LD_Z) begin Z <= TEMP_IN[7:0]; end
    
        //Load I w/ ALU output
        if(LD_I) begin I <= DATA_BUS_LOW; end      
    
        //R register
        if(LD_R) R <= DATA_BUS_LOW;
        if(sig_rfsh) begin //increment
            R <= (R + 1) & 7'h7F;
            sig_rfsh = 1'b0;
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
                                   
                                3: begin 
                                    if(RP_TABLE == 1) 
                                    begin 
                                        if(~AF_TOGGLE) begin A <= DATA_BUS_HIGH; F <= DATA_BUS_LOW; end
                                        else begin Ap <= DATA_BUS_HIGH; Fp <= DATA_BUS_LOW; end
                                    end
                                    
                                    else 
                                    begin 
                                        if(Gate_SP_INC) SP = SP + 1;
                                        else if(Gate_SP_DEC) SP = SP - 1;
                                        else SP <= {DATA_BUS_HIGH, DATA_BUS_LOW};                                     
                                    end 
                                end
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
                                   end  //do nothing
                                
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
                               end //do nothing
                            
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

        //reads to ADDR_BUS
        if(Gate_SP || Gate_SP_INC || Gate_SP_DEC) begin ADDR_BUS <= SP; end
       
        else if((OPCODE_Y == 3'b110) || (OPCODE_Z) == 3'b110)
        begin
            ADDR_BUS <= (!EXX_TOGGLE) ? (!DEHL_TOGGLE ? {H,L} : {D,E}) : (!DEPHLP_TOGGLE ? {Hp,Lp} : {Dp,Ep});
        end
        
        //read r[y] and r[z]
        case(OPCODE_Y)
            0: RY <= (~EXX_TOGGLE) ? B : Bp;
            1: RY <= (~EXX_TOGGLE) ? C : Cp;
            2: RY <= (~EXX_TOGGLE) ? (~DEHL_TOGGLE ? D : H) : (~DEPHLP_TOGGLE ? Dp : Hp);
            3: RY <= (~EXX_TOGGLE) ? (~DEHL_TOGGLE ? E : L) : (~DEPHLP_TOGGLE ? Ep : Lp);
            4: RY <= (~EXX_TOGGLE) ? (~DEHL_TOGGLE ? H : D) : (~DEPHLP_TOGGLE ? Hp : Dp);
            5: RY <= (~EXX_TOGGLE) ? (~DEHL_TOGGLE ? L : E) : (~DEPHLP_TOGGLE ? Lp : Ep);
            6: RY <=0; 
            7: RY <= (~EXX_TOGGLE) ? A : Ap;
        endcase
        
        case(OPCODE_Z)
            0: RZ <= (~EXX_TOGGLE) ? B : Bp;
            1: RZ <= (~EXX_TOGGLE) ? C : Cp;
            2: RZ <= (~EXX_TOGGLE) ? (~DEHL_TOGGLE ? D : H) : (~DEPHLP_TOGGLE ? Dp : Hp);
            3: RZ <= (~EXX_TOGGLE) ? (~DEHL_TOGGLE ? E : L) : (~DEPHLP_TOGGLE ? Ep : Lp);
            4: RZ <= (~EXX_TOGGLE) ? (~DEHL_TOGGLE ? H : D) : (~DEPHLP_TOGGLE ? Hp : Dp);
            5: RZ <= (~EXX_TOGGLE) ? (~DEHL_TOGGLE ? L : E) : (~DEPHLP_TOGGLE ? Lp : Ep);
            6: RZ <= 0;
            7: RZ <= (~EXX_TOGGLE) ? A : Ap;
        endcase
        
    end 

    //Register outputs to ports
    assign A_out = (AF_TOGGLE)? Ap : A;
    assign F_out = (AF_TOGGLE)? Fp : F;
    assign B_out = (EXX_TOGGLE)? Bp : B;
    assign R_out = R;
    assign I_out = I;    
    assign W_out = W;
    assign Z_out = Z;
    
    assign BC_out = (~EXX_TOGGLE)? {B, C} : {Bp, Cp};
    assign DE_out = (~EXX_TOGGLE)? (~DEHL_TOGGLE ? {D,E} : {H,L}) : (~DEPHLP_TOGGLE ? {Dp,Ep} : {Hp,Lp});
    assign HL_out = (DD_PREFIX)? IX : ((FD_PREFIX)? IY : (~EXX_TOGGLE)? (~DEHL_TOGGLE ? {H,L} : {D,E}) : (~DEPHLP_TOGGLE ? {Hp,Lp} : {Dp,Ep}));
    assign SP_out = SP;

    assign ry_out = RY;
    assign rz_out = RZ;

endmodule