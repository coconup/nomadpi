# VanPi Docker Stack

This is a software stack designed to run on the Raspberry Pi that lets you control everything within your campervan, motorhome or tiny house. It is primarily catered to the [VanPi](https://pekaway.de/) platform, but it can also be installed and run on any Raspberry Pi.

![dashboard](https://i.ibb.co/ZG2ZbzM/vanpi-dashboard.png)

## Main features

Here is a list of the main features of the software stack.

### Relays and WiFi relays

Control any relay and wifi relay, organize your control panel and map single buttons to multiple switches.

### Batteries monitoring

Monitor the state of charge, current load and remaining capacity of your battery bank.

### Water tanks

Monitor the level of your tanks (fresh water, grey water etc.).

### Heater and thermostat

Control your heater through a smart thermostat, set the desired temperature and the timer on which it should run.

### Solar chargers

Monitor the state of your solar charge controller, including generated power and charging status.

### Security cameras and alarm

Install an AI-powered surveillance system and set up rules to trigger an alarm while you are away, powered by [Frigate](https://frigate.video/).

### GPS tracking

Monitor the current position of your van and its travel history.

### Remote access

Check on the status of your system and control it from anywhere in the world through a [Cloudflare](https://cloudflare.com/) tunnel.

### Cloud backup

Setup your own [Nextcloud](https://nextcloud.com/) cloud where files from your system are synced (including surveillance videos) in order to have full access even if the system goes offline.

### Integrated voice assistant

Control your system with your voice, ask about the state of different components or about anything you like.

## Requirements

The stack can be installed on a fresh installation of Raspbian OS (recommended Lite 64bit). It is compatible with (at least) the Raspberry Pi 4 and Raspberry Pi 5.

## Getting Started

Check out [this video](https://www.youtube.com/watch?v=a_yJqSot-Hc) for step-by-step instructions on how to install the stack.

1.  Flash a copy of Raspbian OS lite 64-bit and boot your Raspberry Pi.

2.  Install Git and clone this repository:
    
    ```bash
    sudo apt-get install git
    git clone git@github.com:coconup/vanpi-docker-stack.git
    cd vanpi-docker-stack
    ```

3.  Run the installation script:
    
    ```bash
    ./install.sh
    ```
    
    This script installs `direnv`, Docker and Docker Compose. Reboot after running it.

4.  Copy the example environment file and customize it according to your needs:
    
    ```bash
    cd ~/vanpi-docker-stack
    cp .envrc.example .envrc
    vim .envrc
    ```
    
    Edit the `.envrc` file to set your desired configurations. Don't forget to run `direnv allow` any time changes to `.envrc` are made.
    

5.  Start the stack:
    
    ```bash
    docker-compose up -d
    ```
    
    This command will start all the defined services in the background.

6.  Navigate to the `vanpi-core-api` Node-Red interface and set up a new project, cloning this repository: https://github.com/coconup/vanpi-core-api.git

    Install missing dependencies within Node-Red as requested.

7.  Navigate to the `vanpi-automation-api` Node-Red interface and set up a new project, cloning this repository: https://github.com/coconup/vanpi-automation-api.git

## Services

  - **VanPi React**: React-based frontend ([GitHub project](https://github.com/coconup/vanpi-react)). Access it at http://raspberrypi.local:3000.

  - **Portainer CE**: Web-based Docker management interface. Access it at http://raspberrypi.local:9000.

  - **Frigate**: AI-powered surveillance service for CCTV that employs real-time object detection and alerts for enhanced security monitoring. Access it at http://raspberrypi.local:5000.
    
  - **VanPi Core API**: Node-RED-based core API for controlling the VanPi hardware ([GitHub project](https://github.com/coconup/vanpi-core-api)). Access it at http://raspberrypi.local:1880.
    
  - **VanPi Automation API**: Node-RED-based automation API ([GitHub project](https://github.com/coconup/vanpi-automation-api)). Access it at http://raspberrypi.local:1881.

  - **VanPi App API**: Node.js API serving the React application ([GitHub project](https://github.com/coconup/vanpi-app-api)). Access it at http://raspberrypi.local:3001.
    

## Additional Services
    
  - **GPSD**: GPS daemon container.
    
  - **Mosquitto**: MQTT broker for communication between services.
    
  - **MariaDB**: MariaDB database for storing configuration data.
    
  - **Zigbee2mqtt**: Zigbee to MQTT bridge.
    
  - **Cloudflared tunnel**: Container for running Cloudflare Tunnel.
    
  - **Nextcloud client**: Client for backing up your data onto a remote Nextcloud installation.
    

## Notes

  - Make sure to customize the environment variables in the `.envrc` file for your specific setup.
    
  - Check individual service configurations in the `docker-compose.yml` file for further customization.
    
  - Use the provided `install.sh` script to install Docker and Docker Compose automatically.
    

Feel free to explore, modify, and extend this setup according to your specific needs. If you encounter any issues or have suggestions, please create an issue in this repository.
