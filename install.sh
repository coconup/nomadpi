#!/bin/bash

set -e  # Exit script on any error

logfile="/tmp/nomadpi_install.log"
progress_file="/tmp/nomadpi_install_progress.log"

GREY='\033[90m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m' # No Color

if [ -e "$logfile" ]; then
    rm "$logfile"
fi

if [ -e "$progress_file" ]; then
    rm "$progress_file"
fi

if [ -d "./nomadpi" ]; then
    echo -e "${BOLD}Error: nomadpi directory already exists. Remove it if you want to re-run the installation script.${NC}"
    exit 1
fi

update_progress() {
  echo $1 >> "$progress_file"
}

error_exit() {
  echo -e "${BOLD}ERROR: Installation failed. Full log available at $logfile${NC}" >&1
  echo -e "" >&1
  tail -n 25 "$logfile" >&1
}

handle_error() {
    error_exit
    exit $exit_code
}

trap 'handle_error' ERR

(
    update_progress 'Installing system dependencies'

    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y \
        python3-setuptools \
        vim \
        direnv \
        nodejs \
        npm \
        jq \
        apt-transport-https \
        ca-certificates \
        software-properties-common

    update_progress 'Cloning nomadPi repositories'

    cd "$HOME" || exit 1

    mkdir -p "$HOME"/.ssh
    curl --silent https://api.github.com/meta | jq --raw-output '"github.com "+.ssh_keys[]' >> "$HOME"/.ssh/known_hosts

    git clone --progress git@github.com:coconup/nomadpi.git >> "$logfile" 2>&1

    cd "nomadpi" || exit 1
    install_dir=$(pwd)

    ssh-keyscan github.com >> ~/.ssh/known_hosts

    mkdir -p "$install_dir"/volumes
    git clone --progress git@github.com:coconup/nomadpi-app-api.git "$install_dir"/volumes/nomadpi-app-api >> "$logfile" 2>&1
    git clone --progress git@github.com:coconup/nomadpi-services-api.git "$install_dir"/volumes/nomadpi-services-api >> "$logfile" 2>&1
    git clone --progress git@github.com:coconup/nomadpi-react.git "$install_dir"/volumes/nomadpi-react >> "$logfile" >&1
    git clone --progress git@github.com:coconup/nomadpi-mqtt-hub.git "$install_dir"/volumes/nomadpi-mqtt-hub >> "$logfile" 2>&1
    git clone --progress git@github.com:coconup/nomadpi-gpsd-to-mqtt.git "$install_dir"/volumes/nomadpi-gpsd-to-mqtt >> "$logfile" 2>&1
    git clone --progress git@github.com:coconup/nomadpi-butterfly-ai "$install_dir"/volumes/nomadpi-butterfly-ai >> "$logfile" 2>&1
    git clone --progress git@github.com:coconup/nomadpi-open-wake-word "$install_dir"/volumes/nomadpi-open-wake-word >> "$logfile" 2>&1
    git clone --progress git@github.com:coconup/nomadpi-bluetooth-api "$install_dir"/volumes/nomadpi-bluetooth-api >> "$logfile" 2>&1

    mkdir -p "$install_dir"/volumes/frigate/config

    cp "$install_dir"/services/frigate/config.yml "$install_dir"/volumes/frigate/config/config.yml

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
    update_progress 'Setting up local environment'

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
    source ./generate_envrc.sh
    echo "REACT_APP_RPI_HOSTNAME=$(hostname).local" > "$install_dir"/volumes/nomadpi-react/.env

    # Initialize secret files
    mkdir -p volumes/secrets/cloudflare
    mkdir -p volumes/secrets/nextcloud
    touch volumes/secrets/cloudflare/tunnel_token
    touch volumes/secrets/nextcloud/nextcloud_host
    touch volumes/secrets/nextcloud/nextcloud_username
    touch volumes/secrets/nextcloud/nextcloud_password

    # Enable I2C and 1-Wire
    update_progress 'Enabling I2C and 1-Wire'

    sudo raspi-config nonint do_i2c 0
    echo -e "dtoverlay=w1-gpio\ndtoverlay=uart5\nenable_uart=1" | sudo tee -a /boot/config.txt

    # Docker patches
    update_progress 'Patching system for Docker compatibility'

    echo $(cat /boot/cmdline.txt) cgroup_memory=1 cgroup_enable=memory | sudo tee /boot/cmdline.txt
    if [ -e "/etc/dhcpcd.conf" ]; then
        sudo bash -c '[ $(egrep -c "^allowinterfaces eth\*,wlan\*" /etc/dhcpcd.conf) -eq 0 ] && echo "allowinterfaces eth*,wlan*" >> /etc/dhcpcd.conf'
    fi

    # Install Docker
    update_progress 'Installing Docker and `docker-compose`'

    curl -fsSL https://get.docker.com | sudo sh >> "$logfile" 2>&1

    # Add the current user to the docker group to run Docker without sudo
    sudo usermod -aG docker $USER
    sudo usermod -aG bluetooth $USER

    # Verify installation
    docker --version

    sudo ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose

    docker-compose --version

    update_progress 'Rebooting system. After reboot, run ~/nomadpi/start.sh in order to complete the installation'

    sleep 5

    sudo reboot
) >> "$logfile" & bg_job_pid=$!

while [ -e /proc/$bg_job_pid ]; do
  clear

  head -n -1 "$progress_file" | while IFS= read -r line; do
    echo -e "${GREEN}${line} ✔${NC}"
  done

  echo -e "${BOLD}$(tail -n 1 "$progress_file")...${NC}"

  tail -n 10 "$logfile" | while IFS= read -r line; do
    echo -e "${GREY}${line}${NC}"
  done

  sleep 2
done

tail -n 10 "$logfile" | while IFS= read -r line; do
    echo -e "${GREY}${line}${NC}"
done