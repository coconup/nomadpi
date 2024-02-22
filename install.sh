#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt install -y \
    python3-setuptools \
    vim \
    direnv \
    nodejs \
    npm

echo 'Cloning nomadPi repositories'

cd "$HOME"
git clone git@github.com:coconup/nomadpi.git

cd "nomadpi"
install_dir=$(pwd)

mkdir volumes
git clone git@github.com:coconup/nomadpi-app-api.git volumes/nomadpi-app-api
git clone git@github.com:coconup/nomadpi-services-api.git volumes/nomadpi-services-api
git clone git@github.com:coconup/nomadpi-react.git volumes/nomadpi-react
git clone git@github.com:coconup/nomadpi-mqtt-hub.git volumes/nomadpi-mqtt-hub
git clone git@github.com:coconup/nomadpi-gpsd-to-mqtt.git volumes/nomadpi-gpsd-to-mqtt
git clone git@github.com:coconup/nomadpi-butterfly-ai volumes/nomadpi-butterfly-ai
git clone git@github.com:coconup/nomadpi-open-wake-word volumes/nomadpi-open-wake-word
git clone git@github.com:coconup/nomadpi-ble-to-mqtt volumes/nomadpi-ble-to-mqtt

cd volumes/nomadpi-ble-to-mqtt
./install.sh

cd "$install_dir"

clone_nodered_project() {
    local repo_name=$1
    mkdir -p "volumes/$repo_name/data/"
    cp -r "services/$repo_name/data" "volumes/$repo_name/"
    mkdir "volumes/$repo_name/data/projects"
    git clone "git@github.com:coconup/$repo_name" "volumes/$repo_name/data/projects/$repo_name"
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
echo "REACT_APP_RPI_HOSTNAME=${RPI_HOSTNAME}" > volumes/nomadpi-react/.env

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
# sudo debconf-set-selections <<EOF
# iptables-persistent iptables-persistent/autosave_v4 boolean true
# iptables-persistent iptables-persistent/autosave_v6 boolean true
# EOF

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
