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
    input REG_PRIME, // register file should use the alternate register set (i.e. D', E', ...) 
    //input REG_DOUBLE, // writing to/reading from a pair of registers, unsure if this is used
    input GATE_INTERNAL, //when this is low, the PC, I, or R registers can be changed while general registers are being read onto other buses
                         //when high, data from the internal reg bus (probably coming from the incrementer/latch) can be written to general registers
                         
    input GATE_PC, //puts PC onto internal register bus
    input GATE_I, //see above
    input GATE_R, //see above
    input LD_PC, //load PC with value on internal register bus
    input LD_I, //load I with high 8 bits of internal register bus
    input LD_R, //load R with low 8 bits of internal register bus (from incrementer)
    input WR_DATA_BUS, //enables writes to general purpose register set from the DATA bus
    input GATE_REGBUS, //allows the general purpose register set to access the internal regfile bus 
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
    input EXLATCH, //should be high during EX instruction execution (for register renaming)
    input EXXLATCH, //should be high during EXX instruction execution
    output reg [7:0] W_DATA,
    output reg [7:0] Z_DATA,
    output reg [15:0] TO_ALU_1,
    output reg [15:0] TO_ALU_2,
    output reg [15:0] TO_DATABUS,
    output [15:0] TO_LATCH
    
    //output reg [15:0] To_AddressBus
    );
    
    reg  [7:0] W, Z, I, R, A, F, Ap, Fp, 
                          B,  C,  D,  E,  H,  L,
                          Bp, Cp, Dp, Ep, Hp, Lp; 
    
    reg [15:0] PC, IX, IY, SP;
    
    wire [7:0] W_BUS, Z_BUS;   
    reg [15:0] REG_BUS_INTERNAL;
    reg [15:0] REG_MUX_OUT, ALU_MUX_OUT;
    
    // flipflops that toggle during register exchange operations (EX, EXX)
    /*
        DEHL_TOGGLE: if low, DE instruction goes to DE. if high, DE instruction goes to HL
        DEPHLP_TOGGLE: if low, DE' goes to DE'. if low, DE' goes to HL'
        AFAFP_TOGGLE: AF vs AF', you get the idea    
        BIG_TOGGLE: if high, BC/DE/HL goes instead to BC'/DE'/HL'  
        
        *NOTE: DEHL_TOGGLE and its counterpart are also used for toggling A/A' and F/F'
    */
    reg DEHL_TOGGLE = 0, DEPHLP_TOGGLE = 0, AFAFP_TOGGLE = 0, BIG_TOGGLE = 0; 
    
   
