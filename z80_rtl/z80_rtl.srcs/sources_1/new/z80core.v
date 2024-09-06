`timescale 1ns / 1ps

// Definitions and pinout information
`define NUM_PINS 40

`include "z80_defines.v" // Pin definitions

// Register index definitions
`define A 0
`define B 1
`define C 2
`define D 3
`define E 4
`define H 5
`define L 6

// The "core" of the Z80
// https://cs.furman.edu/~tallen/csc475/materials/Chapter%203%20Z80.pdf
module z80core(
    input clock,
    
    output m1,
    output mreq,
    output iorq,
    output rd,
    output wr,
    output rfsh,
    output halt,
    
    input waitpin,
    input int,
    input nmi,
    input reset,
    
    input busrq,
    output busack,
    
    output [15:0] address_out, 
    wire [7:0] data
);

// internal data
reg [7:0] data_buffer;
reg [15:0] address_buffer;
// each m cycle can be up to 6 tcycles
reg [3:0] tcycle;
reg [3:0] mcycle;
reg isNewCycle;

// 2D arrays - regfile[0] is register "A", each one is 8 bits
// use the defines in this file for better naming
// https://www.zilog.com/docs/z80/um0080.pdf - Page 16 on the PDF
reg [7:0] regfile[2:0];
reg [7:0] regfile_prime[2:0];
reg [7:0] flags;
reg [7:0] flags_prime;
reg [7:0] I;
reg [7:0] R;
reg [1:0] interrupt_mode;
// the 16 bit registers
reg [15:0] IX;
reg [15:0] IY;
reg [15:0] SP;
reg [15:0] PC;
/*
Two matched sets of general-purpose registers, each set containing six 8-bit registers, can
be used individually as 8-bit registers or as 16-bit register pairs. One set is called BC, DE,
and HL while the complementary set is called BC', DE', and HL'. At any one time, 
the programmer can select either set of registers to work through a single exchange command for
the entire set.

Since Z80 is CISC (and x86), the instruction register has to support up to 4 bytes
of data.
*/
reg [0:31] instruction;
reg IFF1, IFF2; // Page 31/32 for these
// IFF1 is actual interrupt enable flip flop
// IFF2 holds onto IFF1 whenever the chip receives NMI

// Fetch will take 4, 5, or 6 clock cycles depending on the instruction length
/*
The Program Counter is
placed on the address bus at the beginning of the M1 cycle. One half clock cycle later, the
MREQ signal goes active. At this time, the address to memory has had time to stabilize so
that the falling edge of MREQ can be used directly as a chip enable clock to dynamic
memories. The RD line also goes active to indicate that the memory read data should be
enabled onto the CPU data bus. The CPU samples the data from the memory space on the
data bus with the rising edge of the clock of state T3, and this same edge is used by the
CPU to turn off the RD and MREQ signals. As a result, the data is sampled by the CPU
before the RD signal becomes inactive. Clock states T3 and T4 of a fetch cycle are used to
refresh dynamic memories. The CPU uses this time to decode and execute the fetched
instruction so that no other concurrent operation can be performed.
*/

// Cycle counting
always @(posedge clock) begin
    // if at our limit of mcycles, or we are entering a new m cycle
    if (mcycle == 4'b1111 || isNewCycle == 1) begin
        mcycle <= 4'b0;
        tcycle <= 4'b0;
        isNewCycle <= 0;
    end
    // otherwise if at T cycle limit
    else if (tcycle == 4'd6) begin
        tcycle <= 4'b0;
        mcycle <= mcycle + 3'b1;
    end
    // otherwise increment as normal
    else begin
        tcycle <= tcycle + 1'b1;
    end
end

// Page 20 - reset is active low
always @(negedge reset) begin
    IFF1 <= 1'b0;
    PC <= 16'b0;
    I <= 8'b0;
    R <= 8'b0;
    interrupt_mode <= 2'b0;
    address_out <= 16'bz;
    data <= 8'bz;
    tcycle <= 4'b0;
    mcycle <= 4'b0;
end

endmodule
