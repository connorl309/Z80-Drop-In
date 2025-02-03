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


    input DR_MUX [2:0], //chooses between r[y], r[z] of opcode, HL, BC, DE, SP, and B as DR
    input IR_COPY [7:0],
    input LD_REG, //loads destination register
    input RP_TABLE, //chooses between RP1 and RP2 for loads
    
    
    input CLK,
    input [15:0] LATCH_BUS,
    input [7:0] DATA_BUS_HIGH,
    input [7:0] DATA_BUS_LOW,
    
    input [2:0] RD_REG_MUX, // chooses between main registers (not IX, IY, SP)
    input RD_16, //if high, a pair of registers is read using the 2 MSBs of RD_REG_MUX
    input [2:0] WR_REG_MUX, //chooses which main register to write to   
    input REG_DOUBLE, // writing to a pair of registers, if this is low then only use the low 8 bits of incoming bus
    input WR_DATA_BUS, //writes data from data bus    
    input LD_FROM_REGBUS, //when high, data from the internal reg bus (coming from the incrementer/latch) can be written to general registers                   
    input [1:0] RD_SPECIAL, //used to access IX, IY, SP
    input [1:0] WR_SPECIAL, // 00-NONE, 01-IX, 10-IY, 11-SP     
       
    input GATE_REGBUS, //puts output of RegOut_Mux onto internal register file (to go to inc/dec latch)
    input LD_W, //load W with operand
    input LD_Z, //load Z with operand

    input EXTOGGLE_DEHL, //should be high during EX instruction execution (for register renaming), toggles DE HL latch if high
    input EXTOGGLE_DEPHLP, //toggles DE' HL' latch if high
    input EXXTOGGLE, //should be high during EXX instruction execution

    output [7:0] W_DATA,
    output [7:0] Z_DATA,
    output [15:0] TO_ALU,
    output [15:0] TO_DATABUS, //get rid of reg here and above
    output [15:0] TO_LATCH,
    output [15:0] SPECIAL_REG_OUT
    
    
    //output [15:0] TO_ALU_2,
    //input [1:0] RD_REG_MUX_ALU, //selects an extra 16 bits seperate from the first mux to send down ALU_2
    //output reg [15:0] To_AddressBus
    );
    
    reg  [7:0] W, Z,
               B,  C,  D,  E,  H,  L,
               Bp, Cp, Dp, Ep, Hp, Lp; 
    
    reg [15:0] IX, IY, SP;
    
    wire [15:0] REG_BUS_INTERNAL_IN;
    reg [15:0] REG_BUS_INTERNAL_OUT;
    reg [15:0] REG_MUX_OUT;// ALU_MUX_OUT;
    reg [15:0] SPECIAL_REG_OUT_T;

    
    // flipflops that toggle during register exchange operations (EX, EXX)
    /*
        DEHL_TOGGLE: if low, DE instruction goes to DE. if high, DE instruction goes to HL
        DEPHLP_TOGGLE: if low, DE' goes to DE'. if low, DE' goes to HL'
        BIG_TOGGLE: if high, BC/DE/HL goes instead to BC'/DE'/HL'  
       
    */
    reg DEHL_TOGGLE = 0, DEPHLP_TOGGLE = 0, BIG_TOGGLE = 0; 
    assign REG_BUS_INTERNAL_IN = LATCH_BUS;
        
    //register writes 
    always @(posedge CLK) begin
           
        if (WR_DATA_BUS) begin //write to register from databus
          //general flow: BIG toggle -> DEHL or DEpHLp toggle, AF/AF' are not handled in the register file
          if (!BIG_TOGGLE) begin
            if (!DEHL_TOGGLE) begin
              //0 0 
                case (WR_REG_MUX)       
                    0: begin if(REG_DOUBLE) begin B <= DATA_BUS_HIGH; C <= DATA_BUS_LOW; end
                             else begin B <= DATA_BUS_LOW; end end
                    1: C <= DATA_BUS_LOW;
                    2: begin if(REG_DOUBLE) begin D <= DATA_BUS_HIGH; E <= DATA_BUS_LOW; end
                             else begin D <= DATA_BUS_LOW; end end
                    3: E <= DATA_BUS_LOW;
                    4: begin if(REG_DOUBLE) begin H <= DATA_BUS_HIGH; L <= DATA_BUS_LOW; end
                             else begin H <= DATA_BUS_LOW; end end
                    5: L <= DATA_BUS_LOW;
                endcase                     
            end             
            else begin //DEHL_TOGGLE is high, swap DE and HL
               // 0 1
              case (WR_REG_MUX)       
                    0: begin if(REG_DOUBLE) begin B <= DATA_BUS_HIGH; C <= DATA_BUS_LOW; end
                             else begin B <= DATA_BUS_LOW; end end
                    1: C <= DATA_BUS_LOW;
                    2: begin if(REG_DOUBLE) begin H <= DATA_BUS_HIGH; L <= DATA_BUS_LOW; end
                             else begin H <= DATA_BUS_LOW; end end
                    3: L <= DATA_BUS_LOW;
                    4: begin if(REG_DOUBLE) begin D <= DATA_BUS_HIGH; E <= DATA_BUS_LOW; end
                             else begin D <= DATA_BUS_LOW; end end
                    5: E <= DATA_BUS_LOW;
              endcase                              
            end           
          end            
          else begin //BIG_TOGGLE is high, swap BC/DE/HL for their primes
            if (!DEPHLP_TOGGLE) begin
                // 1 0

                case (WR_REG_MUX)
                    0: begin if(REG_DOUBLE) begin Bp <= DATA_BUS_HIGH; Cp <= DATA_BUS_LOW; end
                             else begin Bp <= DATA_BUS_LOW; end end
                    1: Cp <= DATA_BUS_LOW;
                    2: begin if(REG_DOUBLE) begin Dp <= DATA_BUS_HIGH; Ep <= DATA_BUS_LOW; end
                             else begin Dp <= DATA_BUS_LOW; end end
                    3: Ep <= DATA_BUS_LOW;
                    4: begin if(REG_DOUBLE) begin Hp <= DATA_BUS_HIGH; Lp <= DATA_BUS_LOW; end
                             else begin Hp <= DATA_BUS_LOW; end end
                    5: Lp <= DATA_BUS_LOW;
                    
                endcase                      
            end            
            else begin //swap between DEp and HLp
                // 1 1
                case (WR_REG_MUX)
                    0: begin if(REG_DOUBLE) begin Bp <= DATA_BUS_HIGH; Cp <= DATA_BUS_LOW; end
                             else begin Bp <= DATA_BUS_LOW; end end
                    1: Cp <= DATA_BUS_LOW;
                    2: begin if(REG_DOUBLE) begin Hp <= DATA_BUS_HIGH; Lp <= DATA_BUS_LOW; end
                             else begin Hp <= DATA_BUS_LOW; end end
                    3: Lp <= DATA_BUS_LOW;
                    4: begin if(REG_DOUBLE) begin Dp <= DATA_BUS_HIGH; Ep <= DATA_BUS_LOW; end
                             else begin Dp <= DATA_BUS_LOW; end end
                    5: Ep <= DATA_BUS_LOW;
                endcase                                    
            end
          end     
                            
          case(WR_SPECIAL)
            1: IX <= {DATA_BUS_HIGH, DATA_BUS_LOW};
            2: IY <= {DATA_BUS_HIGH, DATA_BUS_LOW};
            3: SP <= {DATA_BUS_HIGH, DATA_BUS_LOW};
          endcase
              
        end
          
        else if(LD_FROM_REGBUS) begin
          
          if (!BIG_TOGGLE) begin
            if (!DEHL_TOGGLE) begin
              //0 0 
                case (WR_REG_MUX)       
                    0: begin if(REG_DOUBLE) begin B <= REG_BUS_INTERNAL_IN[15:8]; C <= REG_BUS_INTERNAL_IN[7:0]; end
                             else begin B <= REG_BUS_INTERNAL_IN[7:0]; end end
                    1: C <= REG_BUS_INTERNAL_IN[7:0];
                    2: begin if(REG_DOUBLE) begin D <= REG_BUS_INTERNAL_IN[15:8]; E <= REG_BUS_INTERNAL_IN[7:0]; end
                             else begin D <= REG_BUS_INTERNAL_IN[7:0]; end end
                    3: E <= REG_BUS_INTERNAL_IN[7:0];
                    4: begin if(REG_DOUBLE) begin H <= REG_BUS_INTERNAL_IN[15:8]; L <= REG_BUS_INTERNAL_IN[7:0]; end
                             else begin H <= REG_BUS_INTERNAL_IN[7:0]; end end
                    5: L <= REG_BUS_INTERNAL_IN[7:0];
                endcase
            end
             
            else begin //DEHL_TOGGLE is high, swap DE and HL
               // 0 1
                 case (WR_REG_MUX)       
                    0: begin if(REG_DOUBLE) begin B <= REG_BUS_INTERNAL_IN[15:8]; C <= REG_BUS_INTERNAL_IN[7:0]; end
                             else begin B <= REG_BUS_INTERNAL_IN[7:0]; end end
                    1: C <= REG_BUS_INTERNAL_IN[7:0];
                    2: begin if(REG_DOUBLE) begin H <= REG_BUS_INTERNAL_IN[15:8]; L <= REG_BUS_INTERNAL_IN[7:0]; end
                         else begin H <= REG_BUS_INTERNAL_IN[7:0]; end end
                    3: L <= REG_BUS_INTERNAL_IN[7:0];
                    4: begin if(REG_DOUBLE) begin D <= REG_BUS_INTERNAL_IN[15:8]; E <= REG_BUS_INTERNAL_IN[7:0]; end
                         else begin D <= REG_BUS_INTERNAL_IN[7:0]; end end
                    5: E <= REG_BUS_INTERNAL_IN[7:0];
                 endcase     
            end           
          end
          
          else begin //BIG_TOGGLE is high, swap BC/DE/HL for their primes
            if (!DEPHLP_TOGGLE) begin
                // 1 0
                case (WR_REG_MUX)
                    0: begin if(REG_DOUBLE) begin Bp <= REG_BUS_INTERNAL_IN[15:8]; Cp <= REG_BUS_INTERNAL_IN[7:0]; end
                             else begin Bp <= REG_BUS_INTERNAL_IN[7:0]; end end
                    1: Cp <= REG_BUS_INTERNAL_IN[7:0];
                    2: begin if(REG_DOUBLE) begin Dp <= REG_BUS_INTERNAL_IN[15:8]; Ep <= REG_BUS_INTERNAL_IN[7:0]; end
                             else begin Dp <= REG_BUS_INTERNAL_IN[7:0]; end end
                    3: Ep <= REG_BUS_INTERNAL_IN[7:0];
                    4: begin if(REG_DOUBLE) begin Hp <= REG_BUS_INTERNAL_IN[15:8]; Lp <= REG_BUS_INTERNAL_IN[7:0]; end
                             else begin Hp <= REG_BUS_INTERNAL_IN[7:0]; end end
                    5: Lp <= REG_BUS_INTERNAL_IN[7:0];
                endcase
            end
            
            else begin //swap between DEp and HLp
                // 1 1
                case (WR_REG_MUX)
                    0: begin if(REG_DOUBLE) begin Bp <= REG_BUS_INTERNAL_IN[15:8]; Cp <= REG_BUS_INTERNAL_IN[7:0]; end
                             else begin Bp <= REG_BUS_INTERNAL_IN[7:0]; end end
                    1: Cp <= REG_BUS_INTERNAL_IN[7:0];
                    2: begin if(REG_DOUBLE) begin Hp <= REG_BUS_INTERNAL_IN[15:8]; Lp <= REG_BUS_INTERNAL_IN[7:0]; end
                             else begin Hp <= REG_BUS_INTERNAL_IN[7:0]; end end
                    3: Lp <= REG_BUS_INTERNAL_IN[7:0];
                    4: begin if(REG_DOUBLE) begin Dp <= REG_BUS_INTERNAL_IN[15:8]; Ep <= REG_BUS_INTERNAL_IN[7:0]; end
                             else begin Dp <= REG_BUS_INTERNAL_IN[7:0]; end end
                    5: Ep <= REG_BUS_INTERNAL_IN[7:0];
                endcase
            end
          end  

          case(WR_SPECIAL)
            1: IX <= {REG_BUS_INTERNAL_IN};
            2: IY <= {REG_BUS_INTERNAL_IN};
            3: SP <= {REG_BUS_INTERNAL_IN};
          endcase
              
        end
      
