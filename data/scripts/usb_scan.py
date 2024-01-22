import re
import json
import subprocess

# Run the "lsusb -v" command and capture its output
try:
    lsusb_output = subprocess.check_output(["lsusb", "-v"], stderr=subprocess.DEVNULL, universal_newlines=True)
except subprocess.CalledProcessError as e:
    print(f"Error running lsusb: {e}")
    lsusb_output = ""

# Split the output into individual entries
entries = lsusb_output.split('\n\n')

# Define a function to process each entry
def process_entry(entry):
    pattern = re.compile(r"Device Descriptor:(.*?)Configuration Descriptor:", re.DOTALL)
    match = pattern.search(entry)
    if match:
        device_descriptor_text = match.group(1)
        device_descriptor_dict = {}
        lines = device_descriptor_text.strip().split("\n")
        for line in lines:
            key, value = line.strip().split(None, 1)
            device_descriptor_dict[key.strip()] = value.strip()
        return device_descriptor_dict
    return None

# Process each entry and store the results in a list
result_list = []
for entry in entries:
    device_descriptor = process_entry(entry)
    if device_descriptor:
        result_list.append(device_descriptor)

# Convert the list of dictionaries to JSON
json_output = json.dumps(result_list, indent=2)
print(json_output)

