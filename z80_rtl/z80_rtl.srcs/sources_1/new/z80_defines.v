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

`define ALU_LDI_INC 38
`define ALU_LDD_DEC 39
`define ALU_CPID 40
`define ALU_LD_DEC 41
`define ALU_CP_DEC 42

`define ALU_LDAIR 43

`define ALU_IN 44
`define ALU_INI_DEC 45
`define ALU_IND_DEC 46

`define ALU_OUTI_DEC 47
`define ALU_OUTD_DEC 48

`define ALU_TEST_BASE 49
`define ALU_TEST_IX_BASE (`ALU_TEST_BASE + 8)
`define ALU_TEST_HL_BASE (`ALU_TEST_IX_BASE + 8)
`define ALU_SET_BASE (`ALU_TEST_HL_BASE + 8)
`define ALU_RESET_BASE (`ALU_SET_BASE + 8)

/*

BELOW ARE CONTROL SIGNAL DEFINES

*/


//A_MUX chooses between 5:3 of opcode, 2:0 of opcode, HL, BC, DE, A, I, R, PC, MDR, Zero, and B as SR1
`define A_MUX_Y 4'd0 //uses P if RP is set
`define A_MUX_Z 4'd1 //uses Z instead of Y
`define A_MUX_HL 4'd2
`define A_MUX_BC 4'd3
`define A_MUX_DE 4'd4
`define A_MUX_A 4'd5
`define A_MUX_I 4'd6
`define A_MUX_R 4'd7
`define A_MUX_PC 4'd8
`define A_MUX_MDR 4'd9 //new from nadia's original drawing
`define A_MUX_ZERO 4'd11 //new from nadia's original drawing
`define A_MUX_B 4'd12 //new from nadia's original drawing

//DR_MUX chooses between 5:3 of opcode, 2:0 of opcode, HL, BC, DE, SP, and B as DR
`define DR_MUX_DR 3'd0 //uses P if RP is set
`define DR_MUX_Z 3'd1
`define DR_MUX_HL 3'd2
`define DR_MUX_BC 3'd3
`define DR_MUX_DE 3'd4
`define DR_MUX_SP 3'd5
`define DR_MUX_B 3'd6

//MUX_EXEC_COND chooses between condition y, y-4, 0 (NZ), and 1 (Z)
`define MUX_EXEC_COND_Y 2'd0
`define MUX_EXEC_COND_Y_SUB_4 2'd1
`define MUX_EXEC_COND_NZ 2'd2
`define MUX_EXEC_COND_Z 2'd3

//PCMUX chooses between ALU (BUSC), IR (Absolute), PC + 1, y << 3, MDR, and 0x0066
`define PCMUX_ALU 3'd0
`define PCMUX_IR 3'd1
`define PCMUX_INC_PC 3'd2
`define PCMUX_Y_SHIFT 3'd3
`define PCMUX_MDR 3'd4
`define PCMUX_NMI 3'd5

//MARMUX chooses between SR1, MDR, MDR[7:0]`A, HL, BC, and ALU
`define MAR_MUX_SR1 0 //SR1 is HL if it's R6, even if not RP
`define MAR_MUX_MDR 1
`define MAR_MUX_MDR_A 2
`define MAR_MUX_HL 3
`define MAR_MUX_BC 4
`define MAR_MUX_DE 5
`define MAR_MUX_ALU 6

//MDR_MUX chooses between ALU, HL, and r[z]
`define MDR_MUX_ALU 0
`define MDR_MUX_HL 1
`define MDR_MUX_Z 2

//B_MUX chooses between MDR, SR2, HL, and 16-bit negative 2
`define B_MUX_MDR 0
`define B_MUX_SR2 1 //SR2 is RP if SR_RP set, R otherwise
`define B_MUX_HL 2
`define B_MUX_NEGTWO 3

