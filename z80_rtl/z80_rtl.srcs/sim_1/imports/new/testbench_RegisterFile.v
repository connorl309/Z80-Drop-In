`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2024 05:41:56 PM
// Design Name: 
// Module Name: testbench_RegisterFile
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


module testbench_RegisterFile;

reg CLK;
reg [15:0] ADDR_BUS_FROM_LATCH;
reg [7:0] DATA_BUS_HIGH;
reg [7:0] DATA_BUS_LOW;
reg [2:0] REG_MUX;
reg [2:0] REG_MUX_ALU;
reg GATE_PC;
reg GATE_I; 
reg GATE_R; 
reg LD_PC; 
reg LD_I; 
reg LD_R; 
reg WR_DATA_BUS;
reg GATE_REGBUS;
reg GATE_ALU1; 
reg GATE_ALU2; 
reg GATE_DATABUS; 
reg RD_16;
reg LD_W;
reg LD_Z; 
reg GATE_W;
reg GATE_Z;
reg SELECT_SP;
reg SELECT_IX;
reg SELECT_IY;
reg REG_DOUBLE;
reg EXTOGGLE_DEHL;
reg EXTOGGLE_DEPHLP;
reg EXTOGGLE_AF;
reg EXXTOGGLE;
wire [7:0] Z_DATA;
wire [15:0] TO_ALU_1;
wire [15:0] TO_ALU_2;
wire [15:0] TO_DATABUS;
wire [15:0] TO_LATCH;


z80RegisterFile uut (
    //inputs  
    .CLK (CLK),
    .ADDR_BUS_FROM_LATCH (ADDR_BUS_FROM_LATCH),
    .DATA_BUS_HIGH (DATA_BUS_HIGH),
    .DATA_BUS_LOW (DATA_BUS_LOW),
    .REG_MUX (REG_MUX),
    .REG_MUX_ALU (REG_MUX_ALU),
    .REG_DOUBLE (REG_DOUBLE),
    .GATE_INTERNAL (GATE_INTERNAL),
    .GATE_PC (GATE_PC),
    .GATE_I (GATE_I),
    .GATE_R (GATE_R),
    .LD_PC (LD_PC),
    .LD_I (LD_I),
    .LD_R (LD_R),
    .WR_DATA_BUS (WR_DATA_BUS),
    .GATE_REGBUS (GATE_REGBUS),
    .GATE_ALU1 (GATE_ALU1),
    .GATE_ALU2 (GATE_ALU2),
    .GATE_DATABUS (GATE_DATABUS),
    .RD_16 (RD_16),
    .LD_W (LD_W),
    .LD_Z (LD_Z),
    .GATE_W (GATE_W),
    .GATE_Z (GATE_Z),
    .SELECT_SP (SELECT_SP),
    .SELECT_IX (SELECT_IX),
    .SELECT_IY (SELECT_IY),
    .EXTOGGLE_DEHL (EXTOGGLE_DEHL),
    .EXTOGGLE_DEPHLP (EXTOGGLE_DEPHLP),
    .EXTOGGLE_AF (EXTOGGLE_AF),
    .EXXTOGGLE (EXXTOGGLE),
    
    //outputs
    .W_DATA (W_DATA),
    .Z_DATA (Z_DATA),
    .TO_ALU_1 (TO_ALU_1),
    .TO_ALU_2 (TO_ALU_2),
    .TO_DATABUS (TO_DATABUS),
    .TO_LATCH (TO_LATCH)
);

    integer i, j, bruh;

    always #1 CLK = ~CLK;
    
    //register writes
    initial begin
        CLK = 1'b0;
        ADDR_BUS_FROM_LATCH = 16'b0;
        DATA_BUS_HIGH = 8'b0;
        DATA_BUS_LOW = 8'b0;
        REG_MUX = 3'b0;    
        REG_MUX_ALU = 3'b0;
        i = 0;
        j = 0;
        
        GATE_PC= 1'b0;        
        GATE_I= 1'b0;         
        GATE_R= 1'b0;         
        LD_PC= 1'b0;          
        LD_I= 1'b0;           
        LD_R= 1'b0;           
        WR_DATA_BUS= 1'b0;    
        GATE_REGBUS= 1'b0;    
        GATE_ALU1= 1'b1;      
        GATE_ALU2= 1'b1;      
        GATE_DATABUS= 1'b1;   
        RD_16= 1'b0;          
        LD_W= 1'b0;           
        LD_Z= 1'b0;           
        GATE_W= 1'b1;         
        GATE_Z= 1'b1;         
        SELECT_SP= 1'b0;      
        SELECT_IX= 1'b0;      
        SELECT_IY= 1'b0;      
        REG_DOUBLE = 0;
        
        EXTOGGLE_DEHL = 1'b0;
        EXTOGGLE_DEPHLP = 1'b0;
        EXTOGGLE_AF= 1'b0;
        EXXTOGGLE= 1'b0;       
        
        #2    
        WR_DATA_BUS = 1;
        REG_DOUBLE = 1;
        #2
        for(i = 0; i < 8; i = i + 1) begin  
            REG_MUX = i;
            bruh = (i * 10) + 500; 
            DATA_BUS_HIGH = bruh[15:8];
            DATA_BUS_LOW = bruh[7:0];
            #2;
        end
          
        i = 0;
        REG_DOUBLE = 0;
        EXXTOGGLE = 1'b1;
        #2
        
        WR_DATA_BUS = 0;
        GATE_REGBUS  = 1;
        for(i = 0; i < 8; i = i + 1) begin  //reg_mux
            REG_MUX = i;
            bruh = (i * 10);
            ADDR_BUS_FROM_LATCH = bruh;
            #2;
        end
        EXXTOGGLE = 0;
        #4;
    
        //register reads
        
        GATE_REGBUS = 0;
        REG_MUX = 0;
        GATE_ALU1 = 1;
        GATE_ALU2 = 1;
        i = 0;
        for(i = 0; i < 8; i=i+1) begin
            REG_MUX = i;
            REG_MUX_ALU = 7-i;
            #2;   
        end
        
        
        EXTOGGLE_DEHL = 1;
        for(i = 0; i<8; i=i+1)begin
            REG_MUX = i;
            REG_MUX_ALU = 7-i;
        
        end
        
        $finish;
    end
      

endmodule
