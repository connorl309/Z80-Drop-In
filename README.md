# Z80-Drop-In
Relevant links and information:
- [Instruction Set](https://map.grauw.nl/resources/z80instr.php)
- [Z80 User Manual](https://www.zilog.com/docs/z80/um0080.pdf)
- [Master Reference Website](http://z80.info/)
- [Timing Quirks](https://floooh.github.io/2021/12/06/z80-instruction-timing.html#extra-clock-cycles)

## Summary
This is the Github repository for the senior design capstone project class at the University of Texas at Austin's ECE program (ECE 364/464). Our group is Industry Honors 01 (IH01), a Drop-in CPU Replacement for the Zilog Z80 processor, comprised of six members:

1. [Connor Leu](https://github.com/connorl309) - Team lead, organizer, maintainer, PCB design
2. [April Douglas](https://github.com/MaprilBear) - ALU RTL, processor design
3. [Gage Miller](https://github.com/millergage) - Register file RTL, processor design
4. [Luke Mason](https://github.com/Mega567835) - Control store, microsequencer, FSM design
5. [Nadia Houston](https://github.com/nadiahouston) - Control store, microsequencer, FSM design
6. [Gabriel Moore](https://github.com/K0-p) - Hardware testing, development boards

This project is considered an industry-honors project; as such, we are sponsored and primarily funded by an industry company, [Phoenix Semiconductor](https://www.phoenixsemicorp.com/).

The premise behind our drop-in replacement is to create a cycle-accurate processor core emulator on an FPGA. For our project, under company guidance, we are targeting the Spartan-7 XC7S15. The emulated processor core will sit on a supporting custom PCB, sized to the original form factor (approx. 17mm x 50mm) of the Zilog Z80. This PCB will then assume the position of a Z80 in any Z80 system, mimicking original processor behavior accurately.

The two major components of this project is the processor design and the hardware design. Our processor emulation core is split into datapath design and a control store/microcode FSM. The three major components of the datapath are the ALU, register file, and control logic. The control store and microcode represent our implementation of the original Z80's PLA for instruction decode and processor operation. Our RTL design decisions have been informed by over 40 years of processor execution behavior, the original user manual, and countless online documents written by reverse engineers and hobbyists. (see [Master Reference Website](http://z80.info/))

The hardware design is also split into two primary components: the devhat translation boards, used to level-shift our development boards 3.3V signals to the Z80 5V level and vice versa, and the System-in-Package board, which is the final goal of the project. The SiP board features the Spartan-7 FPGA, control hardware, QSPI flash memory, and other supporting circuitry in the size of the original Z80 package. Our hope is that this final board will be a true drop-in replacement for Z80 processors.

## Tools
Given the nature of an FPGA-based processor emulator, we opted to use as many industry-standard tools as possible. Our RTL is written in Verilog under the Vivado Design Suite, targeting a Spartan-7 **XC7S15** FPGA for final project completion. We are hoping to acquire physical testing equipment to validate circuit boards. Our hardware is designed using KiCad, as the University does not provide licenses for software such as Altium or Allegro.

## Building and Testing
Vivado's IP for FPGAs has lots of different blocks we can use. One such IP block is the [integrated logic analyzer (ILA)](https://www.xilinx.com/products/intellectual-property/ila.html). Instead of needing more PCBs or fancy test rigs, we can utilize the ILA directly on our development FPGA boards and dump waveforms right back out to the host PC and into the Vivado Waveform viewer. This is our primary method of testing and verification on the development boards (purchased from Numato - the Narvi S7). In addition to the ILA, our devboards also contain FTDI chips that let us communicate over serial to the host computer.
Our goal for devboard testing is to be able to execute any number of sample programs for the Z80, and verify that all control signals are accurate to both the M- and T-cycle level. This will likely take the form of short sample programs for all instructions, and then combined into larger test programs with more complex behavior whose validity will be examined on a results level, not a cycle level.
