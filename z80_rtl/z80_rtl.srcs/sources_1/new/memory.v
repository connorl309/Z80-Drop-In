`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2024 06:08:14 PM
// Design Name: 
// Module Name: memory
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


module memory(
    input CLK,
    input MREQ,
    input RD,
    input WR,
    input [15:0] ADDR,
    input [7:0] DATA_IN,
    output [7:0] DATA_OUT
    );
    
  //  integer i = 0;
   
    
        // Memory
    blk_mem_gen_0 RAM (
        .clka(CLK),
        .addra(ADDR),
        .dina(DATA_IN),
        .douta(DATA_OUT),
        .ena(!MREQ && !RD),
        .wea(!MREQ && !WR)
    );
    
    /*
    initial begin
        $display("Clearing Memory");
        for (i = 0; i < 65535; i = i + 1) begin
            mem[i] = 0;
        end
        $display("Loading Memory");
        $readmemb("memory.txt", mem); // will load the hex binary contained in memory.txt
    end
    */
    
//    always @(negedge CLK) begin
//        if (!MREQ && !WR) begin
//            mem[ADDR] <= DATA;
//        end
//    end
    
endmodule
