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
    input [15:0] ADDR_BUS_FROM_LATCH,
    input [7:0] DATA_BUS_HIGH,
    input [7:0] DATA_BUS_LOW, //might just consolidate as DATA_BUS
    input [1:0] RD_REG_MUX, // chooses between main registers (not IX, IY, SP, PC, W, Z, I, R)
    input [2:0] WR_REG_MUX, //chooses which main register to write to
    input [1:0] RD_REG_MUX_ALU, //selects an extra 16 bits seperate from the first mux to send down ALU_2
    input REG_DOUBLE, // writing to a pair of registers, if this is low then only use the low 8 bits of incoming bus

    input WR_DATA_BUS, //writes data from data bus    
    input LD_FROM_REGBUS, //allows the general purpose register set to access the internal regfile bus 
                           //when high, data from the internal reg bus (coming from the incrementer/latch) can be written to general registers
       
    input GATE_REGBUS, //puts output of RegOut_Mux onto internal register file (to go to inc/dec latch)
    input LD_W, //load W with operand
    input LD_Z, //load Z with operand

    input [1:0] RD_SPECIAL, //used to access IX, IY, SP
    input [1:0] WR_SPECIAL, // 00-NONE, 01-IX, 10-IY, 11-SP

    input EXTOGGLE_DEHL, //should be high during EX instruction execution (for register renaming), toggles DE HL latch if high
    input EXTOGGLE_DEPHLP, //toggles DE' HL' latch if high
    input EXXTOGGLE, //should be high during EXX instruction execution

    output [7:0] W_DATA,
    output [7:0] Z_DATA,
    output [15:0] TO_ALU_1,
    output [15:0] TO_ALU_2,
    output [15:0] TO_DATABUS, //get rid of reg here and above
    output [15:0] TO_LATCH
    
    
    //output reg [15:0] To_AddressBus
    );
    
    reg  [7:0] W, Z,
               B,  C,  D,  E,  H,  L,
               Bp, Cp, Dp, Ep, Hp, Lp; 
    
    reg [15:0] IX, IY, SP;
    
    wire [15:0] REG_BUS_INTERNAL_IN;
    reg [15:0] REG_BUS_INTERNAL_OUT;
    reg [15:0] REG_MUX_OUT, ALU_MUX_OUT;
    
    // flipflops that toggle during register exchange operations (EX, EXX)
    /*
        DEHL_TOGGLE: if low, DE instruction goes to DE. if high, DE instruction goes to HL
        DEPHLP_TOGGLE: if low, DE' goes to DE'. if low, DE' goes to HL'
        BIG_TOGGLE: if high, BC/DE/HL goes instead to BC'/DE'/HL'  
       
    */
    reg DEHL_TOGGLE = 0, DEPHLP_TOGGLE = 0, BIG_TOGGLE = 0; 
    assign REG_BUS_INTERNAL_IN = ADDR_BUS_FROM_LATCH;
    
        
    //register writes 
    always @(posedge CLK) begin
           
        if (WR_DATA_BUS) begin //write to register from databus
          //general flow: BIG toggle -> DEHL or DEpHLp toggle, AF/AF' are not handled in the register file
          if (!BIG_TOGGLE) begin
            if (!DEHL_TOGGLE) begin
              //0 0 
                case (WR_REG_MUX)       
                    0: B <= (REG_DOUBLE) ? DATA_BUS_HIGH : DATA_BUS_LOW;
                    1: C <= DATA_BUS_LOW;
                    2: D <= (REG_DOUBLE) ? DATA_BUS_HIGH : DATA_BUS_LOW;
                    3: E <= DATA_BUS_LOW;
                    4: H <= (REG_DOUBLE) ? DATA_BUS_HIGH : DATA_BUS_LOW;
                    5: L <= DATA_BUS_LOW;
                endcase               
            end             
            else begin //DEHL_TOGGLE is high, swap DE and HL
               // 0 1
              case (WR_REG_MUX)       
                 0: B <= (REG_DOUBLE) ? DATA_BUS_HIGH : DATA_BUS_LOW;
                 1: C <= DATA_BUS_LOW;
                 2: H <= (REG_DOUBLE) ? DATA_BUS_HIGH : DATA_BUS_LOW;
                 3: L <= DATA_BUS_LOW;
                 4: D <= (REG_DOUBLE) ? DATA_BUS_HIGH : DATA_BUS_LOW;
                 5: E <= DATA_BUS_LOW;
              endcase                              
            end           
          end            
          else begin //BIG_TOGGLE is high, swap BC/DE/HL for their primes
            if (!DEPHLP_TOGGLE) begin
                // 1 0

                case (WR_REG_MUX)
                    0: Bp <= (REG_DOUBLE) ? DATA_BUS_HIGH : DATA_BUS_LOW;
                    1: Cp <= DATA_BUS_LOW;
                    2: Dp <= (REG_DOUBLE) ? DATA_BUS_HIGH : DATA_BUS_LOW;
                    3: Ep <= DATA_BUS_LOW;
                    4: Hp <= (REG_DOUBLE) ? DATA_BUS_HIGH : DATA_BUS_LOW;
                    5: Lp <= DATA_BUS_LOW;
                endcase                      
            end            
            else begin //swap between DEp and HLp
                // 1 1
                case (WR_REG_MUX)
                    0: Bp <= (REG_DOUBLE) ? DATA_BUS_HIGH : DATA_BUS_LOW;
                    1: Cp <= DATA_BUS_LOW;
                    2: Hp <= (REG_DOUBLE) ? DATA_BUS_HIGH : DATA_BUS_LOW;
                    3: Lp <= DATA_BUS_LOW;
                    4: Dp <= (REG_DOUBLE) ? DATA_BUS_HIGH : DATA_BUS_LOW;
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
                        0: B <= (REG_DOUBLE) ? REG_BUS_INTERNAL_IN[15:8] : REG_BUS_INTERNAL_IN[7:0];
                        1: C <= REG_BUS_INTERNAL_IN[7:0];
                        2: D <= (REG_DOUBLE) ? REG_BUS_INTERNAL_IN[15:8] : REG_BUS_INTERNAL_IN[7:0];
                        3: E <= REG_BUS_INTERNAL_IN[7:0];
                        4: H <= (REG_DOUBLE) ? REG_BUS_INTERNAL_IN[15:8] : REG_BUS_INTERNAL_IN[7:0];
                        5: L <= REG_BUS_INTERNAL_IN[7:0];
                endcase
            end
             
            else begin //DEHL_TOGGLE is high, swap DE and HL
               // 0 1
                 case (WR_REG_MUX)       
                        0: B <= (REG_DOUBLE) ? REG_BUS_INTERNAL_IN[15:8] : REG_BUS_INTERNAL_IN[7:0];
                        1: C <= REG_BUS_INTERNAL_IN[7:0];
                        2: H <= (REG_DOUBLE) ? REG_BUS_INTERNAL_IN[15:8] : REG_BUS_INTERNAL_IN[7:0];
                        3: L <= REG_BUS_INTERNAL_IN[7:0];
                        4: D <= (REG_DOUBLE) ? REG_BUS_INTERNAL_IN[15:8] : REG_BUS_INTERNAL_IN[7:0];
                        5: E <= REG_BUS_INTERNAL_IN[7:0];
                 endcase     
            end           
          end
          
          else begin //BIG_TOGGLE is high, swap BC/DE/HL for their primes
            if (!DEPHLP_TOGGLE) begin
                // 1 0
                case (WR_REG_MUX)
                    0: Bp <= (REG_DOUBLE) ? REG_BUS_INTERNAL_IN[15:8] : REG_BUS_INTERNAL_IN[7:0];
                    1: Cp <= REG_BUS_INTERNAL_IN[7:0];
                    2: Dp <= (REG_DOUBLE) ? REG_BUS_INTERNAL_IN[15:8] : REG_BUS_INTERNAL_IN[7:0];
                    3: Ep <= REG_BUS_INTERNAL_IN[7:0];
                    4: Hp <= (REG_DOUBLE) ? REG_BUS_INTERNAL_IN[15:8] : REG_BUS_INTERNAL_IN[7:0];
                    5: Lp <= REG_BUS_INTERNAL_IN[7:0];
                endcase
            end
            
            else begin //swap between DEp and HLp
                // 1 1
                case (WR_REG_MUX)
                    0: Bp <= (REG_DOUBLE) ? REG_BUS_INTERNAL_IN[15:8] : REG_BUS_INTERNAL_IN[7:0];
                    1: Cp <= REG_BUS_INTERNAL_IN[7:0];
                    2: Hp <= (REG_DOUBLE) ? REG_BUS_INTERNAL_IN[15:8] : REG_BUS_INTERNAL_IN[7:0];
                    3: Lp <= REG_BUS_INTERNAL_IN[7:0];
                    4: Dp <= (REG_DOUBLE) ? REG_BUS_INTERNAL_IN[15:8] : REG_BUS_INTERNAL_IN[7:0];
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
        case({RD_SPECIAL, RD_REG_MUX})
            0: REG_MUX_OUT = BIG_TOGGLE ? {Bp,Cp} : {B,C};
            1: REG_MUX_OUT = BIG_TOGGLE ? (DEPHLP_TOGGLE ? {Hp,Lp} : {Dp, Ep}) : (DEHL_TOGGLE ? {H,L} : {D,E});                                                 
            2: REG_MUX_OUT = BIG_TOGGLE ? (DEPHLP_TOGGLE ? {Dp,Ep} : {Hp,Lp}) : (DEHL_TOGGLE ? {D,E} : {H,L});  
            4: REG_MUX_OUT = IX; // 01 00
            8: REG_MUX_OUT = IY; // 10 00
            12: REG_MUX_OUT = SP;// 11 00
        endcase

               
        //output is TO_ALU_2, ALU_2 cannot read from SP, IX, or IY
        case(RD_REG_MUX_ALU) 
            0: ALU_MUX_OUT = BIG_TOGGLE ? {Bp,Cp} : {B,C};            
            1: ALU_MUX_OUT = BIG_TOGGLE ? (DEPHLP_TOGGLE ? {Hp,Lp} : {Dp, Ep}) : (DEHL_TOGGLE ? {H,L} : {D,E});                                               
            2: ALU_MUX_OUT = BIG_TOGGLE ? (DEPHLP_TOGGLE ? {Dp,Ep} : {Hp,Lp}) : (DEHL_TOGGLE ? {D,E} : {H,L}); 
        endcase

        if(GATE_REGBUS) begin REG_BUS_INTERNAL_OUT <= REG_MUX_OUT; end
  
    end

    //if(GATE_DATABUS) begin TO_DATABUS <= REG_MUX_OUT; end
    assign TO_DATABUS = REG_MUX_OUT;
    
    assign TO_ALU_1 = REG_MUX_OUT;
    assign TO_ALU_2 = ALU_MUX_OUT;

    assign W_DATA = W; 
    assign Z_DATA = Z;

    assign TO_LATCH = REG_BUS_INTERNAL_OUT;    


endmodule
