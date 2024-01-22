import os
import sys
import configparser
import argparse
import json

RENOGY_BT_PATH = '/lib/renogy-bt';

if not os.path.isfile(f"{RENOGY_BT_PATH}/renogybt/__init__.py"):
    raise FileNotFoundError(f"The `renogy-bt` repo must be cloned in {RENOGY_BT_PATH}.")

sys.path.append(RENOGY_BT_PATH)

from renogybt import InverterClient, RoverClient, RoverHistoryClient, BatteryClient, DataLogger, Utils

parser = argparse.ArgumentParser(description="Retrieves data from Renogy / SRNE MPPT controllers and prints it as JSON")
parser.add_argument("-d", "--device", dest="device", help="Specify remote Bluetooth address", metavar="MAC", required=True)
parser.add_argument("-m", "--mode", dest="mode", help="Mode: history or status (default)", default="status")
args = parser.parse_args()

config = configparser.ConfigParser()
device_type = "RNG_CTRL" if args.mode == "status" else "RNG_CTRL_HIST"

config['device'] = {"adapter": "hci0", "alias": "", "mac_addr": args.device, "type": device_type, "device_id": "255"}
config['data'] = {"temperature_unit": "C", "fields": ""}
config['remote_logging'] = {}
config['mqtt'] = {}
config['pvoutput'] = {}

def on_data_received(client, data):
  filtered_data = Utils.filter_fields(data, config['data']['fields'])
  print(json.dumps(filtered_data, indent=1, sort_keys=False))
  client.disconnect()
  return filtered_data

if args.mode == "status":
    RoverClient(config, on_data_received).connect()
elif args.mode == "history":
    RoverHistoryClient(config, on_data_received).connect()