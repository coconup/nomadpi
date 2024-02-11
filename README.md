# VanPi Docker Stack

This is a software stack designed to run on the Raspberry Pi that lets you control everything within your campervan, motorhome or tiny house. It is primarily catered to the [VanPi](https://pekaway.de/) platform, but it can also be installed and run independently.

![dashboard](https://i.ibb.co/ZG2ZbzM/vanpi-dashboard.png)

## Main features

Here is a list of the main features of the software stack.

#### Relays and WiFi relays

Control any relay and wifi relay, organize your control panel and map single buttons to multiple switches.

#### Batteries

Monitor the state of charge, current load and remaining capacity of your battery bank.

#### Water tanks

Monitor the level of your tanks (fresh water, grey water etc.).

#### Heater and thermostat

Control your heater through a smart thermostat, set the desired temperature and the timer on which it should run.

#### Solar chargers

Monitor the state of your solar charge controller, including generated power and charging status.

#### Security cameras and alarm

Install an AI-powered surveillance system and set up rules to trigger an alarm while you are away, powered by [Frigate](https://frigate.video/).

#### GPS tracking

Monitor the current position of your van and its travel history.

#### Remote access

Check on the status of your system and control it from anywhere in the world through a [Cloudflare](https://cloudflare.com/) tunnel.

#### Cloud backup

Setup your own [Nextcloud](https://nextcloud.com/) cloud where files from your system are synced (including surveillance videos) in order to have full access even if the system goes offline.

#### Integrated voice assistant

Control your system with your voice, ask about the state of different components or about anything you like.

## Requirements

The stack can be installed on a fresh installation of Raspbian OS (recommended Lite 64bit). It is compatible with (at least) the Raspberry Pi 4 and Raspberry Pi 5.

## Supported hardware

Here is a list of currently supported devices and affiliate links for where to purchase them. Pull requests for additional devices support are highly valued.

#### Raspberry Pi

Model | Purchase links
Raspberry Pi 5 8gb | [link](https://www.ebay.de/itm/266600494811?mkcid=1&mkrid=707-53477-19255-0&siteid=77&campid=5338708652&customid=&toolid=10001&mkevt=1)
Raspberry Pi 4 8gb | [link](https://www.amazon.de/-/en/Raspberry-Model-ARM-8GB-Linux/dp/B09TTKT94J?&_encoding=UTF8&tag=coconup03-21&linkCode=ur2&linkId=2c621d09af30d8b8cf537f56365a8798&camp=1638&creative=6742)

#### WiFi relays

Vendor | Description | Purchase links
--- | --- | ---
Tasmota | Any tasmota WiFi relay | [link](https://www.amazon.de/-/en/DollaTek-SP8266-Channel-Mobile-Control/dp/B07HC7SJK1/?&_encoding=UTF8&tag=coconup03-21&linkCode=ur2&linkId=2a1802575c1c19e0f05eadc5e5eec279&camp=1638&creative=6742)

#### Batteries

Check out [this article](https://coconup.medium.com/lithium-on-the-cheap-build-a-12v-280ah-3-4kwh-lifepo4-battery-for-less-than-600-ecce00dd1bbd) about building your own battery for a budget, compatible with the supported BMS below.

Vendor | Description | Purchase links
--- | --- | ---
JBD BMS | JBD BMS's with bluetooth connection | [100-150A](https://s.click.aliexpress.com/e/_DmvUcU1)<br>[200A](https://s.click.aliexpress.com/e/_DBEQQeN)
Liontron | LiFePo4 batteries with bluetooth connection | [100Ah](https://www.ebay.de/itm/364428392327?epid=5035171829&mkcid=1&mkrid=707-53477-19255-0&siteid=77&campid=5338708652&customid=&toolid=10001&mkevt=1)

#### Solar chargers

Check out [this article](https://coconup.medium.com/lithium-on-the-cheap-build-a-12v-280ah-3-4kwh-lifepo4-battery-for-less-than-600-ecce00dd1bbd) about building your own battery for a budget, compatible with the supported BMS below.

Vendor | Description | Purchase links
--- | --- | ---
Renogy | MPPT (+ DC/DC) chargers with bluetooth connection | [50A MPPT+DC/DC](https://www.amazon.de/-/en/gp/product/B07SJGLGY8/?&_encoding=UTF8&tag=coconup03-21&linkCode=ur2&linkId=8395a1bdf3ad4673341546cc27f4cf27&camp=1638&creative=6742)<br>[BT-2 Adapter](https://www.amazon.de/-/en/Renogy-BT-2-Bluetooth-Module/dp/B084Q1V7KZ?&_encoding=UTF8&tag=coconup03-21&linkCode=ur2&linkId=b28619be77887bed59752bce5334ccb3&camp=1638&creative=6742)
SRNE | MPPT + DC/DC charger with bluetooth connection | [50A MPPT+DC/DC](https://www.amazon.de/-/en/Charger-Batteries-Intelligent-Charging-Caravans/dp/B09ZXZT3P1/?&_encoding=UTF8&tag=coconup03-21&linkCode=ur2&linkId=49bd954f9807664168aa2633de293861&camp=1638&creative=6742)<br>[BT-2 Adapter](https://s.click.aliexpress.com/e/_DBeq4db)

#### GPS trackers

Vendor | Description | Purchase links
--- | --- | ---
Various | Any GPS USB dongle | [link](https://www.amazon.de/-/en/G-Mouse-Navigation-External-Receiver-Raspberry/dp/B07MY2VD3H?&_encoding=UTF8&tag=coconup03-21&linkCode=ur2&linkId=34bd0bbd0ab16ea4c06415cfc545b010&camp=1638&creative=6742)

#### Water tank sensors

Vendor | Description | Purchase links
--- | --- | ---
DYI | Ultrasonic sensor JSN-SR20-Y1 + ESP8266 board | [JSN-SR20-Y1](https://s.click.aliexpress.com/e/_DBeq4db)<br>[ESP8266](https://www.amazon.de/-/en/ESP8266-NodeMcu-Development-Compatible-Micropython/dp/B0CLXZG25B/?&_encoding=UTF8&tag=coconup03-21&linkCode=ur2&linkId=3fce16ef11cac0c5ec5fd0ac16004519&camp=1638&creative=6742)

#### Security cameras

Any camera compatible with Frigate is supported. Some examples below.

Vendor | Description | Purchase links
--- | --- | ---
Reolink | RLC-520-5MP | [RLC-520-5MP](https://www.amazon.de/dp/B079L4W3CM?&_encoding=UTF8&tag=coconup03-21&linkCode=ur2&linkId=0210610de665f53798fc2f7c324ca344&camp=1638&creative=6742)

#### Heaters

Vendor | Description | Purchase links
--- | --- | ---
Webasto | Thermo Top Evo 5 (hydronic) | [link](https://www.ebay.de/itm/115675106017?amdata=enc%3AAQAIAAAAoA7GDa3oY8v9qlv2pZStVRE9wbOMMwdp25yy5Px8jZ83J0aSgGPOQHd8uGdNhld%2BJxY5fBbY6BAXKgCNIcw8DnaRccsX9GkSzRpkk9dg%2FVRmPSmQFuQlvJ%2Fpey7GAZxnh7sFSWc2vRQn99wYKLDzoCHQMC%2B0R2%2FWdBIIMM1ulqvFkcyZY85Jdr%2Bso6e6YirklUUJUuLEyo9LcQ45f700oDs%3D&mkcid=1&mkrid=707-53477-19255-0&siteid=77&campid=5338708652&customid=&toolid=10001&mkevt=1)

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
