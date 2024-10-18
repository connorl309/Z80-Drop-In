// Actual pinout numbers here (correspond to "pinout" output in module)
// Indices are 1 less than their actual pin number because 0-indexed
// https://www.retrocompute.co.uk/zilog-z80-pinout/

// https://area51.dev/asm/z80/about/flags/
`define FLAG_S 7
`define FLAG_Z 6
`define FLAG_Y 5
`define FLAG_H 4
`define FLAG_X 3
`define FLAG_PV 2
`define FLAG_N 1
`define FLAG_C 0

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

// ALU opcodes
`define ALU_ADD_8BIT 0 // 8-bit add
`define ALU_ADC_8BIT 1 // 8-bit add with carry
`define ALU_SUB_8BIT 2 // 8-bit sub
`define ALU_SBC_8BIT 3 // 8-bit sub with carry
`define ALU_AND_8BIT 4 // 8-bit AND 
`define ALU_OR_8BIT 5 // 8-bit OR 
`define ALU_XOR_8BIT 6 // 8-bit XOR 
`define ALU_CP 7 // 8-bit compare
`define ALU_DAA 8 // DAA instruction
`define ALU_INC_8BIT 9 // 8-bit increment
`define ALU_DEC_8BIT 10 // 8-bit decrement
`define ALU_CPL 11 // 8-bit one's complement negation
`define ALU_NEG 12 // 8-bit two's complement negation
`define ALU_CCF 13 // Invert carry flag
`define ALU_SCF 14 // Set carry flag

`define ALU_ADD_16BIT 15 // 16-bit add 
`define ALU_ADC_16BIT 16 // 16-bit add with carry
`define ALU_SBC_16BIT 17 // 16-bit sub with carry
`define ALU_INC_16BIT 18 // 16-bit increment
`define ALU_DEC_16BIT 19 // 16-bit decrement

`define ALU_RLCA 20 //  8-bit rotate left
`define ALU_RLA 21 // 8-bit rotate left through carry 
`define ALU_RLC 22 // 8-bit rotate left, different flag updates
`define ALU_RL 23 // 8-bit rotate left through carry, different flag updates
`define ALU_RRCA 24 // 8-bit rotate right
`define ALU_RRA 25 // 8-bit rotate right through carry
`define ALU_RRC 26 // 8-bit rotate right, different flag updates
`define ALU_RR 27 // 8-bit rotate right through carry, different flag updates
`define ALU_SLA 28 // 8-bit arithmetic shift left
`define ALU_SLL 29 // undocumented instruction with CB[XX] opcode, this sets [0] instead of resetting it like SLA, see z80 undocumented 3.1
`define ALU_SRA 30 // 8-bit arithmetic shift right
`define ALU_SRL 31 // 8-bit logical shift right
`define ALU_RLD 32 // weird ahhh left rotate through memory location and A 
`define ALU_RRD 33 // weird ahhh right rotate through memory location and A 

`define ALU_LD_TEMP 34
`define ALU_PASSA 35
`define ALU_PASSB 36
`define ALU_SWAP_REGS 37

`define ALU_TEST_BASE 38
`define ALU_TEST_IX_BASE `ALU_TEST_BASE + 8
`define ALU_TEST_HL_BASE `ALU_TEST_IX_BASE + 8
`define ALU_SET_BASE `ALU_TEST_HL_BASE + 8
`define ALU_RESET_BASE `ALU_SET_BASE + 8
