#!/bin/bash

# Generate a random string of at least 12 characters
generate_random_string() {
  tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 24
}

# Get the hostname of the Raspberry Pi
rpi_hostname=$(hostname)

# Check if .envrc already exists
envrc_file=".envrc"
if [ -e "$envrc_file" ]; then
  echo "Error: $envrc_file already exists. Please delete or rename it before running this script."
  exit 1
fi

# Create .envrc file
echo "export ENCRYPTION_KEY=$(generate_random_string)" > "$envrc_file"
echo "export RPI_HOSTNAME=${rpi_hostname}.local" >> "$envrc_file"

echo "export DB_HOST=mariadb" >> "$envrc_file"
echo "export DB_USER=mariadbuser" >> "$envrc_file"
echo "export DB_NAME=default" >> "$envrc_file"
echo "export DB_PASSWORD=$(generate_random_string)" >> "$envrc_file"
echo "export DB_ROOT_PASSWORD=$(generate_random_string)" >> "$envrc_file"

echo "export GPSD_UDEV_KEY=nomadpi-gpsd-usb" >> "$envrc_file"
echo "export ZIGBEE_UDEV_KEY=nomadpi-zigbee-usb" >> "$envrc_file"

echo "export HUB_MQTT_TOPIC=nomadpi/mqtt_hub" >> "$envrc_file"
echo "export GPSD_MQTT_TOPIC=nomadpi/gps_values" >> "$envrc_file"

direnv allow