//register writes 
    always @(posedge CLK) begin
  
      if (WR_DATA_BUS) begin //write to register from databus
      
      //general flow: REG_PRIME -> BIG toggle -> DEHL or DEpHLp toggle
        //0, 0, 0
        if (!REG_PRIME) begin
          if (!BIG_TOGGLE) begin
            if (!DEHL_TOGGLE) begin
              //0 0 0
                case (REG_MUX)       
                        0: B <= DATA_BUS_HIGH;
                        1: C <= DATA_BUS_LOW;
                        2: D <= DATA_BUS_HIGH;
                        3: E <= DATA_BUS_LOW;
                        4: H <= DATA_BUS_HIGH;
                        5: L <= DATA_BUS_LOW;
                endcase
            end
             
            else begin //DEHL_TOGGLE is high, swap DE and HL
               // 0 0 1
                 case (REG_MUX)       
                        0: B <= DATA_BUS_HIGH;
                        1: C <= DATA_BUS_LOW;
                        2: H <= DATA_BUS_HIGH;
                        3: L <= DATA_BUS_LOW;
                        4: D <= DATA_BUS_HIGH;
                        5: E <= DATA_BUS_LOW;
                 endcase     
            end           
          end
          
          else begin //BIG_TOGGLE is high, swap BC/DE/HL for their primes
            if (!DEPHLP_TOGGLE) begin
                // 0 1 0
                case (REG_MUX)
                    0: Bp <= DATA_BUS_HIGH;
                    1: Cp <= DATA_BUS_LOW;
                    2: Dp <= DATA_BUS_HIGH;
                    3: Ep <= DATA_BUS_LOW;
                    4: Hp <= DATA_BUS_HIGH;
                    5: Lp <= DATA_BUS_LOW;
                endcase
            end
            
            else begin //swap between DEp and HLp
                // 0 1 1
                case (REG_MUX)
                    0: Bp <= DATA_BUS_HIGH;
                    1: Cp <= DATA_BUS_LOW;
                    2: Hp <= DATA_BUS_HIGH;
                    3: Lp <= DATA_BUS_LOW;
                    4: Dp <= DATA_BUS_HIGH;
                    5: Ep <= DATA_BUS_LOW;
                endcase
            end
          end         
        end
        
        
        else begin //REG_PRIME is high
          if (!BIG_TOGGLE)begin
            if (!DEPHLP_TOGGLE) begin
                // 1 0 0
                case (REG_MUX)
                    0: Bp <= DATA_BUS_HIGH;
                    1: Cp <= DATA_BUS_LOW;
                    2: Dp <= DATA_BUS_HIGH;
                    3: Ep <= DATA_BUS_LOW;
                    4: Hp <= DATA_BUS_HIGH;
                    5: Lp <= DATA_BUS_LOW;
                endcase
            end
            else begin //swamp DE' and HL'
                // 1 0 1
                case (REG_MUX)
                    0: Bp <= DATA_BUS_HIGH;
                    1: Cp <= DATA_BUS_LOW;
                    2: Hp <= DATA_BUS_HIGH;
                    3: Lp <= DATA_BUS_LOW;
                    4: Dp <= DATA_BUS_HIGH;
                    5: Ep <= DATA_BUS_LOW;
                endcase
            end  
          end
          
          else begin //BIG_TOGGLE is high, use normal register set
            if (!DEHL_TOGGLE) begin
                // 1 1 0
                case (REG_MUX)       
                        0: B <= DATA_BUS_HIGH;
                        1: C <= DATA_BUS_LOW;
                        2: D <= DATA_BUS_HIGH;
                        3: E <= DATA_BUS_LOW;
                        4: H <= DATA_BUS_HIGH;
                        5: L <= DATA_BUS_LOW;
                 endcase 
            end
            else begin
                // 1 1 1
                case (REG_MUX) //swap DE and HL
                    0: B <= DATA_BUS_HIGH;
                    1: C <= DATA_BUS_LOW;
                    2: H <= DATA_BUS_HIGH;
                    3: L <= DATA_BUS_LOW;
                    4: D <= DATA_BUS_HIGH;
                    5: E <= DATA_BUS_LOW;
                endcase    
            end
          end
            
          end
          
          if(SELECT_IX) begin IX <= {DATA_BUS_HIGH, DATA_BUS_LOW}; end
          if(SELECT_IY) begin IY <= {DATA_BUS_HIGH, DATA_BUS_LOW}; end
          if(SELECT_SP) begin SP <= {DATA_BUS_HIGH, DATA_BUS_LOW}; end
      end
      
      else if(GATE_REGBUS) begin
        if (!REG_PRIME) begin
            case (REG_MUX)
                0: B <= REG_BUS_INTERNAL[15:8];
                1: C <= REG_BUS_INTERNAL[7:0];
                2: D <= REG_BUS_INTERNAL[15:8];
                3: E <= REG_BUS_INTERNAL[7:0];
                4: H <= REG_BUS_INTERNAL[15:8];
                5: L <= REG_BUS_INTERNAL[7:0];
            endcase
        end
          else begin
            case (REG_MUX)
                0: Bp <= REG_BUS_INTERNAL[15:8];
                1: Cp <= REG_BUS_INTERNAL[7:0];
                2: Dp <= REG_BUS_INTERNAL[15:8];
                3: Ep <= REG_BUS_INTERNAL[7:0];
                4: Hp <= REG_BUS_INTERNAL[15:8];
                5: Lp <= REG_BUS_INTERNAL[7:0];
            endcase
          end
          
          if(SELECT_IX) begin IX <= {DATA_BUS_HIGH, DATA_BUS_LOW}; end
          if(SELECT_IY) begin IY <= {DATA_BUS_HIGH, DATA_BUS_LOW}; end
          if(SELECT_SP) begin SP <= {DATA_BUS_HIGH, DATA_BUS_LOW}; end
          
      end
      
      if(LD_PC) begin PC <= REG_BUS_INTERNAL; end
      if(LD_I) begin I <= REG_BUS_INTERNAL[15:8]; end 
      if(LD_R) begin R <= REG_BUS_INTERNAL[7:0]; end
      
      if(LD_W) begin W <= REG_BUS_INTERNAL; end// may want to load directly from instruction register in control block?
      if(LD_Z) begin Z <= REG_BUS_INTERNAL; end
      //YOU CANNOT WRITE TO BOTH PC/IR AND GENERIC REGISTER SET AT THE SAME TIME
      //internal bus is gated between PC/IR and rest of regs so PC/IR can be updated while generic set is being read
      
      //flip flops for register exchanges
      assign BIG_TOGGLE = EXXLATCH ? ~BIG_TOGGLE : BIG_TOGGLE;
      assign DEHL_TOGGLE = EXLATCH ? ~DEHL_TOGGLE : DEHL_TOGGLE;
      assign DEPHLP_TOGGLE = EXLATCH ? ~DEPHLP_TOGGLE : DEPHLP_TOGGLE;
     
    end 
    