//muxes
`define MUX_EXEC_COND_0 0//chooses between condition y, y-4, 0 (NZ), and 1 (Z). Same cycle, receives next flags from ALU, compares them to this signal, and uses it for condstall(I think?) and dec mctr
`define MUX_EXEC_COND_1 1
`define MUX_EXEC_COND `MUX_EXEC_COND_1:`MUX_EXEC_COND_0

`define PCMUX_0 2 //chooses between ALU (BUSC), IR (Absolute), PC + 1, y << 3, MDR, and 0x0066
`define PCMUX_1 3
`define PCMUX_2 4
`define PCMUX `PCMUX_2:`PCMUX_0
`define PC_CONDLD 5 //if 1, only loads pc if condition met
`define CONDSTALL 6 //if 1, useq only uses stal1 if condition met

`define A_MUX_0 7 //chooses between y of opcode, z of opcode, HL, BC, DE, A, I, R, PC, MDR, Zero, and B as SR1
`define A_MUX_1 8
`define A_MUX_2 9
`define A_MUX_3 10
`define A_MUX `A_MUX_3:`A_MUX_0
`define B_MUX_0 11  //chooses between MDR, Z, HL, and 16-bit negative 2
`define B_MUX_1 12
`define B_MUX `B_MUX_1:`B_MUX_0

`define DR_MUX_0 13  //chooses between 5:3 of opcode, 2:0 of opcode, HL, BC, DE, SP, and B as DR
`define DR_MUX_1 14
`define DR_MUX_2 15
`define DR_MUX `DR_MUX_2:`DR_MUX_0
`define MAR_MUX_0 16 //chooses between SR1, MDR, MDR[7:0]`A, HL, BC, and ALU
`define MAR_MUX_1 17
`define MAR_MUX_2 18
`define MAR_MUX `MAR_MUX_2:`MAR_MUX_0

//register file signals
`define RP_TABLE 19// chooses which register pair table to load from
`define EXX 20

//bits 4-5 of opcode along with RP_TABLE select register pairs, but this doesn't get handled in RF if ALU has AF still
//sr1 will be R or RP uness overriden by specific register signals.
//sr2 output based on bits 5:3 of the opcode always
//Needs to be a separate port for HL

//ld signals other than reg file
`define LD_PC 21
`define LD_I 22 //loads I with output of ALU
`define LD_R 23
`define LD_REG 24
`define LD_MDR 25 //loads MDR with data from MDR_MUX
`define LD_MAR 26

//usequencer signals
`define DEC_MCTR_CC 27
`define DEC2_MCTR_CC 28
`define STALL_1 29//we can stall either 1 or 2 cycles in certain places
`define STALL_2 30

//system signals
`define HALT_SIG 31   //does something in datapath somewhere
`define INT_FF_RESET 32//sets
`define INT_FF_SET 33
`define IFF2_TO_IFF1 34//IFF2 --> IFF1
`define LD_INT_MODE 35//loads interrupt mode with Y (I think 0 1 and 2 are only valid ones)

//alu signals
`define ZEXT6(VALUE) ({6{1'b0}} | (VALUE))
`define ALU_OP_0 36
`define ALU_OP_1 37
`define ALU_OP_2 38
`define ALU_OP_3 39
`define ALU_OP_4 40
`define ALU_OP_5 41
`define ALU_OP_6 42
`define ALU_OP `ALU_OP_6:`ALU_OP_0
`define LD_ACCUM 43 //Loads A to be equal to result of ALU (hopefully)

`define RP 44 //r[y] is now RP[p] for both a_mux and dr_mux
`define EXEC_COND_MUX 45//chooses which condition to use
`define MDR_MUX_0 46 //chooses between ALU result, HL, and r[z]
`define MDR_MUX_1 47
`define MDR_MUX `MDR_MUX_1:`MDR_MUX_0
`define SEXT_MDR 48 //output of MDR into B_MUX is sext(MDR[7:0])
`define F_SWAP 49//swaps flags with alternate flags

`define CS_BITS 50
`define CS_BITS_MINUS_1 49
`define TOTAL_CS_BITS_MINUS_1 249

`define OCF 6'd0
`define MRH 6'd1
`define MRL 6'd2
`define MR  6'd2
`define MWH 6'd3
`define MWL 6'd4
`define MW  6'd4
`define ODH 6'd5
`define ODL 6'd6
`define OD  6'd6
`define PR  6'd7
`define PW  6'd8
`define SRH 6'd9
`define SRL 6'd10
`define SR  6'd10
`define SWH 6'd11
`define SWL 6'd12
`define SW  6'd12
`define IO  6'd13
`define IO2 6'd14

