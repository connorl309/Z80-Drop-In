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
    input [2:0] REG_MUX, // chooses between main registers (not IX, IY, SP, PC, W, Z, I, R)
    input [2:0] REG_MUX_ALU, //selects an extra 16 bits seperate from the first mux to send down ALU_2
    //input REG_PRIME, // register file should use the alternate register set (i.e. D', E', ...) 
    input REG_DOUBLE, // writing to a pair of registers, if this is low then only use the low 8 bits of incoming bus
                         
    input GATE_PC, //puts PC onto internal register bus
    input GATE_I, //see above
    input GATE_R, //see above
    input LD_PC, //load PC with value on internal register bus
    input LD_I, //load I with high 8 bits of internal register bus
    input LD_R, //load R with low 8 bits of internal register bus (from incrementer)
    input WR_DATA_BUS, //enables writes to general purpose register set from the DATA bus
    input GATE_REGBUS, //allows the general purpose register set to access the internal regfile bus 
                       //when this is low, the PC, I, or R registers can be changed while general registers are being read onto other buses
                       //when high, data from the internal reg bus (probably coming from the incrementer/latch) can be written to general registers
   
    input GATE_ALU1, //1st gate to 16 bit input to ALU
    input GATE_ALU2, 
    input GATE_DATABUS, //gate to 8 bit data bus
    input RD_16, //put 16 bits from generic register set onto internal register bus
    input LD_W, //load W with operand
    input LD_Z, //load Z with operand
    input GATE_W, //output W directly to ALU
    input GATE_Z,
    input SELECT_SP,
    input SELECT_IX,
    input SELECT_IY,
    input EXTOGGLE_DEHL, //should be high during EX instruction execution (for register renaming), toggles DE HL latch if high
    input EXTOGGLE_DEPHLP, //toggles DE' HL' latch if high
    input EXTOGGLE_AF, //toggles AF AF' latch if high
    input EXXTOGGLE, //should be high during EXX instruction execution
    output reg [7:0] W_DATA,
    output reg [7:0] Z_DATA,
    output reg [15:0] TO_ALU_1,
    output reg [15:0] TO_ALU_2,
    output reg [15:0] TO_DATABUS, //get rid of reg here and above
    output [15:0] TO_LATCH
    
    //output reg [15:0] To_AddressBus
    );
    
    reg  [7:0] W, Z, I, R,
               B,  C,  D,  E,  H,  L,
               Bp, Cp, Dp, Ep, Hp, Lp; 
    
    reg [15:0] PC, IX, IY, SP;
    
    reg [15:0] REG_BUS_INTERNAL_IN, REG_BUS_INTERNAL_OUT;
    reg [15:0] REG_MUX_OUT, ALU_MUX_OUT;
    
    // flipflops that toggle during register exchange operations (EX, EXX)
    /*
        DEHL_TOGGLE: if low, DE instruction goes to DE. if high, DE instruction goes to HL
        DEPHLP_TOGGLE: if low, DE' goes to DE'. if low, DE' goes to HL'
        AFAFP_TOGGLE: AF vs AF', you get the idea    
        BIG_TOGGLE: if high, BC/DE/HL goes instead to BC'/DE'/HL'  
       
    */
    reg DEHL_TOGGLE = 0, DEPHLP_TOGGLE = 0, AFAFP_TOGGLE = 0, BIG_TOGGLE = 0; 
    
   
    //register writes 
    always @(posedge CLK) begin
    
        REG_BUS_INTERNAL_IN = ADDR_BUS_FROM_LATCH;            
        if (WR_DATA_BUS) begin //write to register from databus
          //general flow: BIG toggle -> DEHL or DEpHLp toggle, AF/AF' are not handled in the register file
          if (!BIG_TOGGLE) begin
            if (!DEHL_TOGGLE) begin
              //0 0 
                case (REG_MUX)       
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
           
             case (REG_MUX)       
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

                case (REG_MUX)
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
                case (REG_MUX)
                    0: Bp <= (REG_DOUBLE) ? DATA_BUS_HIGH : DATA_BUS_LOW;
                    1: Cp <= DATA_BUS_LOW;
                    2: Hp <= (REG_DOUBLE) ? DATA_BUS_HIGH : DATA_BUS_LOW;
                    3: Lp <= DATA_BUS_LOW;
                    4: Dp <= (REG_DOUBLE) ? DATA_BUS_HIGH : DATA_BUS_LOW;
                    5: Ep <= DATA_BUS_LOW;
                endcase                
              
            end
          end                       
                            
          if(SELECT_IX) begin IX <= {DATA_BUS_HIGH, DATA_BUS_LOW}; end
          if(SELECT_IY) begin IY <= {DATA_BUS_HIGH, DATA_BUS_LOW}; end
          if(SELECT_SP) begin SP <= {DATA_BUS_HIGH, DATA_BUS_LOW}; end
              
        end
          
        else if(GATE_REGBUS) begin
          if (!BIG_TOGGLE) begin
            if (!DEHL_TOGGLE) begin
              //0 0 
                case (REG_MUX)       
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
                 case (REG_MUX)       
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
                case (REG_MUX)
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
                case (REG_MUX)
                    0: Bp <= (REG_DOUBLE) ? REG_BUS_INTERNAL_IN[15:8] : REG_BUS_INTERNAL_IN[7:0];
                    1: Cp <= REG_BUS_INTERNAL_IN[7:0];
                    2: Hp <= (REG_DOUBLE) ? REG_BUS_INTERNAL_IN[15:8] : REG_BUS_INTERNAL_IN[7:0];
                    3: Lp <= REG_BUS_INTERNAL_IN[7:0];
                    4: Dp <= (REG_DOUBLE) ? REG_BUS_INTERNAL_IN[15:8] : REG_BUS_INTERNAL_IN[7:0];
                    5: Ep <= REG_BUS_INTERNAL_IN[7:0];
                endcase
            end
          end  
              
          if(SELECT_IX) begin IX <= {DATA_BUS_HIGH, DATA_BUS_LOW}; end
          if(SELECT_IY) begin IY <= {DATA_BUS_HIGH, DATA_BUS_LOW}; end
          if(SELECT_SP) begin SP <= {DATA_BUS_HIGH, DATA_BUS_LOW}; end
              
        end
      
      if(LD_PC) begin PC <= REG_BUS_INTERNAL_IN; end
      if(LD_I) begin I <= REG_BUS_INTERNAL_IN[15:8]; end 
      if(LD_R) begin R <= REG_BUS_INTERNAL_IN[7:0]; end
      
      if(LD_W) begin W <= REG_BUS_INTERNAL_IN[15:8]; end// make sure you know where (IR) is coming from
      if(LD_Z) begin Z <= REG_BUS_INTERNAL_IN[7:0]; end
      //YOU CANNOT WRITE TO BOTH PC/IR AND GENERIC REGISTER SET AT THE SAME TIME
      //internal bus is gated between PC/IR and rest of regs so PC/IR can be updated while generic set is being read
      
      //flip flops for register exchanges
      BIG_TOGGLE <= EXXTOGGLE ? ~BIG_TOGGLE : BIG_TOGGLE;
      DEHL_TOGGLE <= EXTOGGLE_DEHL ? ~DEHL_TOGGLE : DEHL_TOGGLE;
      DEPHLP_TOGGLE <= EXTOGGLE_DEPHLP ? ~DEPHLP_TOGGLE : DEPHLP_TOGGLE;
      AFAFP_TOGGLE <= EXTOGGLE_AF ? ~AFAFP_TOGGLE : AFAFP_TOGGLE;
     
    end 
    
