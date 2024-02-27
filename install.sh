#!/bin/bash

set -e  # Exit script on any error

# Function for handling errors
handle_error() {
    local exit_code=$?
    echo "Error occurred in command: $BASH_COMMAND"
    echo "Exit code: $exit_code"
    exit $exit_code
}

# Function to display the tail of a file with custom message and colors
display_tail() {
    local file=$1
    local message=$2
    echo -e "\e[94m$message\e[0m"  # Light blue color for echo
    tail -n 10 "$file" | awk '{print "\033[37m" $0 "\033[0m"}'  # Light grey color for tail
}

# Redirecting stdout and stderr to a temporary file
# exec > >(tee -i /tmp/script_stdout.log)
# exec 2> >(tee -i /tmp/script_stderr.log >&2)

trap 'handle_error' ERR

sudo apt update
# display_tail "/tmp/script_stdout.log" "Updating packages"
sudo apt upgrade -y
# display_tail "/tmp/script_stdout.log" "Installing dependencies"
sudo apt install -y \
    python3-setuptools \
    vim \
    direnv \
    nodejs \
    npm \
    jq

echo 'Cloning nomadPi repositories'

cd "$HOME" || exit 1

mkdir -p "$HOME"/.ssh
curl --silent https://api.github.com/meta | jq --raw-output '"github.com "+.ssh_keys[]' >> "$HOME"/.ssh/known_hosts

git clone git@github.com:coconup/nomadpi.git

cd "nomadpi" || exit 1
install_dir=$(pwd)

ssh-keyscan github.com >> ~/.ssh/known_hosts

mkdir -p "$install_dir"/volumes
git clone git@github.com:coconup/nomadpi-app-api.git "$install_dir"/volumes/nomadpi-app-api
git clone git@github.com:coconup/nomadpi-services-api.git "$install_dir"/volumes/nomadpi-services-api
git clone git@github.com:coconup/nomadpi-react.git "$install_dir"/volumes/nomadpi-react
git clone git@github.com:coconup/nomadpi-mqtt-hub.git "$install_dir"/volumes/nomadpi-mqtt-hub
git clone git@github.com:coconup/nomadpi-gpsd-to-mqtt.git "$install_dir"/volumes/nomadpi-gpsd-to-mqtt
git clone git@github.com:coconup/nomadpi-butterfly-ai "$install_dir"/volumes/nomadpi-butterfly-ai
git clone git@github.com:coconup/nomadpi-open-wake-word "$install_dir"/volumes/nomadpi-open-wake-word
git clone git@github.com:coconup/nomadpi-ble-to-mqtt "$install_dir"/volumes/nomadpi-ble-to-mqtt

cd volumes/nomadpi-ble-to-mqtt
./install.sh

cd "$install_dir" || exit 1

clone_nodered_project() {
    local repo_name=$1
    mkdir -p "$install_dir/volumes/$repo_name/data/"
    cp -r "$install_dir/services/$repo_name/data" "$install_dir/volumes/$repo_name/"
    mkdir "$install_dir/volumes/$repo_name/data/projects"
    git clone "git@github.com:coconup/$repo_name" "$install_dir/volumes/$repo_name/data/projects/$repo_name"
}

clone_nodered_project "nomadpi-core-api"
clone_nodered_project "nomadpi-automation-api"

# Add direnv to .bashrc
echo 'Setting up `direnv``'
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc

direnv_config_file="$HOME/.config/direnv/config.toml"

# Create the directory if it doesn't exist
mkdir -p "$(dirname "$direnv_config_file")"

# Configure direnv to always allow .envrc
cat <<EOF > "$direnv_config_file"
[whitelist]
prefix = ["$install_dir"]
EOF

# Create .envrc file
echo 'Generating environment variables'
source ./generate_envrc.sh
echo "REACT_APP_RPI_HOSTNAME=$(hostname).local" > "$install_dir/volumes/nomadpi-react/.env"

# Initialize secret files
echo 'Initializing docker secrets'
mkdir -p volumes/secrets/cloudflare
mkdir -p volumes/secrets/nextcloud
touch volumes/secrets/cloudflare/tunnel_token
touch volumes/secrets/nextcloud/nextcloud_host
touch volumes/secrets/nextcloud/nextcloud_username
touch volumes/secrets/nextcloud/nextcloud_password

# Enable I2C and 1-Wire
echo 'Enabling I2C and 1-Wire'
sudo raspi-config nonint do_i2c 0
echo -e "dtoverlay=w1-gpio\ndtoverlay=uart5\nenable_uart=1" | sudo tee -a /boot/config.txt

# Docker patches
echo 'Patching system for `docker` compatibility'
echo $(cat /boot/cmdline.txt) cgroup_memory=1 cgroup_enable=memory | sudo tee /boot/cmdline.txt
if [ -e "/etc/dhcpcd.conf" ]; then
    sudo bash -c '[ $(egrep -c "^allowinterfaces eth\*,wlan\*" /etc/dhcpcd.conf) -eq 0 ] && echo "allowinterfaces eth*,wlan*" >> /etc/dhcpcd.conf'
fi

# Install docker
echo 'Installing `docker`` and `docker-compose`'
cd /tmp
curl -fsSL https://raw.githubusercontent.com/SensorsIot/IOTstack/master/install.sh | bash