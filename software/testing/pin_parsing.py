from __future__ import annotations
from typing import Dict
import receiver

ALLOW_PRINTING = True

# Z80 pins in order
pins: Dict[str, int] = {
    "A11": None,
    "A12": None,
    "A13": None,
    "A14": None,
    "A15": None,
    "CLK": None,
    "D4": None,
    "D3": None,  # Pins 1–8
    "D5": None,
    "D6": None,
    "+5V": None,
    "D2": None,
    "D7": None,
    "D0": None,
    "D1": None,
    "INT": None,  # Pins 9–16
    "NMI": None,
    "HALT": None,
    "MREQ": None,
    "IORQ": None,
    "RD": None,
    "WR": None,
    "BUSAK": None,  # Pins 17–24
    "WAIT": None,
    "BUSRQ": None,
    "RESET": None,
    "M1": None,
    "REFSH": None,
    "GND": None,
    "A0": None,  # Pins 25–32
    "A1": None,
    "A2": None,
    "A3": None,
    "A4": None,
    "A5": None,
    "A6": None,
    "A7": None,
    "A8": None,
    "A9": None,  # Pins 33–40
    "A10": None,
}

pin_names_list = list(pins.keys())

def data_to_pins(bytes_array):
    if len(bytes_array) != 5:
        raise ValueError("Input must be exactly 5 bytes to map all 40 pins.")

    # Flatten the input bytes into a 40-bit representation
    idx = 0
    for byte in bytes_array:
        for bit_pos in range(8):
            pins[pin_names_list[idx*8 + bit_pos]] = (byte >> bit_pos) & 1
        idx += 1

    ### Print the pin names and groups ###
    if ALLOW_PRINTING:
        # Address line
        address_line = 0
        data_line = 0
        print("## ADDRESS / DATA ##")
        for i in range(0, 16):
            addr_bit = f"A{i}"
            address_line |= pins[addr_bit] << i
        print(f"A[15:0] = {hex(address_line) :04} [{bin(address_line) :08}]")
        # Data line
        for i in range(0, 8):
            data_bit = f"D{i}"
            data_line |= pins[data_bit] << i
        print(f"D[7:0] = {hex(data_line) :04} [{bin(data_line) :08}, {data_line}]\n")

        # Control signals
        print("## CONTROL SIGNALS ##")
        # int, nmi, halt, mreq, iorq, refsh, m1, reset, busrq, wait, busak, wr, rd

        # basic instruction stuff info
        print(f"IORQ | MREQ | M1 | RD | WR = [{pins['IORQ']} {pins['MREQ']} {pins['M1']} {pins['RD']} {pins['WR']}]")
        # bus / interrupt signals
        print(f"BUSRQ | BUSAK | WAIT | RESET = [{pins['BUSRQ']} {pins['BUSAK']} {pins['WAIT']} {pins['RESET']}]")
        # special signals
        print(f"INT | NMI | HALT = [{pins['INT']} {pins['NMI']} {pins['HALT']}]\n")

