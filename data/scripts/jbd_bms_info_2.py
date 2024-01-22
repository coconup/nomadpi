#!/usr/bin/env python3

import argparse
import pexpect
import json

# Constants
MAX_ATTEMPTS = 10
BYTE_ORDER = 'big'
HEADER_SIZE = 2
CHECKSUM_SIZE = 2
EOR_SIZE = 1
RESPONSE_HEADER_SIZE = 4

# Command line parameters
parser = argparse.ArgumentParser(description="Retrieve values from LIONTRON LX Smart BMS 12.8V 100Ah and print as JSON")
parser.add_argument("-d", "--device", dest="device", help="Specify remote Bluetooth address", metavar="MAC", required=True)
parser.add_argument("-v", "--verbose", dest="verbose", help="Verbosity", action='count', default=0)
args = parser.parse_args()

# Function to extract values from response
def extract_values(response, data_format):
    if response.endswith(b'w') and response.startswith(data_format):
        response = response[HEADER_SIZE:-EOR_SIZE]
        return response

# Function to convert protection state to text
def get_protection_state_text(binary_state):
    protection_states = [
        "ok", "CellBlockOverVolt", "CellBlockUnderVol", "BatteryOverVol", "BatteryUnderVol",
        "ChargingOverTemp", "ChargingLowTemp", "DischargingOverTemp", "DischargingLowTemp",
        "ChargingOverCurrent", "DischargingOverCurrent", "ShortCircuit", "ForeEndICError", "MOSSoftwareLockIn"
    ]
    active_states = [protection_states[i] for i, bit in enumerate(binary_state) if bit == "1"]
    return active_states

# Run gatttool interactively.
child = pexpect.spawn(f"gatttool -I -b {args.device}")

# Connect to the device
for attempt in range(MAX_ATTEMPTS):
    try:
        if args.verbose: print(f"BMS connecting (Try: {attempt + 1})")
        child.sendline("connect")
        child.expect("Connection successful", timeout=1)
    except pexpect.TIMEOUT:
        if args.verbose == 2: print(child.before)
        continue
    else:
        if args.verbose: print("BMS connection successful")
        break
else:
    if args.verbose: print ("BMS Connect timeout! Exit")
    child.sendline("exit")
    print("{}")
    exit()    

# Define data formats
data_formats = {
    "data1": b'\xdd\x03',
    "data2": b'\xdd\x04',
    "data3": b'\xdd\x05'
}

# Request and process data
raw_data = {}
for data_name, data_format in data_formats.items():
    for attempt in range(MAX_ATTEMPTS):
        try:
            response = b''
            if args.verbose: print(f"BMS requesting {data_name} (Try: {attempt + 1})")
            command = f"char-write-req 0x0015 dda50{data_name[-1]}00fffd77"
            child.sendline(command)
            child.expect("Notification handle = 0x0011 value: ", timeout=1)
            child.expect("\r\n", timeout=0)
            if args.verbose: print(f"BMS received {data_name}")
            if args.verbose == 2: print(f"BMS answer {data_name}:", child.before)
            response += child.before
        except pexpect.TIMEOUT:
            continue
        else:
            break
    else:
        response = b''
        if args.verbose: print(f"BMS {data_name} timeout!")
        if args.verbose == 2: print(child.before)

response = extract_values(response, data_format)
if response:
    raw_data[data_name] = response

# Close connection
if args.verbose: print("Response: ", response)
if args.verbose: print("BMS disconnecting")
child.sendline("disconnect")
child.sendline("exit")

# Process and print JSON
processed_data = {}
for data_name, response in raw_data.items():
    response = response[:-CHECKSUM_SIZE]
    processed_data[data_name] = bytearray.fromhex(response.decode())

# Extract and format specific values
if "data1" in processed_data:
    response = processed_data["data1"]
    if response.endswith(b'w'):
        response = response[RESPONSE_HEADER_SIZE:]
        raw_data['Vmain'] = int.from_bytes(response[0:2], byteorder=BYTE_ORDER, signed=True) / 100.0
        raw_data['Imain']=int.from_bytes(response[2:4], byteorder = 'big',signed=True)/100.0 #current [A]
        raw_data['RemainAh']=int.from_bytes(response[4:6], byteorder = 'big',signed=True)/100.0 #remaining capacity [Ah]
        raw_data['NominalAh']=int.from_bytes(response[6:8], byteorder = 'big',signed=True)/100.0 #nominal capacity [Ah]
        raw_data['NumberCycles']=int.from_bytes(response[8:10], byteorder = 'big',signed=True) #number of cycles
        raw_data['ProtectState']=int.from_bytes(response[16:18],byteorder = 'big',signed=False) #protection state
        raw_data['ProtectStateBin']=format(rawdat['ProtectState'], '016b') #protection state binary
        raw_data['SoC']=int.from_bytes(response[19:20],byteorder = 'big',signed=False) #remaining capacity [%]
        raw_data['TempC1']=(int.from_bytes(response[23:25],byteorder = 'big',signed=True)-2731)/10.0
        raw_data['TempC2']=(int.from_bytes(response[25:27],byteorder = 'big',signed=True)-2731)/10.0
        protection_state = int.from_bytes(response[16:18], byteorder=BYTE_ORDER, signed=False)
        raw_data['ProtectStateBin'] = format(protection_state, '016b')
        raw_data['ProtectStateText'] = get_protection_state_text(raw_data['ProtectStateBin'])

# Extract cell voltages
if "data2" in processed_data:
    response = processed_data["data2"]
    if response.endswith(b'w'):
        response = response[RESPONSE_HEADER_SIZE:-EOR_SIZE]
        cell_count = len(response) // 2
        if args.verbose == 2: print("Detected Cellcount:", cell_count)
        raw_data['CellVoltages'] = [int.from_bytes(response[cell * 2:cell * 2 + 2], byteorder=BYTE_ORDER, signed=True) / 1000.0 for cell in range(cell_count)]

# Extract BMS Name
if "data3" in processed_data:
    response = processed_data["data3"]
    if response.endswith(b'w'):
        raw_data['Name'] = response[RESPONSE_HEADER_SIZE:-EOR_SIZE].decode("ASCII")

# Print JSON
print(json.dumps(raw_data, indent=1, sort_keys=False))
