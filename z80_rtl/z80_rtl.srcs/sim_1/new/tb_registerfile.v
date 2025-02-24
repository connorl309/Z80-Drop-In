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
reg [15:0] LATCH_BUS;
reg [7:0] DATA_BUS_HIGH;
reg [7:0] DATA_BUS_LOW;
reg [2:0] RD_REG_MUX;
reg RD_16;
reg [2:0] WR_REG_MUX;
reg REG_DOUBLE;
reg WR_DATA_BUS; 
reg LD_FROM_REGBUS; 
reg [1:0] RD_SPECIAL; 
reg [1:0] WR_SPECIAL; 

reg GATE_REGBUS;
reg LD_W; 
reg LD_Z; 

reg EXTOGGLE_DEHL;
reg EXTOGGLE_DEPHLP;
reg EXXTOGGLE;

wire [7:0] W_DATA;
wire [7:0] Z_DATA;
wire [15:0] TO_ALU;
wire [15:0] TO_DATABUS;
wire [15:0] TO_LATCH;
wire [15:0] SPECIAL_REG_OUT;


z80RegisterFile uut (
    //inputs  
    .CLK (CLK),
    .LATCH_BUS (LATCH_BUS),
    .DATA_BUS_HIGH (DATA_BUS_HIGH),
    .DATA_BUS_LOW (DATA_BUS_LOW),
    .RD_REG_MUX (RD_REG_MUX),
    .RD_16 (RD_16),
    .WR_REG_MUX (WR_REG_MUX),
    .REG_DOUBLE (REG_DOUBLE),

    .WR_DATA_BUS (WR_DATA_BUS),
    .LD_FROM_REGBUS (LD_FROM_REGBUS),
    .RD_SPECIAL (RD_SPECIAL),
    .WR_SPECIAL (WR_SPECIAL),
    
    .GATE_REGBUS (GATE_REGBUS),
    .LD_W (LD_W),
    .LD_Z (LD_Z),

    .EXTOGGLE_DEHL (EXTOGGLE_DEHL),
    .EXTOGGLE_DEPHLP (EXTOGGLE_DEPHLP),
    .EXXTOGGLE (EXXTOGGLE),
    
    //outputs
    .W_DATA (W_DATA),
    .Z_DATA (Z_DATA),
    .TO_ALU (TO_ALU),
    .TO_DATABUS (TO_DATABUS),
    .TO_LATCH (TO_LATCH),
    .SPECIAL_REG_OUT (SPECIAL_REG_OUT)

);

    integer i;
    integer register_value;

    always #1 CLK = ~CLK;
    
    initial begin
        CLK = 1'b0;
        WR_DATA_BUS= 1'b0;  
        LD_FROM_REGBUS = 1'b0;  
        GATE_REGBUS= 1'b0;  
        LATCH_BUS = 16'b0;
        DATA_BUS_HIGH = 8'b0;
        DATA_BUS_LOW = 8'b0;
        RD_REG_MUX = 3'b0;    
        i = 0;
        RD_16= 1'b0;        
        WR_REG_MUX = 1'b0;  
        LD_W= 1'b0;           
        LD_Z= 1'b0;           
        REG_DOUBLE = 0;
        RD_SPECIAL = 2'b0;
        WR_SPECIAL = 2'b0;
        EXTOGGLE_DEHL = 1'b0;
        EXTOGGLE_DEPHLP = 1'b0;
        EXXTOGGLE= 1'b0;       
        //RD_SPECIAL = 2'b1;        
        RD_SPECIAL = 2'b0;      
        #1;  


//      //register writes
//        #2    
//        WR_DATA_BUS = 1;
//        REG_DOUBLE = 0;
//        WR_SPECIAL = 2'b01;
//        DATA_BUS_HIGH = 8'hBE;
//        DATA_BUS_LOW = 8'hEF;
//        LATCH_BUS = 16'hBBAA;
//        LD_W = 1;
//        LD_Z = 1;
                
//        #2
//        WR_SPECIAL = 0;
//        LD_W = 0;
//        LD_Z = 0;

//        for(i = 0; i < 8; i = i + 1) begin  
//            WR_REG_MUX = i;
//            register_value = (i * 10); 
//            DATA_BUS_HIGH = register_value;
//            DATA_BUS_LOW = register_value;
//            #2;
//        end
         