/*

T-STATE MACHINE SIGNALS

MREQ
WRITE
RFSH (Signals mem to refresh, and gates the refresh address onto bus)
GATE_PC (PC to addrbus)
GATE_AddrReg (AddrReg to addrbus)
GATE_SP (SP to addrbus)
LD_IR (D[7:0] to IR on rising edge)
LD_MDR (D[7:0] to MDR on falling edge)
MREQ_R (Reset MREQ on falling T clock edge)
MREQ_S_RE (Set MREQ on rising T clock edge, but only if WAIT is low)
MREQ_S_FE (Reset MREQ on falling T clock edge)
IORQ_R (Reset IORQ on rising T clock edge)
IORQ_S_RE (Set IORQ on rising T clock edge)
IORQ_S_FE (Set IORQ on falling T clock edge)
RD_R (Reset RD on falling T clock edge)
RD_S_RE (Set RD on rising T clock edge, but only if WAIT is low)
RD_S_FE (Set RD on falling T clock edge)
WR_R (Reset WR on falling T clock edge)
WR_R_RE (Reset WR on rising T clock edge)
WR_S (Set WR on falling T clock edge)
Last_T (signal to the uSequencer to get the correct next m-cycle)
CS_Set (reads the correct control store and sets control signals for all of the M cycles, among other things)
EXEC (outputs the variable signals for the current M-cycle (see spec below))
LD_PC
PCMUX
LD_SP
SP_MUX
JANK (Set for any M-cycle that needs to take extra cycles for no reason)
GATE_d(Output operand to data line on falling edge, stop outputting on rising edge somehow)
M1

*/

`define J0 0
`define J1 1
`define J2 2
`define J3 3
`define J4 4
`define J5 5
`define J6 6
`define JBITS `J6:`J0

`define COND0 7 //wait
`define COND1 8 //stall

`define CS_SET 9

`define M1_HIGH 10
`define RFSH 11
`define BUSACK 12

// These external signals can be controlled on rising or falling edge
// _R    - set to 0 on falling edge of current cycle
// _S_RE - set to 1 on rising edge of next cycle
// _S_FE - set to 1 on falling edgo of current cycle
`define MREQ_R 13 //(Reset MREQ on falling T clock edge)
`define MREQ_S_RE 14 //(Set MREQ on rising T clock edge, but only if WAIT is low)
`define MREQ_S_FE 15 //(SET MREQ on falling T clock edge)
`define IORQ_R 16 //(Reset IORQ on rising T clock edge)
`define IORQ_S_RE 17 //(Set IORQ on rising T clock edge, but only if WAIT is low)
`define IORQ_S_FE 18 //(Set IORQ on falling T clock edge)
`define RD_R 19 //(Reset RD on falling T clock edge)

`define RD_S_RE 20 //(Set RD on rising T clock edge, but only if WAIT is low)
`define RD_S_FE 21 //(Set RD on falling T clock edge)
`define WR_R 22 //(Reset WR on falling T clock edge)
`define WR_S_RE 23 //(Reset WR on rising T clock edge)
`define WR_S_FE 24 //(Set WR on falling T clock edge)

// HALT is special because it is set by an exec signal, not a t-state signal
`define HALT_R 25

`define EXEC 26
`define LAST_T 27
`define GATE_PC 28 //(PC to addrbus)
`define GATE_MARL 29 //(MAR to addrbus)
`define GATE_MARH 30 //(MAR + 1 to addrbus)
`define GATE_SP_INC 31 //(SP to addrbus)
`define GATE_SP_DEC 32 //(SP - 1 to addrbus)
`define LD_IR 33 //(D[7:0] to IR on rising edge)
`define LD_MDRL 34 //(D[7:0] to MDR[7:0] on falling edge)
`define LD_MDRH 35 //(D[15:8] to MDR[15:8] on falling edge)
`define INC_PC 36 //overrides LD_PC from exec, and loads PC with PC + 1
`define LD_SP 37 //overrides LD_SP from exec, and loads SP with SP_MUX
`define SP_MUX 38 //chooses between SP + 1 and SP - 1
`define GATE_MDRL 39 //(Output MDR[7:0] to data line on falling edge, stop outputting after lastT on rising edge)
`define GATE_MDRH 40 //(Output MDR[15:8] to data line on falling edge, stop outputting on lastT on rising edge)
`define MDR_TEMP 41 //swaps MDR and TEMP regs
`define IFF1_R_TO_IFF2 42 //IFF1 --> IFF2, clear IFF1
`define RD_R_RE 43 //(Reset RD on rising T clock edge)
`define WR_R_RE 44 //(Reset WR on rising T clock edge)
`define NMI_JANK 45 //set high when decoding during NMI

`define TSIGNALS 45