//register reads
    
    always @(posedge CLK) begin

        //REG_MUX_OUT can go to ALU_BUS1 or DATABUS or Internal register bus
        case(REG_MUX)
            0: REG_MUX_OUT = BIG_TOGGLE ? {Bp,Cp} : {B,C};
            
            1: REG_MUX_OUT = BIG_TOGGLE ? (DEPHLP_TOGGLE ? {Hp,Lp} : {Dp, Ep}) : (DEHL_TOGGLE ? {H,L} : {D,E}); 
                                                
            2: REG_MUX_OUT = BIG_TOGGLE ? (DEPHLP_TOGGLE ? {Dp,Ep} : {Hp,Lp}) : (DEHL_TOGGLE ? {D,E} : {H,L});                                         
        endcase
        
        if(SELECT_IX) begin REG_MUX_OUT = IX; end
        if(SELECT_IY) begin REG_MUX_OUT = IY; end
        if(SELECT_SP) begin REG_MUX_OUT = SP; end
               
        //output is TO_ALU_2
        case(REG_MUX_ALU) 
            0: ALU_MUX_OUT = BIG_TOGGLE ? {Bp,Cp} : {B,C};
            
            1: ALU_MUX_OUT = BIG_TOGGLE ? (DEPHLP_TOGGLE ? {Hp,Lp} : {Dp, Ep}) : (DEHL_TOGGLE ? {H,L} : {D,E}); 
                                                
            2: ALU_MUX_OUT = BIG_TOGGLE ? (DEPHLP_TOGGLE ? {Dp,Ep} : {Hp,Lp}) : (DEHL_TOGGLE ? {D,E} : {H,L}); 
        endcase
        if(SELECT_IX) begin ALU_MUX_OUT = IX; end
        else if(SELECT_IY) begin ALU_MUX_OUT = IY; end
        else if(SELECT_SP) begin ALU_MUX_OUT = SP; end
        
        TO_ALU_1 <= GATE_ALU1 ? REG_MUX_OUT : 'bz; //assign value on outside of mux
        TO_ALU_2 <= GATE_ALU2 ? ALU_MUX_OUT : 'bz;
   
        W_DATA <= GATE_W ? W : 'bz;
        Z_DATA <= GATE_Z ? Z : 'bz;
       
        if(GATE_DATABUS) begin TO_DATABUS <= REG_MUX_OUT; end
        
        case({RD_16, GATE_PC, GATE_I, GATE_R})
            1: REG_BUS_INTERNAL_OUT <= {8'b0,R};
            2: REG_BUS_INTERNAL_OUT <= {I,8'b0};
            4: REG_BUS_INTERNAL_OUT <= PC;    
            8: REG_BUS_INTERNAL_OUT <= REG_MUX_OUT;  
        endcase
  
          //else begin TO_LATCH = REG_BUS_INTERNAL; end //connect latch to internal register file bus

    end
    
    assign TO_LATCH = REG_BUS_INTERNAL_OUT;

endmodule