//register reads
    // flipflops that toggle during register exchange operations (EX, EXX)
    /*
        DEHL_TOGGLE: if low, DE instruction goes to DE. if high, DE instruction goes to HL
        DEPHLP_TOGGLE: if low, DE' goes to DE'. if high, DE' goes to HL'
        AFAFP_TOGGLE: AF vs AF', you get the idea    
        BIG_TOGGLE: if high, BC/DE/HL goes instead to BC'/DE'/HL'  
    */
    always @(posedge CLK) begin

        //REG_MUX_OUT can go to ALU_BUS1 or DATABUS or Internal register bus?
        case(REG_MUX)
            0: assign REG_MUX_OUT = REG_PRIME ? (BIG_TOGGLE ? {B,C} : {Bp,Cp}) : (BIG_TOGGLE ? {Bp,Cp} : {B,C});
            
            1: assign REG_MUX_OUT = REG_PRIME ? (BIG_TOGGLE ? (DEHL_TOGGLE ? {H,L} : {D,E}) : (DEPHLP_TOGGLE ? {Hp,Lp} : {Dp, Ep})) : 
                                                (BIG_TOGGLE ? (DEPHLP_TOGGLE ? {Hp,Lp} : {Dp, Ep}) : (DEHL_TOGGLE ? {H,L} : {D,E})); 
                                                
            2: assign REG_MUX_OUT = REG_PRIME ? (BIG_TOGGLE ? (DEHL_TOGGLE ? {D,E} : {H,L}) : (DEPHLP_TOGGLE ? {Dp,Ep} : {Hp,Lp})) : 
                                                (BIG_TOGGLE ? (DEPHLP_TOGGLE ? {Dp,Ep} : {Hp,Lp}) : (DEHL_TOGGLE ? {D,E} : {H,L})); 
                                                
        endcase
        if(SELECT_IX) begin assign REG_MUX_OUT = IX; end
        if(SELECT_IY) begin assign REG_MUX_OUT = IY; end
        if(SELECT_SP) begin assign REG_MUX_OUT = SP; end
               
        //output is TO_ALU_2
        case(REG_MUX_ALU) 
            0: assign ALU_MUX_OUT = REG_PRIME ? (BIG_TOGGLE ? {B,C} : {Bp,Cp}) : (BIG_TOGGLE ? {Bp,Cp} : {B,C});
            
            1: assign ALU_MUX_OUT = REG_PRIME ? (BIG_TOGGLE ? (DEHL_TOGGLE ? {H,L} : {D,E}) : (DEPHLP_TOGGLE ? {Hp,Lp} : {Dp, Ep})) : 
                                                (BIG_TOGGLE ? (DEPHLP_TOGGLE ? {Hp,Lp} : {Dp, Ep}) : (DEHL_TOGGLE ? {H,L} : {D,E})); 
                                                
            2: assign ALU_MUX_OUT = REG_PRIME ? (BIG_TOGGLE ? (DEHL_TOGGLE ? {D,E} : {H,L}) : (DEPHLP_TOGGLE ? {Dp,Ep} : {Hp,Lp})) : 
                                                (BIG_TOGGLE ? (DEPHLP_TOGGLE ? {Dp,Ep} : {Hp,Lp}) : (DEHL_TOGGLE ? {D,E} : {H,L})); 
        endcase
        if(SELECT_IX) begin assign ALU_MUX_OUT = IX; end
        if(SELECT_IY) begin assign ALU_MUX_OUT = IY; end
        if(SELECT_SP) begin assign ALU_MUX_OUT = SP; end
        
        
        assign TO_ALU_1 = GATE_ALU1 ? REG_MUX_OUT : 'bz; //assign value on outside of mux
        assign TO_ALU_2 = GATE_ALU2 ? ALU_MUX_OUT : 'bz;
   
        assign W_DATA = GATE_W ? W : 'bz;
        assign Z_DATA = GATE_Z ? Z : 'bz;
       
        if(GATE_DATABUS) begin TO_DATABUS <= REG_MUX_OUT; end
  
        if(RD_16) begin assign REG_BUS_INTERNAL = REG_MUX_OUT; end
        
    end

    assign TO_LATCH = REG_BUS_INTERNAL; //connect latch to internal register file bus


endmodule
