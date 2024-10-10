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
    input REG_PRIME, // register file should use the alternate register set (i.e. D', E', ...) 
    input REG_DOUBLE, // writing to/reading from a pair of registers
    input PCIR_OUTGATE, //when this is low, the PC, I, or R registers can be changed while other registers are being put onto the bus in the register file
    input GATE_PC, //puts PC onto internal register bus
    input GATE_I, //see above
    input GATE_R, //see above
    input LD_PC, //load PC with value on internal register bus
    input LD_I, //load I with high 8 bits of internal register bus
    input LD_R, //load R with low 8 bits of internal register bus (from incrementer)
    input WR_EN, //enables writes to general purpose register set from the DATA bus
    input GATE_REGBUS, //allows the general purpose register set to access the internal regfile bus 
    input GATE_TO_ALU, //gate to 8 bit input to ALU
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
    output reg [7:0] W_data,
    output reg [7:0] Z_data,
    output reg [15:0] To_ALU,
    output reg [15:0] To_InternalDataBus
    //output reg [15:0] To_AddressBus
    );
    
    reg  [7:0] W, Z, I, R, A, F, Ap, Fp, 
                          B,  C,  D,  E,  H,  L,
                          Bp, Cp, Dp, Ep, Hp, Lp; 
    
    reg [15:0] PC, IX, IY, SP;
    
    wire [7:0] W_BUS, Z_BUS;   
    wire [15:0] REG_BUS_INTERNAL, REG_MUX_OUT;
   
//register writes 
    always @(posedge CLK) begin
  
      if (WR_EN) begin //write from databus
        if (!REG_PRIME) begin
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
            case (REG_MUX)
                0: Bp <= DATA_BUS_HIGH;
                1: Cp <= DATA_BUS_LOW;
                2: Dp <= DATA_BUS_HIGH;
                3: Ep <= DATA_BUS_LOW;
                4: Hp <= DATA_BUS_HIGH;
                5: Lp <= DATA_BUS_LOW;
                6: IX <= {DATA_BUS_HIGH, DATA_BUS_LOW};
                7: IY <= {DATA_BUS_HIGH, DATA_BUS_LOW};
            endcase
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
      
      
    end 
    
//register reads
    always @(posedge CLK) begin
        if(GATE_W) begin W_data <= W; end
        if(GATE_Z) begin Z_data <= Z; end 
   
        
   
        if(GATE_DATABUS) begin
            case(REG_MUX)
            //ask April/Luke if they handle bus bits in the ALU or if I should only send them teh specific 8 bit data they need
            //I understand REG_MUX is not serving it's specified purpose here, need to figure out bus situation between regfile and ALU first
//                0: To_InternalDataBus <= {REG_PRIME ? Bp : B, 8'b00000000}; 
//                1: To_InternalDataBus <= {REG_PRIME ? Cp : C, 8'b00000000};
//                2: To_InternalDataBus <= {REG_PRIME ? Dp : D, 8'b00000000};
//                3: To_InternalDataBus <= {REG_PRIME ? Ep : E, 8'b00000000};
//                4: To_InternalDataBus <= {REG_PRIME ? Hp : H, 8'b00000000};
//                5: To_InternalDataBus <= {REG_PRIME ? Lp : L, 8'b00000000};
                0: To_InternalDataBus <= REG_PRIME ? {Bp, Cp} : {B, C};
                1: To_InternalDataBus <= REG_PRIME ? {Dp, Ep} : {D, E};
                2: To_InternalDataBus <= REG_PRIME ? {Hp, Lp} : {H, L};
            endcase
            if(SELECT_IX) begin To_InternalDataBus <= IX; end
            if(SELECT_IY) begin To_InternalDataBus <= IY; end
            if(SELECT_SP) begin To_InternalDataBus <= SP; end
            
        end
        
        if(GATE_TO_ALU) begin
            case(REG_MUX)
                0: To_InternalDataBus <= REG_PRIME ? {Bp, Cp} : {B, C};
                1: To_InternalDataBus <= REG_PRIME ? {Dp, Ep} : {D, E};
                2: To_InternalDataBus <= REG_PRIME ? {Hp, Lp} : {H, L};
            endcase
        end 
        
        if(SELECT_IX) begin To_InternalDataBus <= IX; end
        if(SELECT_IY) begin To_InternalDataBus <= IY; end
        if(SELECT_SP) begin To_InternalDataBus <= SP; end

    
        if(RD_16) begin
            case(REG_MUX)
            0: To_InternalDataBus <= REG_PRIME ? {Bp, Cp} : {B, C};
            1: To_InternalDataBus <= REG_PRIME ? {Dp, Ep} : {D, E};
            2: To_InternalDataBus <= REG_PRIME ? {Hp, Lp} : {H, L};
            3: To_InternalDataBus <= IX;
            4: To_InternalDataBus <= IY;
            5: To_InternalDataBus <= SP;
            endcase
        end

    end

assign REG_BUS_INTERNAL = ADDR_BUS_FROM_LATCH;


endmodule