//      if(LD_PC) begin PC <= REG_BUS_INTERNAL_IN; end
//      if(LD_I) begin I <= REG_BUS_INTERNAL_IN[15:8]; end 
//      if(LD_R) begin R <= REG_BUS_INTERNAL_IN[7:0]; end
      
      if(LD_W) begin W <= REG_BUS_INTERNAL_IN[15:8]; end// make sure you know where (IR) is coming from
      if(LD_Z) begin Z <= REG_BUS_INTERNAL_IN[7:0]; end
      //YOU CANNOT WRITE TO BOTH PC/IR AND GENERIC REGISTER SET AT THE SAME TIME
      //internal bus is gated between PC/IR and rest of regs so PC/IR can be updated while generic set is being read
      
      //flip flops for register exchanges
      BIG_TOGGLE <= EXXTOGGLE ? ~BIG_TOGGLE : BIG_TOGGLE;
      DEHL_TOGGLE <= EXTOGGLE_DEHL ? ~DEHL_TOGGLE : DEHL_TOGGLE;
      DEPHLP_TOGGLE <= EXTOGGLE_DEPHLP ? ~DEPHLP_TOGGLE : DEPHLP_TOGGLE;
     
    end 
    
//register reads
    
    always @(posedge CLK) begin

        //REG_MUX_OUT can go to ALU_BUS1 or DATABUS or Internal register bus depending on control signals in datapath
        if (RD_16) begin
            case(RD_REG_MUX)
                0: REG_MUX_OUT = BIG_TOGGLE ? {Bp,Cp} : {B,C};// 000
                2: REG_MUX_OUT = BIG_TOGGLE ? (DEPHLP_TOGGLE ? {Hp,Lp} : {Dp, Ep}) : (DEHL_TOGGLE ? {H,L} : {D,E});   //010                                              
                4: REG_MUX_OUT = BIG_TOGGLE ? (DEPHLP_TOGGLE ? {Dp,Ep} : {Hp,Lp}) : (DEHL_TOGGLE ? {D,E} : {H,L});  //100  
            endcase
        end
        
        else begin //read 8 bits only
            case(RD_REG_MUX)
                0:  REG_MUX_OUT = BIG_TOGGLE ? {8'b0, Bp} : {8'b0, B}; //B
                1:  REG_MUX_OUT =  BIG_TOGGLE ? {8'b0,Cp} : {8'b0,C};  //C
                2:  REG_MUX_OUT = BIG_TOGGLE ? (DEPHLP_TOGGLE ? {8'b0,Hp} : {8'b0, Dp}) : (DEHL_TOGGLE ? {8'b0,H} : {8'b0,D}); //D
                3:  REG_MUX_OUT = BIG_TOGGLE ? (DEPHLP_TOGGLE ? {8'b0,Lp} : {8'b0, Ep}) : (DEHL_TOGGLE ? {8'b0,L} : {8'b0,E}); //E      
                4:  REG_MUX_OUT = BIG_TOGGLE ? (DEPHLP_TOGGLE ? {8'b0,Dp} : {8'b0,Hp}) : (DEHL_TOGGLE ? {8'b0,D} : {8'b0,H});  //H
                5:  REG_MUX_OUT = BIG_TOGGLE ? (DEPHLP_TOGGLE ? {8'b0,Ep} : {8'b0,Lp}) : (DEHL_TOGGLE ? {8'b0,E} : {8'b0,L});  //L
            
            endcase        
        end
        
        
        case(RD_SPECIAL)
            1: SPECIAL_REG_OUT_T <= IX; // 01
            2: SPECIAL_REG_OUT_T <= IY; // 10
            3: SPECIAL_REG_OUT_T <= SP;// 11 
        endcase
        
               
