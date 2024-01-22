# coding=utf-8
import os

tempSensors = []
tempReadings = []
status = 1 

def init():
    global tempSensors, status
    try:
        tempSensors = [x for x in os.listdir("/sys/bus/w1/devices") if x.split("-")[0] in {"28", "10"}]
    except:
        print("Error accessing directory")
        status = 0

def readValues():
    global tempSensors, tempReadings, status
    for sensor in tempSensors:
        try:
            filename = f"/sys/bus/w1/devices/{sensor}/w1_slave"
            with open(filename) as file:
                filecontent = file.read()
            stringValue = filecontent.split("\n")[1].split(" ")[9]
            floatValue = float(stringValue[2:]) / 1000
            temperature = '%6.2f' % floatValue
            tempReadings.append(temperature)
        except:
            tempReadings.append('undefined')

init()

while status == 1:
    readValues()
    for x, reading in enumerate(tempReadings):
        print(x, reading, "°C")
    status = 0
