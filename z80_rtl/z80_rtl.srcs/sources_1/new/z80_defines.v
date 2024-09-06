// Actual pinout numbers here (correspond to "pinout" output in module)
// Indices are 1 less than their actual pin number because 0-indexed
// https://www.retrocompute.co.uk/zilog-z80-pinout/

// Address bus pins - 16 bit
// OUTPUT ONLY
`define A0 29
`define A1 30
`define A2 31
`define A3 32 
`define A4 33
`define A5 34
`define A6 35
`define A7 36
`define A8 37
`define A9 38
`define A10 39
`define A11 0
`define A12 1
`define A13 2 
`define A14 3
`define A15 4

// Data bus pins - 8 bit
// INPUT AND OUTPUT
`define D0 13
`define D1 14
`define D2 11
`define D3 7
`define D4 6
`define D5 8
`define D6 9 
`define D7 12

// BUS pins
`define BUSRQ 24 // INPUT ONLY, NEGATIVE LOGIC
`define BUSAK 22 // OUTPUT ONLY, NEGATIVE LOGIC

// Control pins
`define RESET 25 // INPUT ONLY, NEGATIVE LOGIC
`define INT 15 // INPUT ONLY, NEGATIVE LOGIC
`define NMI 16 // INPUT ONLY, NEGATIVE LOGIC
`define WAIT 23 // INPUT ONLY, NEGATIVE LOGIC

// Other
`define M1 26 // OUTPUT ONLY, NEGATIVE LOGIC
`define MREQ 18 // OUTPUT ONLY, NEGATIVE LOGIC
`define IORQ 19 // I/O, NEGATIVE LOGIC
`define WR 21 // OUTPUT ONLY, NEGATIVE LOGIC
`define RD 20 // OUTPUT ONLY, NEGATIVE LOGIC
`define REFSH 27 // OUTPUT ONLY, NEGATIVE LOGIC
`define HALT 17 // OUTPUT ONLY, NEGATIVE LOGIC
`define CLK 5 // INPUT ONLY
`define VCC 10 // Probably not needed
`define GND 28 // Probably not needed