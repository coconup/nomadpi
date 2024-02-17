#!/bin/bash

current_dir=$(pwd)

sudo apt update
sudo apt upgrade -y
sudo apt install -y \
    python3-setuptools \
    vim \
    direnv \
    nodejs \
    npm

echo 'Cloning VanPi stack repositories'

mkdir volumes
git clone git@github.com:coconup/vanpi-app-api.git volumes/vanpi-app-api
git clone git@github.com:coconup/vanpi-services-api.git volumes/vanpi-services-api
git clone git@github.com:coconup/vanpi-react.git volumes/vanpi-react
git clone git@github.com:coconup/vanpi-mqtt-hub.git volumes/vanpi-mqtt-hub
git clone git@github.com:coconup/vanpi-gpsd-to-mqtt.git volumes/vanpi-gpsd-to-mqtt
git clone git@github.com:coconup/vanpi-butterfly-ai volumes/vanpi-butterfly-ai
git clone git@github.com:coconup/vanpi-open-wake-word volumes/vanpi-open-wake-word

clone_nodered_project() {
    local repo_name=$1
    mkdir -p "volumes/$repo_name/data/projects"
    git clone "git@github.com:coconup/$repo_name" "volumes/$repo_name/data/projects/$repo_name"
    cd "volumes/$repo_name/data/projects/$repo_name"
    npm install
    cd "$current_dir"
}

clone_nodered_project "vanpi-core-api"
clone_nodered_project "vanpi-automation-api"

# Add direnv to .bashrc
echo 'Setting up `direnv``'
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc

direnv_config_file="$HOME/.config/direnv/config.toml"

# Create the directory if it doesn't exist
mkdir -p "$(dirname "$direnv_config_file")"

# Configure direnv to always allow .envrc
cat <<EOF > "$direnv_config_file"
[whitelist]
prefix = ["$current_dir"]
EOF

# Create .envrc file
echo 'Generating environment variables'
source ./generate_envrc.sh
echo "REACT_APP_RPI_HOSTNAME=${RPI_HOSTNAME}" > volumes/vanpi-react/.env

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
