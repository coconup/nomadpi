import os
import sys
import configparser
import argparse
import json

# Constants
MAX_ATTEMPTS = 10
RENOGY_BT_PATH = '/lib/renogy-bt';

if not os.path.isfile(f"{RENOGY_BT_PATH}/renogybt/__init__.py"):
    raise FileNotFoundError(f"The `renogy-bt` repo must be cloned in {RENOGY_BT_PATH}.")

sys.path.append(RENOGY_BT_PATH)

from renogybt import InverterClient, RoverClient, RoverHistoryClient, BatteryClient, DataLogger, Utils

parser = argparse.ArgumentParser(description="Retrieves data from Renogy / SRNE MPPT controllers and prints it as JSON")
parser.add_argument("-d", "--device", dest="device", help="Specify remote Bluetooth address", metavar="MAC", required=True)
parser.add_argument("-v", "--verbose", dest="verbose", help="Verbosity", action='count', default=0)
args = parser.parse_args()

config = configparser.ConfigParser()

config['device'] = {"adapter": "hci0", "alias": "", "mac_addr": args.device, "type": "RNG_CTRL", "device_id": "255"}
config['data'] = {"temperature_unit": "C", "fields": ""}
config['remote_logging'] = {}
config['mqtt'] = {}
config['pvoutput'] = {}

if args.verbose: print ("Config: ", config)

def on_data_received(client, data):
  filtered_data = Utils.filter_fields(data, config['data']['fields'])
  print(json.dumps(filtered_data, indent=1, sort_keys=False))
  client.disconnect()
  return filtered_data

success = False

for attempt in range(MAX_ATTEMPTS):
	try:
        if args.verbose: print(f"MPPT connecting (attempt {attempt + 1})")
        RoverClient(config, on_data_received).connect()
        success = True
        break
    except Exception as e:
        if args.verbose: print(f"Attempt {attempt + 1} failed: {e}")