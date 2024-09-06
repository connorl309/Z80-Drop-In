`timescale 1ns / 1ps

// Definitions and pinout information
`define NUM_PINS 40

`include "z80_defines.v" // Pin definitions

// Register index definitions
`define A 0
`define B 1
`define D 2
`define H 3
// Flag index definitions
`define F 0
`define C 1
`define BPRIME 1
`define E 2
`define L 3

// The "core" of the Z80
module z80core(
    input clock,
    output[`NUM_PINS-1:0] pinout
);

// 2D arrays - regfile[0] is register "A", each one is 8 bits
// use the defines in this file for better naming
// https://www.zilog.com/docs/z80/um0080.pdf - Page 16 on the PDF
reg [7:0] regfile[3:0];
reg [7:0] regfile_prime[3:0];
reg [7:0] flags[3:0];
reg [7:0] flags_prime[3:0];
reg [7:0] interrupt_vector;
reg [7:0] memory_refresh;
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
*/

endmodule
