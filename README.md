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

This project is sponsored and partially funded by an industry company, [Phoenix Semiconductor](https://www.phoenixsemicorp.com/).

## Tools
Given the nature of an FPGA-based processor emulator, we opted to use as many industry-standard tools as possible. Our RTL is written in Verilog under the Vivado Design Suite, targeting a Spartan-7 **XC7S15** FPGA for final project completion. We are hoping to acquire physical testing equipment to validate circuit boards. Our hardware is designed using KiCad, as the University does not provide licenses for software such as Altium or Allegro.

## Building and Testing
TBD. RTL is still in progress. We hope to begin physical testing at the beginning of 2025.
