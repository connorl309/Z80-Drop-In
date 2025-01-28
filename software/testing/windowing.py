from __future__ import annotations
import sys
import random
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.pyplot import Figure
import multiprocessing

import plotting

from PyQt5.QtWidgets import (
                        QWidget,
                        QApplication,
                        QMainWindow,
                        QVBoxLayout,
                        QScrollArea,
                    )

from matplotlib.backends.backend_qt5agg import (
                        FigureCanvasQTAgg as FigCanvas,
                        NavigationToolbar2QT as NabToolbar,
                    )

# Make sure that we are using QT5
matplotlib.use('Qt5Agg')

# create a figure and some subplots
FIG: Figure = plotting.create_plots()

def main():
    app = QApplication(sys.argv)
    FIG.set_size_inches(10, 20)
    window = MyApp(FIG)
    sys.exit(app.exec_())

class MyApp(QWidget):
    def __init__(self, fig):
        super().__init__()
        self.title = 'Z80 Testing Waveform Viewer'
        self.posXY = (0, 0)
        self.windowSize = (1200, 800)
        self.fig = fig
        
        self.initUI()

    def initUI(self):
        QMainWindow().setCentralWidget(QWidget())

        self.setLayout(QVBoxLayout())
        self.layout().setContentsMargins(50, 25, 25, 25)
        self.layout().setSpacing(0)

        canvas = FigCanvas(self.fig)
        canvas.draw()

        scroll = QScrollArea(self)
        scroll.setWidget(canvas)

        nav = NabToolbar(canvas, self)
        self.layout().addWidget(nav)
        self.layout().addWidget(scroll)

        self.show_basic()

    def show_basic(self):
        self.setWindowTitle(self.title)
        self.setGeometry(*self.posXY, *self.windowSize)
        self.show()


if __name__ == '__main__':
    render_thread = multiprocessing.Process(target=main)
    render_thread.start()