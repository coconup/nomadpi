#!/usr/bin/env python3

import argparse
import pexpect
import json

# Constants
MAX_ATTEMPTS = 10
BYTE_ORDER='big'
RESPONSE_HEADER_SIZE = 4
EOR_SIZE = 3

parser = argparse.ArgumentParser(description="Retrieve values from JBD BMS and print as JSON")
parser.add_argument("-d", "--device", dest="device", help="Specify remote Bluetooth address", metavar="MAC", required=True)
parser.add_argument("-v", "--verbose", dest="verbose", help="Verbosity", action='count', default=0)
args = parser.parse_args()

def parse_bytes(value, signed):
    return int.from_bytes(value, byteorder=BYTE_ORDER, signed=signed)

def get_protection_state_text(state):
    binary_state = format(state, '016b')
    if binary_state[0] == "1": return "cell_over_voltage" 
    if binary_state[1] == "1": return "cell_under_voltage" 
    if binary_state[2] == "1": return "battery_over_voltage" 
    if binary_state[3] == "1": return "battery_under_voltage"
    if binary_state[4] == "1": return "charging_over_temperature" 
    if binary_state[5] == "1": return "charging_low_temperature" 
    if binary_state[6] == "1": return "discharging_over_temperature" 
    if binary_state[7] == "1": return "discharging_low_temperature" 
    if binary_state[8] == "1": return "charging_over_current" 
    if binary_state[9] == "1": return "discharging_over_current" 
    if binary_state[10] == "1": return "short_circuit" 
    if binary_state[11] == "1": return "fore_end_ic_error" 
    if binary_state[12] == "1": return "mos_software_lock_in"
    return "ok"

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
commands = {
    "data1": {
        "command": "dda50300fffd77",
        "answers": 2
    },
    "data2": {
        "command": "dda50400fffc77",
        "answers": 1
    },
    "data3": {
        "command": "dda50500fffb77",
        "answers": 1
    }
}

# Request and process data
raw_data = {}
for data_name, spec in commands.items():
    command = spec['command']
    for attempt in range(MAX_ATTEMPTS):
        try:
            response = b''
            if args.verbose: print(f"BMS requesting {data_name} (Try: {attempt + 1})")
            cmd = f"char-write-req 0x0015 {command}"
            if args.verbose == 2: print(f"BMS command {data_name}:", cmd)
            child.sendline(cmd)
            for answer_nr in range(spec['answers']):
                child.expect("Notification handle = 0x0011 value: ", timeout=1)
                child.expect("\r\n", timeout=0)
                if args.verbose: print(f"BMS received {data_name}")
                if args.verbose == 2: print(f"BMS answer {data_name} {answer_nr}:", child.before)
                response += child.before
        except pexpect.TIMEOUT:
            continue
        else:
            break
    else:
        response = b''
        if args.verbose: print(f"BMS {data_name} timeout!")
        if args.verbose == 2: print(child.before)

    if args.verbose == 2: print(f"BMS response {data_name}:", response)
    if response:
        raw_data[data_name] = response[:-1]

# Close connection
if args.verbose: print("Raw data: ", raw_data)
if args.verbose: print("BMS disconnecting")
child.sendline("disconnect")
child.sendline("exit")

# Process and print JSON
processed_data = {}
for data_name, response in raw_data.items():
    processed_data[data_name] = bytearray.fromhex(response.decode())

if args.verbose == 2: print(f"BMS processed_data:", processed_data)

data = {
    "voltage": {},
    "capacity": {}
}

# Extract and format specific values
if "data1" in processed_data:
    response = processed_data["data1"]
    if response.endswith(b'w'):
        response = response[RESPONSE_HEADER_SIZE:]
        data['voltage']['total'] = parse_bytes(response[0:2], True) / 100.0
        data['current_load'] = parse_bytes(response[2:4], True) / 100.0
        data['capacity']['remaining'] = parse_bytes(response[4:6], True) / 100.0
        data['capacity']['total'] = parse_bytes(response[6:8], True) / 100.0
        data['cycles_count'] = parse_bytes(response[8:10], True)
        data['protect_state'] = get_protection_state_text(parse_bytes(response[16:18], False))
        data['state_of_charge'] = parse_bytes(response[19:20], False)
        data['temperature_1'] = (parse_bytes(response[23:25], True) - 2731) / 10.0
        data['temperature_2'] = (parse_bytes(response[25:27], True) - 2731) / 10.0

# Extract cell voltages
if "data2" in processed_data:
    response = processed_data["data2"]
    if response.endswith(b'w'):
        response = response[RESPONSE_HEADER_SIZE:-EOR_SIZE]
        cells_count = len(response) // 2
        if args.verbose == 2: print("Detected Cellcount:", cells_count)
        data['voltage']['cells'] = [int.from_bytes(response[cell * 2:cell * 2 + 2], byteorder=BYTE_ORDER, signed=True) / 1000.0 for cell in range(cells_count)]
        data['cells_count'] = cells_count

# Extract BMS Name
if "data3" in processed_data:
    response = processed_data["data3"]
    if response.endswith(b'w'):
        data['name'] = response[RESPONSE_HEADER_SIZE:-EOR_SIZE].decode("ASCII")

# Print JSON
print(json.dumps(data, indent=1, sort_keys=False))
