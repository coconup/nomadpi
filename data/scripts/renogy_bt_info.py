import os
import sys
import configparser
import argparse
import logging

RENOGY_BT_PATH = '/lib/renogy-bt';

if not os.path.isfile(f"{RENOGY_BT_PATH}/renogybt/__init__.py"):
    raise FileNotFoundError(f"The `renogy-bt` repo must be cloned in {RENOGY_BT_PATH}.")

sys.path.append(RENOGY_BT_PATH)

from renogybt import InverterClient, RoverClient, RoverHistoryClient, BatteryClient, DataLogger, Utils

parser = argparse.ArgumentParser(description="Retrieves data from Renogy / SRNE MPPT controllers and dispatches the result to an MQTT topic")
parser.add_argument("-d", "--device", dest="device", help="Specify remote Bluetooth address", metavar="MAC", required=True)
parser.add_argument("-m", "--mode", dest="mode", help="Mode: history or status (default)", default="status")
parser.add_argument("-v", "--verbose", dest="verbose", help="Verbosity", action='count', default=0)
args = parser.parse_args()

if args.verbose:
    logging.basicConfig(level=logging.DEBUG)

config = configparser.ConfigParser()
device_type = "RNG_CTRL" if args.mode == "status" else "RNG_CTRL_HIST"

config['device'] = {"adapter": "hci0", "alias": "", "mac_addr": args.device, "type": device_type, "device_id": "255"}
config['data'] = {"temperature_unit": "C", "fields": ""}
config['remote_logging'] = {}
config['mqtt'] = {"enabled": True, "server": "127.0.0.1", "port": "1883", "topic": "renogy_bt/state", "user": "", "password": ""}
config['pvoutput'] = {}

data_logger: DataLogger = DataLogger(config)

def on_data_received(client, data):
    filtered_data = Utils.filter_fields(data, config['data']['fields'])
    filtered_data['mac_address'] = args.device
    data_logger.log_mqtt(json_data=filtered_data)
    client.disconnect()

if args.mode == "status":
    RoverClient(config, on_data_received).connect()
elif args.mode == "history":
    RoverHistoryClient(config, on_data_received).connect()