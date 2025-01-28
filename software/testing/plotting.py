from __future__ import annotations

from pin_parsing import *
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec

pin_names_list_customorder = [
    # Control signals
    "MREQ", "M1", "RD", "WR", "CLK",

    # Address lines
    "A15", "A14", "A13", "A12", "A11", "A10", "A9", "A8",
    "A7", "A6", "A5", "A4", "A3", "A2", "A1", "A0",
    
    # Data lines
    "D7", "D6", "D5", "D4", "D3", "D2", "D1", "D0",
    
    # Bus/Interrupt signals
    "BUSRQ", "BUSAK", "WAIT", "RESET",
    
    # Special signals
    "INT", "NMI", "HALT"
]


def create_plots():
    # fig = plt.figure()
    fig, axes = plt.subplots(len(pin_names_list), 1, layout='constrained', figsize=(15, len(pin_names_list) * 1.5))
    # fig.set_size_inches(14, 10)
    
    gs = fig.add_gridspec(len(pin_names_list), 1)
    signal_axes = []

    # Setup plot
    # No X-axes (time)
    for (idx, name), ax in enumerate(pin_names_list_customorder, axes.flat):
        ax.set_title(name)

    return fig