//        //output is TO_ALU_2, ALU_2 cannot read from SP, IX, or IY
//        case(RD_REG_MUX_ALU) 
//            0: ALU_MUX_OUT = BIG_TOGGLE ? {Bp,Cp} : {B,C};            
//            1: ALU_MUX_OUT = BIG_TOGGLE ? (DEPHLP_TOGGLE ? {Hp,Lp} : {Dp, Ep}) : (DEHL_TOGGLE ? {H,L} : {D,E});                                               
//            2: ALU_MUX_OUT = BIG_TOGGLE ? (DEPHLP_TOGGLE ? {Dp,Ep} : {Hp,Lp}) : (DEHL_TOGGLE ? {D,E} : {H,L}); 
//        endcase

        if(GATE_REGBUS) begin REG_BUS_INTERNAL_OUT <= REG_MUX_OUT; end
  
    end

    //if(GATE_DATABUS) begin TO_DATABUS <= REG_MUX_OUT; end
    assign TO_DATABUS = REG_MUX_OUT;
    assign TO_ALU = REG_MUX_OUT;
//    assign TO_ALU_2 = ALU_MUX_OUT;
    assign W_DATA = W; 
    assign Z_DATA = Z;
    assign TO_LATCH = REG_BUS_INTERNAL_OUT;    
    assign SPECIAL_REG_OUT = SPECIAL_REG_OUT_T;

endmodule
