#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt install -y \
    python3-setuptools \
    vim \
    direnv

# Add direnv to .bashrc
echo 'Setting up `direnv``'
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc

# Enable I2C and 1-Wire
echo 'Enabling I2C and 1-Wire'
sudo raspi-config nonint do_i2c 0
echo -e "dtoverlay=w1-gpio\ndtoverlay=uart5\nenable_uart=1" | sudo tee -a /boot/config.txt
sudo debconf-set-selections <<EOF
iptables-persistent iptables-persistent/autosave_v4 boolean true
iptables-persistent iptables-persistent/autosave_v6 boolean true
EOF

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
