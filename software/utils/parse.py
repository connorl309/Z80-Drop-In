from __future__ import annotations
from typing import List
import re

f = open("./instructions.txt", "r")

alu_ops = ["ADD", "ADC", "SUB", "SBC", "AND", "OR", "XOR", "CP"]

def translate(input_line):
    output_list = []
    if "/" in input_line[0]:
        string = input_line[0]
        orig1, orig2 = string.split("/")
        input_line[0] = orig1
        input_line.insert(1, orig2)
    for item in input_line:
        # Split the input by '/'
        #parts = item.split('/')
        # Use regex to capture the text before parentheses and the number inside parentheses
        match = re.match(r'([A-Z]+)\((\d+)\)', item)
        if match:
            prefix, number = match.groups()
            output_list.append(f"STATE_{prefix}_{number}")
    
    return output_list

lines = [l.lstrip() for l in f]
lines = list(filter(None, lines))
for a in lines:
    split = a.split("\t")
    split = list(filter(None, split))
    if len(split) < 2:
        print("Manual microcode settings required: " + str(split))
        None
    else:
        newlist = split[2:]
        if ("ALU" in split[0]):
            for op in alu_ops:
                res = translate(newlist)
                print("{0:15}".format(op + split[0].removeprefix("ALU")), end="\t\t")
                for i in res:
                    print(i, end='\t')
                print()
        else:
            res = translate(newlist)
            print("{0:15}".format(split[0]), end="\t\t")
            for i in res:
                print(i, end='\t')
            print()