//        #4 
        
//        i = 0;
//        REG_DOUBLE = 1;        
//        WR_DATA_BUS = 0;
//        GATE_REGBUS  = 1;
//        //double writes to registers with internal bus
//        for(i = 0; i < 8; i = i + 2) begin  //reg_mux
//            WR_REG_MUX = i;
//            register_value = (i * 10); 
//            LATCH_BUS[15:8] = register_value;
//            LATCH_BUS[7:0] = register_value -1;
//            #2;
//        end
//        //write to C to ensure REG_DOUBLE only works when addressing high registers
//        WR_REG_MUX = 1;
//        LATCH_BUS = 16'hFF;
//        #8;
    
//      //register reads
//        GATE_REGBUS = 0;
//        RD_REG_MUX = 0;
//        i = 0;
//        RD_SPECIAL = 2'b01;
        
//        #2;
//        for(i = 0; i < 8; i=i+1) begin
//            RD_REG_MUX = i;
//            #2;   
//        end
        
        
//        EXTOGGLE_DEHL = 1;
//        RD_REG_MUX = 2; 
//        for(i = 0; i<8; i=i+1)begin
//            RD_REG_MUX = i;
        
//        end
        
        
        
 //latch testing: need to test DE <-> HL, DEp <-> HLp, and {BC, DE, HL} <-> {BCp, DEp, HLp}
        i = 0;   
        EXTOGGLE_DEHL = 0;
        EXTOGGLE_DEPHLP = 0;
        EXXTOGGLE= 0;        
        
        WR_DATA_BUS = 1;
        
        REG_DOUBLE = 1;
        DATA_BUS_HIGH = 8'hDE;
        for(i = 0; i<6; i=i+2)begin //will put 0xDE00 - 0xDE04 in first register pair
            DATA_BUS_LOW = i;   
            WR_REG_MUX = i;
            //RD_REG_MUX = i;
            #2;
        end
        WR_DATA_BUS = 0;
        #2;
        DATA_BUS_LOW = 8'hAD; 
        #2;
        EXXTOGGLE = 1; //write to alternate register set, 0x00AD - 0x04AD
        #2;
        EXXTOGGLE = 0;
        WR_DATA_BUS = 1;
        for(i=0; i<6; i=i+2)begin
            DATA_BUS_HIGH = i;
            WR_REG_MUX = i;
            #2;
        end
        
        #2;
        WR_DATA_BUS = 0;        
        EXXTOGGLE = 1;
        #2;
        EXXTOGGLE = 0;
        
        
        //read from DE and DE' | should output 0xDE02 and then 0x02AD 
        #2;
        RD_16 = 1;        
        RD_REG_MUX = 2;
        #8;
        EXXTOGGLE = 1; 
        #2; 
        EXXTOGGLE = 0;        
        RD_REG_MUX = 2;        
        #8;  

        //read from DE and HL | should output 0xDE04 and 0xDE02, DE and HL are swapped
        EXTOGGLE_DEHL = 1;
        EXXTOGGLE = 1;
        #2; 
        EXTOGGLE_DEHL = 0;
        EXXTOGGLE = 0;
        RD_REG_MUX = 2;
        #8;
        RD_REG_MUX = 4;
        #8;
        
        //read from DE' and HL' | should output 0x04AD and 0x02AD, DE' and HL' are swapped
        EXTOGGLE_DEPHLP = 1;
        EXXTOGGLE = 1;
        #2;
        EXTOGGLE_DEPHLP = 0;
        EXXTOGGLE = 0;
        RD_REG_MUX = 2;
        #8;
        RD_REG_MUX = 4;
        #8;
        
        
//        EXXTOGGLE = 1;
//        #2;
//        EXXTOGGLE = 0;
//        #2;
                     
        
//        //write to HL, FFFF should appear on DE 
//      WR_DATA_BUS = 1;
//        DATA_BUS_HIGH = 8'hFF;
//        DATA_BUS_LOW = 8'hFF;        
//        WR_REG_MUX = 4;
//        #2;

//        //write to HL', EEEE should appear on DE'
//        EXXTOGGLE = 1;
//        #2;
//        EXXTOGGLE = 0;
//        DATA_BUS_HIGH = 8'hEE;
//        DATA_BUS_LOW = 8'hEE;        
//        #8;
        $finish;
    end
      

endmodule
