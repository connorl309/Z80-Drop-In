from __future__ import annotations
from typing import *
import sys

# Register container
class Registers():
    def __init__(self, AF: int = -1, BC: int = -1, DE: int = -1, HL: int = -1, 
                 SP: int = -1, PC: int = -1, IX: int = -1, IY: int = -1, 
                 I: int = -1, R: int = -1, IMM1: int = -1, IMM2: int = -1, 
                 IM: int = -1) -> None:
        self.registers = {
            "AF": AF, "BC": BC, "DE": DE, "HL": HL, "SP": SP, "PC": PC, 
            "IX": IX, "IY": IY, "I": I, "R": R, "IMM1": IMM1, "IMM2": IMM2, "IM": IM
        }


class Signals():
    def __init__(self, addr: int = -1, data: int = -1, clk: int = -1, busrq: int = -1, 
                 busak: int = -1, nmi: int = -1, interrupt: int = -1, wait: int = -1, 
                 halt: int = -1, refsh: int = -1, rd: int = -1, wr: int = -1, 
                 iorq: int = -1, mreq: int = -1, m1: int = -1) -> None:
        self.signals = {
            "addr": addr, "data": data, "clk": clk, "busrq": busrq, "busak": busak,
            "nmi": nmi, "interrupt": interrupt, "wait": wait, "halt": halt,
            "refsh": refsh, "rd": rd, "wr": wr, "iorq": iorq, "mreq": mreq, "m1": m1
        }



# What does a single clock cycle's output look like?
class CycleOutput():
    def __init__(self, RegVals: Registers, Pins: Signals, instruction_number: int, cycle_number: int) -> CycleOutput:
        # We have a set of registers and IO signals each cycle
        self.registers: Registers = RegVals
        self.pins: Signals = Pins
        self.instruction_number = instruction_number
        self.cycle_number = cycle_number

if __name__ == "__main__":
    args_list = sys.argv[1:]
    print(f"Running generator with arguments {args_list}")
    if (len(args_list) == 0):
        raise ValueError("Please specify a file for input.")
    
    filename = args_list[0]
    """
        We define test file output to be a bunch of $display 's from
        Vivado. At each cycle we will dump the following, in this order:

        address(hex) data(hex) clk busrq busak nmi interrupt wait halt refsh rd wr iorq mreq m1 (newline) # 15 numbers, space-separated
        AF BC DE HL SP PC IX IY I R IMM1 IMM2 IM # 13 numbers
        (blank line)
    """
    clock_cycles: int = 0
    instruction_number: int = 0
    cycle_list: List[CycleOutput] = []
    file = open(filename, 'r')
    lines = [line for line in file.readlines() if line.strip()]
    if (len(lines) % 2 != 0):
        raise AssertionError("The test file output must have an even number of output lines (pairs)!")

    for (sig, regs) in zip(lines[::2], lines[1::2]):
        siglist = sig.split(" ")
        reglist = regs.split(" ")
        if len(siglist) != 15:
            raise AssertionError(f"Number of signal values must be 15!\n{sig}")
        if len(reglist) != 13:
            raise AssertionError(f"Number of register values must be 13!\n{regs}")
        
        sigobj = Signals(int(siglist[0], 16), int(siglist[1], 16), int(siglist[2], 16), 
                  int(siglist[3], 16), int(siglist[4], 16), int(siglist[5], 16), 
                  int(siglist[6], 16), int(siglist[7], 16), int(siglist[8], 16), 
                  int(siglist[9], 16), int(siglist[10], 16), int(siglist[11], 16), 
                  int(siglist[12], 16), int(siglist[13], 16), int(siglist[14], 16))
        
        registers = Registers(int(reglist[0], 16), int(reglist[1], 16), int(reglist[2], 16), 
                    int(reglist[3], 16), int(reglist[4], 16), int(reglist[5], 16), 
                    int(reglist[6], 16), int(reglist[7], 16), int(reglist[8], 16), 
                    int(reglist[9], 16), int(reglist[10], 16), int(reglist[11], 16), 
                    int(reglist[12], 16))
        
        if (sigobj.signals["m1"] != 0):
            instruction_number += 1

        cycle_list.append(CycleOutput(registers, sigobj, instruction_number, clock_cycles))

        if (sigobj.signals["clk"] != 0):
            clock_cycles = clock_cycles + 1

    print("\nFinished input parse, verifying with reference solution output\n")
