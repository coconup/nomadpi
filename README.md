
# VanPi Docker Compose Repository

This repository contains the Docker Compose configuration for setting up the VanPi system. Follow the instructions below to get started.

This repo can be installed on a fresh installation of Raspbian OS (recommended Lite 64bit). It is compatible with (at least) the Raspberry Pi 4 and Raspberry Pi 5.

## Getting Started

1.  Install Git and clone this repository:
    
    ```bash
    sudo apt-get install git
    git clone git@github.com:coconup/vanpi-docker-stack.git
    cd vanpi-docker-stack
    ```

2.  Run the installation script to install dependencies:
    
    ```bash
    ./install.sh
    ```
    
    This script installs `direnv`, Docker and Docker Compose. Reboot after running it.

3.  Clone dependencies into the `volumes` folder:

    ```bash
    cd ~/vanpi-docker-stack
    mkdir volumes
    cd volumes
    git clone git@github.com:coconup/vanpi-app-api.git
    git clone git@github.com:coconup/vanpi-react.git
    git clone git@github.com:coconup/vanpi-mqtt-hub.git
    git clone git@github.com:coconup/vanpi-gpsd-to-mqtt.git
    ```

4.  Copy the example environment file and customize it according to your needs:
    
    ```bash
    cd ~/vanpi-docker-stack
    cp .envrc.example .envrc
    vim .envrc
    ```
    
    Edit the `.envrc` file to set your desired configurations. Don't forget to run `direnv allow` any time changes to `.envrc` are made.
    

5.  Start the VanPi services:
    
    ```bash
    docker-compose up -d
    ```
    
    This command will start all the defined services in the background.

6.  Navigate to the `vanpi-core-api` Node-Red interface and set up a new project, cloning this repository: https://github.com/coconup/vanpi-core-api.git

    Install missing dependencies within Node-Red as requested.

7.  Navigate to the `vanpi-automation-api` Node-Red interface and set up a new project, cloning this repository: https://github.com/coconup/vanpi-automation-api.git

## Services

  - **Portainer CE**: Web-based Docker management interface. Access it at http://localhost:9000.
    
  - **VanPi Core API**: Node-RED-based core API for controlling the VanPi hardware ([GitHub project](https://github.com/coconup/vanpi-core-api)). Access it at http://localhost:1880.
    
  - **VanPi Automation API**: Node-RED-based automation API ([GitHub project](https://github.com/coconup/vanpi-automation-api)). Access it at http://localhost:1881.
    
  - **Mosquitto**: MQTT broker for communication between services.
    
  - **MariaDB**: MariaDB database for storing configuration data.
    
  - **VanPi React**: React-based frontend ([GitHub project](https://github.com/coconup/vanpi-react)). Access it at http://localhost:3000.
    
  - **VanPi App API**: Node.js API serving the React application ([GitHub project](https://github.com/coconup/vanpi-app-api)). Access it at http://localhost:3001.
    
  - **Zigbee2mqtt**: Zigbee to MQTT bridge.
    

## Additional Services

  - **GPIOD**: GPIO daemon container.
    
  - **GPSD**: GPS daemon container.
    
  - **Cloudflared Tunnel**: Container for running Cloudflare Tunnel.
    

## Notes

  - Make sure to customize the environment variables in the `.envrc` file for your specific setup.
    
  - Check individual service configurations in the `docker-compose.yml` file for further customization.
    
  - Use the provided `install.sh` script to install Docker and Docker Compose automatically.
    

Feel free to explore, modify, and extend this setup according to your specific needs. If you encounter any issues or have suggestions, please create an issue in this repository.
