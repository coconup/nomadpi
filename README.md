# nomadPi

This is a software stack designed to run on the Raspberry Pi that lets you control everything within your campervan, boat or tiny home. 

It was initiated as an alternative software stack for the [VanPi](https://pekaway.de/) platform ([GitHub repo](https://github.com/Pekaway/VAN_PI)), which it aims at supporting in the future, but it can also run independently.

<!-- ![dashboard](https://i.ibb.co/jzgrRPw/nomadpi-dashboard.png) -->

Check out the video below for an introduction to the system:

[![nomadPi overview](https://i.ibb.co/SQ4d8sf/nomadpi-intro-video.png?t=1)](https://www.youtube.com/watch?v=1wNc4X0X_4g "nomadPi overview")


## Main features

Here is a list of the main features of the stack.

- #### Relays and WiFi relays
  Control appliances through relays and WiFi relays, organize your control panel and map single buttons to multiple switches.

- #### Batteries
  Monitor the state of charge, current load and remaining capacity of your battery bank.

- #### Water tanks
  Monitor the level of your tanks (fresh water, grey water etc.).

- #### Heater and thermostat
  Control your heater through a smart thermostat, set the desired temperature and the timer on which it should run.

- #### Solar chargers
  Monitor the state of your solar charge controller, including generated power and charging status.

- #### Security cameras and alarm
  Install an AI-powered surveillance system and set up rules to trigger an alarm while you are away, powered by [Frigate](https://frigate.video/).

- #### GPS tracking
  Monitor the current position of your van and its travel history.
  
- #### Remote access
  Check on the status of your system and control it from anywhere in the world through a [Cloudflare](https://cloudflare.com/) tunnel.
  
- #### Cloud backup
  Setup your own [Nextcloud](https://nextcloud.com/) cloud where files from your system are synced (including surveillance videos) in order to have full access even if the system goes offline.

- #### Integrated voice assistant
  Control your system with your voice, ask about the state of different components or about anything you like.

## Requirements

The stack can be installed on a fresh installation of Raspbian OS (recommended Lite 64bit). It is compatible with (at least) the Raspberry Pi 4 and Raspberry Pi 5.

## Getting Started

1.  Flash a copy of Raspbian OS lite 64-bit and boot your Raspberry Pi.

2. SSH into your Raspberry Pi after it booted (this might take some minutes upon first run). The command below assumes you chose `pi` as your username and `raspberrypi` as your hostname, while flashing the OS.

    ```bash
    ssh pi@raspberrypi.local
    ```

3.  Run the install script:
    
    ```bash
    wget -q -O - "https://raw.githubusercontent.com/coconup/nomadpi/master/install.sh" | dos2unix | bash
    ```
    
    This script installs all necessary dependencies, Docker and Docker Compose. It will reboot the Pi after it runs.

4.  After rebooting, SSH into your Raspberry Pi again and start the stack:
    
    ```bash
    cd ~/nomadpi
    ./start.sh
    ```

## Services and resources

#### Core services

  - **nomadPi React**: React-based frontend ([GitHub project](https://github.com/coconup/nomadpi-react)). Access it at http://raspberrypi.local:3000.

  - **Portainer CE**: Web-based Docker management interface. Access it at http://raspberrypi.local:9000.

  - **Frigate**: AI-powered surveillance service for CCTV that employs real-time object detection and alerts for enhanced security monitoring. Access it at http://raspberrypi.local:5000.
    
  - **nomadPi Core API**: Node-RED-based core API for controlling the nomadPi hardware ([GitHub project](https://github.com/coconup/nomadpi-core-api)). Access it at http://raspberrypi.local:1880.
    
  - **nomadPi Automation API**: Node-RED-based automation API ([GitHub project](https://github.com/coconup/nomadpi-automation-api)). Access it at http://raspberrypi.local:1881.

  - **nomadPi App API**: Node.js API serving the React application ([GitHub project](https://github.com/coconup/nomadpi-app-api)). Access it at http://raspberrypi.local:3001.
    

#### Additional Services
    
  - **GPSD**: GPS daemon container.
    
  - **Mosquitto**: MQTT broker for communication between services.
    
  - **MariaDB**: MariaDB database for storing configuration data.
    
  - **Zigbee2mqtt**: Zigbee to MQTT bridge.
    
  - **Cloudflared tunnel**: Container for running Cloudflare Tunnel.
    
  - **Nextcloud client**: Client for backing up your data onto a remote Nextcloud installation.
    
## Supported hardware

Here is a list of currently supported devices and affiliate links for where to purchase them. Pull requests for additional devices support are highly valued.

#### Raspberry Pi

Model | Purchase links
--- | ---
Raspberry Pi 5 8gb | [link](https://www.amazon.com/Raspberry-Pi-Computer-8GB-Quicker/dp/B0CPGPJ3JC?&_encoding=UTF8&tag=nomadpi-20&linkCode=ur2&linkId=29ec03664b24996ed161eccc5b406589&camp=1789&creative=9325)
Raspberry Pi 4 8gb | [link](https://www.amazon.com/Raspberry-Pi-Computer-Suitable-Workstation/dp/B0899VXM8F?&_encoding=UTF8&tag=nomadpi-20&linkCode=ur2&linkId=ea0839fc470d3246da714dcb2083c0ba&camp=1789&creative=9325)

#### WiFi relays

Vendor | Description | Purchase links
--- | --- | ---
Tasmota | Any tasmota WiFi relay | [link](https://www.amazon.com/Mumubiz-Channel-Inching-Wireless-Compatible/dp/B0CJRZV211/?&_encoding=UTF8&tag=nomadpi-20&linkCode=ur2&linkId=7795e193757f0ce4361ebea3e0bd702e&camp=1789&creative=9325)

#### Batteries

Check out [this article](https://coconup.medium.com/lithium-on-the-cheap-build-a-12v-280ah-3-4kwh-lifepo4-battery-for-less-than-600-ecce00dd1bbd) about building your own battery for a budget, compatible with the supported BMS below.

Vendor | Description | Purchase links
--- | --- | ---
JBD | JBD BMS's with bluetooth connection | - [100-150A](https://s.click.aliexpress.com/e/_DmvUcU1)<br>- [200A](https://s.click.aliexpress.com/e/_DBEQQeN)
Liontron | LiFePo4 batteries with bluetooth connection | - [🇪🇺 100Ah](https://www.ebay.de/itm/364428392327?epid=5035171829&mkcid=1&mkrid=707-53477-19255-0&siteid=77&campid=5338708652&customid=&toolid=10001&mkevt=1)<br />- [🇬🇧 100Ah](https://www.ebay.co.uk/itm/156069074273?mkcid=1&mkrid=710-53481-19255-0&siteid=3&campid=5338708652&customid=&toolid=10001&mkevt=1)
<!-- Victron | Smart shunt (latest firmware + GATT must be activated) | - [500A](https://www.amazon.com/Victron-SmartShunt-500AMP-Bluetooth-Battery/dp/B0856PHNLX?&_encoding=UTF8&tag=nomadpi-20&linkCode=ur2&linkId=6224a6f2d11a68e9f768870f845484a5&camp=1789&creative=9325)<br />- [1000A](https://www.amazon.com/Victron-Energy-SmartShunt-Battery-Bluetooth/dp/B0BW9VZGKL/?&_encoding=UTF8&tag=nomadpi-20&linkCode=ur2&linkId=accbea52737d41f1ecf329364de44345&camp=1789&creative=9325) -->
<!-- Daly | Daly BMS's with bluetooth connection | - [link](https://www.ebay.de/sch/i.html?_from=R40&_trksid=p2334524.m570.l1313&_nkw=daly+bms+bluetooth&_sacat=0&_odkw=sok+bms&_osacat=0&mkcid=1&mkrid=707-53477-19255-0&siteid=77&campid=5338708652&customid=&toolid=10001&mkevt=1)
ANT | ANT BMS's with bluetooth connection | - [link](https://www.ebay.de/sch/i.html?_from=R40&_trksid=p4432023.m570.l1313&_nkw=ant+bms&_sacat=0&mkcid=1&mkrid=707-53477-19255-0&siteid=77&campid=5338708652&customid=&toolid=10001&mkevt=1)
JK | JK BMS's with bluetooth connection | - [link](https://www.ebay.de/sch/i.html?_from=R40&_trksid=p2334524.m570.l1313&_nkw=jk+bms&_sacat=0&_odkw=supervolt+100ah&_osacat=0&mkcid=1&mkrid=710-53481-19255-0&siteid=3&campid=5338708652&customid=&toolid=10001&mkevt=1) -->
<!-- Supervolt | LiFePo4 batteries with bluetooth connection | - [🇪🇺 100Ah](https://www.ebay.de/sch/i.html?_from=R40&_trksid=p4432023.m570.l1313&_nkw=supervolt+100ah&_sacat=0&mkcid=1&mkrid=707-53477-19255-0&siteid=77&campid=5338708652&customid=&toolid=10001&mkevt=1)<br />- [🇬🇧 100Ah](https://www.ebay.co.uk/sch/i.html?_from=R40&_trksid=p4432023.m570.l1313&_nkw=supervolt+100ah&_sacat=0&mkcid=1&mkrid=710-53481-19255-0&siteid=3&campid=5338708652&customid=&toolid=10001&mkevt=1) -->


#### Solar chargers

Vendor | Description | Purchase links
--- | --- | ---
Renogy | MPPT (+ DC/DC) chargers with bluetooth connection | - [🇪🇺 50A MPPT+DC/DC](https://www.amazon.de/-/en/gp/product/B07SJGLGY8/?&_encoding=UTF8&tag=coconup03-21&linkCode=ur2&linkId=8395a1bdf3ad4673341546cc27f4cf27&camp=1638&creative=6742)<br/>- [🇪🇺 60A MPPT](https://www.amazon.de/-/en/Renogy-Charge-Controller-Lithium-Batteries/dp/B09WR7YLQX?&_encoding=UTF8&tag=coconup03-21&linkCode=ur2&linkId=37c13db07da871ee5ba3153bdbed02b4&camp=1638&creative=6742)<br/>- [🇪🇺 40A MPPT](https://www.amazon.de/Renogy-Rover-MPPTSolar-Charge-Controller-Black/dp/B01MSYGZGI?&_encoding=UTF8&tag=coconup03-21&linkCode=ur2&linkId=4aebfa3ea1a06e20687f3c2eabaea5e3&camp=1638&creative=6742)<br/>- [🇪🇺 30A MPPT](https://www.amazon.de/Renogy-Batterieladeger%25C3%25A4t-Solarladeregler-Starterbatterie-Versorgungsbatterie-Schwarz/dp/B0891SJTD5?&_encoding=UTF8&tag=coconup03-21&linkCode=ur2&linkId=7970578bc5ad2ce75eaa326710d3e186&camp=1638&creative=6742)<br/>-[🇪🇺 Other Renogy MPPT chargers](https://www.amazon.de/s?k=renogy+mppt&rh=n%253A5866098031%252Cp_89%253ARenogy&dc&language=en&ds=v1%253Ajwz0iTyHQAHRWSfucswx2MGUP4nScIrtZZ3D17tyB2s&crid=205OQ8FBH7KT9&qid=1708529428&rnid=669059031&sprefix=renogy+mppt%252Caps%252C175&ref=sr_nr_p_89_3&_encoding=UTF8&tag=coconup03-21&linkCode=ur2&linkId=ffa064b37c10ac5a5587a704c9b8e5e1&camp=1638&creative=6742)<br/>- [🇺🇸 50A MPPT+DC/DC](https://www.amazon.com/Renogy-Controller-Alternator-Function-Batteries/dp/B0C5LXB92B?&_encoding=UTF8&tag=nomadpi-20&linkCode=ur2&linkId=7f7f691d1fb07d1770d7e6c6b29100f1&camp=1789&creative=9325)<br/>- [🇺🇸 30A MPPT+DC/DC](https://www.amazon.com/Renogy-Charger-MPPT-Batteries-Multi-Stage/dp/B093BB3PCV?&_encoding=UTF8&tag=nomadpi-20&linkCode=ur2&linkId=a152e1b05e1fc24b5e352844b8d9b36e&camp=1789&creative=9325)<br/>- [🇺🇸 60A MPPT](https://www.amazon.com/Renogy-Solar-Charge-Controller-Adjustable/dp/B07PXJPSTY?&_encoding=UTF8&tag=nomadpi-20&linkCode=ur2&linkId=46334076b1b4b5c95987fd3c41420f39&camp=1789&creative=9325)<br/>- [🇺🇸 40A MPPT](https://www.amazon.com/gp/aw/d/B079JRNFY6?&_encoding=UTF8&tag=nomadpi-20&linkCode=ur2&linkId=5d8ded35a4fac6d084a081d9bd520cb1&camp=1789&creative=9325)<br/>- [🇺🇸 30A MPPT](https://www.amazon.com/gp/aw/d/B07DNVW37B?&_encoding=UTF8&tag=nomadpi-20&linkCode=ur2&linkId=99c3561d7ded3edc7426e38e2f0c63e8&camp=1789&creative=9325)- [🇺🇸 Other Renogy MPPT chargers](https://www.amazon.com/s?k=renogy+mppt&rh=n%253A2972638011%252Cp_89%253ARenogy&dc&ds=v1%253AK1IcsWzf1EGiuCgejK1VXkj8o%252FHtwvpzD8dhUN%252FvHQ4&crid=3EOE7E3G0LFRS&qid=1708529481&rnid=2528832011&sprefix=renogy+mppt+%252Caps%252C275&ref=sr_nr_p_89_1&_encoding=UTF8&tag=nomadpi-20&linkCode=ur2&linkId=c899a180adcbaa82c273d8e4430f1ab6&camp=1789&creative=9325)<br/>- [🇺🇸 30A MPPT](https://www.amazon.com/gp/aw/d/B07DNVW37B?&_encoding=UTF8&tag=nomadpi-20&linkCode=ur2&linkId=99c3561d7ded3edc7426e38e2f0c63e8&camp=1789&creative=9325)<br/>- [BT-2 Adapter](https://www.amazon.com/Renogy-BT-2-Bluetooth-Module-Communication/dp/B0899932YC?&_encoding=UTF8&tag=nomadpi-20&linkCode=ur2&linkId=ad3eaa1069487b1c0b2dd480060988b3&camp=1789&creative=9325)
SRNE | MPPT + DC/DC charger with bluetooth connection | - [50A MPPT+DC/DC](https://www.amazon.de/-/en/Charger-Batteries-Intelligent-Charging-Caravans/dp/B09ZXZT3P1/?&_encoding=UTF8&tag=coconup03-21&linkCode=ur2&linkId=49bd954f9807664168aa2633de293861&camp=1638&creative=6742)<br>- [BT-2 Adapter](https://s.click.aliexpress.com/e/_DBeq4db)

#### GPS trackers

Vendor | Description | Purchase links
--- | --- | ---
Various | Any GPS USB dongle | [link](https://www.amazon.com/Navigation-External-Receiver-Raspberry-Geekstory/dp/B078Y52FGQ?&_encoding=UTF8&tag=nomadpi-20&linkCode=ur2&linkId=a4f397104925780a75a18d7c639af435&camp=1789&creative=9325)

#### Water tank sensors

Vendor | Description | Purchase links
--- | --- | ---
DIY | Ultrasonic sensor JSN-SR20-Y1 + ESP8266 board | - [JSN-SR20-Y1](https://s.click.aliexpress.com/e/_DBeq4db)<br>- [🇪🇺 ESP8266](https://www.amazon.de/-/en/ESP8266-NodeMcu-Development-Compatible-Micropython/dp/B0CLXZG25B/?&_encoding=UTF8&tag=coconup03-21&linkCode=ur2&linkId=3fce16ef11cac0c5ec5fd0ac16004519&camp=1638&creative=6742)<br>- [🇺🇸 ESP8266](https://www.amazon.com/ESP8266-Internet-Development-Wireless-Micropython/dp/B07RNX3W9J?&_encoding=UTF8&tag=nomadpi-20&linkCode=ur2&linkId=00ea2419b8b9b69f32965339c45dbc71&camp=1789&creative=9325)

#### Security cameras

Any camera compatible with Frigate is supported. Some examples below.

Vendor | Description | Purchase links
--- | --- | ---
Reolink | Any Reolink camera | - [RLC-520A](https://www.amazon.com/REOLINK-Security-Outdoor-Surveillance-Detection/dp/B08LKC9BJ8?&_encoding=UTF8&tag=nomadpi-20&linkCode=ur2&linkId=cc85f054aff52c734b7f7b91f532a749&camp=1789&creative=9325)<br/>- [Other Reolink cameras](https://www.amazon.com/s?k=reolink+camera&crid=86W8UXMWSP04&_encoding=UTF8&tag=nomadpi-20&linkCode=ur2&linkId=f78d0a4f61cc4ba43a8f1cb2c164cb47&camp=1789&creative=9325)
Google Coral | Edge TPU, highly recommended for speeding up object recognition in Frigate | - [link](https://www.amazon.com/Google-Coral-Accelerator-coprocessor-Raspberry/dp/B07R53D12W?&_encoding=UTF8&tag=nomadpi-20&linkCode=ur2&linkId=c21da0c876d9fdf016001ab93d08c74f&camp=1789&creative=9325)

#### Heaters

Vendor | Description | Purchase links
--- | --- | ---
Webasto | Thermo Top Evo 5 (hydronic) | [link](https://www.ebay.de/itm/115675106017?amdata=enc%3AAQAIAAAAoA7GDa3oY8v9qlv2pZStVRE9wbOMMwdp25yy5Px8jZ83J0aSgGPOQHd8uGdNhld%2BJxY5fBbY6BAXKgCNIcw8DnaRccsX9GkSzRpkk9dg%2FVRmPSmQFuQlvJ%2Fpey7GAZxnh7sFSWc2vRQn99wYKLDzoCHQMC%2B0R2%2FWdBIIMM1ulqvFkcyZY85Jdr%2Bso6e6YirklUUJUuLEyo9LcQ45f700oDs%3D&mkcid=1&mkrid=707-53477-19255-0&siteid=77&campid=5338708652&customid=&toolid=10001&mkevt=1)

## Supporting the project

If you feel like it, you can financially support the project in one of these ways:

- Make a monthly contribution through [Patreon](https://www.patreon.com/nomadpi)
- Make a one-time donation via [Paypal](https://www.paypal.com/donate/?hosted_button_id=FPWJT97N4PFGY)
- Purchase supported hardware through the [affiliate links above](https://github.com/coconup/nomadpi?tab=readme-ov-file#supported-hardware)
