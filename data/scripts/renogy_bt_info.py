import sys
import configparser

if len(sys.argv) != 2:
  print("Usage: python3 renogy-bt.py <mac_id>")
  sys.exit(1)

sys.path.append('/lib/renogy-bt')

from renogybt import InverterClient, RoverClient, RoverHistoryClient, BatteryClient, DataLogger, Utils

config = configparser.ConfigParser()

config['device'] = {"adapter": "hci0", "alias": "", "mac_addr": sys.argv[1], "type": "RNG_CTRL", "device_id": "255"}
config['data'] = {"temperature_unit": "C", "fields": ""}
config['remote_logging'] = {}
config['mqtt'] = {}
config['pvoutput'] = {}

def on_data_received(client, data):
  filtered_data = Utils.filter_fields(data, config['data']['fields'])
  print(filtered_data)
  client.disconnect()
  return filtered_data

RoverClient(config, on_data_received).connect()