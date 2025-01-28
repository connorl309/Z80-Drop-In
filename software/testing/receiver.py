import serial
import serial.tools.list_ports as port_list

print("Dumping list of available serial ports...")
ports = list(port_list.comports())
for p in ports:
    print(f"*\t{p}")

port = None

# Call prep() before read_signals()
def prep():

    input_port = input("\nEnter serial port to connect to (read data from): ")

    port = serial.Serial(input_port)

def read_signals() -> bytes:
    if port is None:
        raise ValueError("Call prep() before read_signals()!")
    read_bytes = port.read(5)
    return read_bytes