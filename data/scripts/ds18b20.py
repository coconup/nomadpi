# coding=utf-8
import os

tempSensors = []
tempReadings = []
status = 1 

def init():
    global tempSensors, status
    try:
        for x in os.listdir("/sys/bus/w1/devices"):
            if (x.split("-")[0] == "28") or (x.split("-")[0] == "10"):
                tempSensors.append(x)
    except:
        # Auslesefehler
        print ("Der Verzeichnisinhalt konnte nicht ausgelesen werden.")
        status = 0

def readValues():
    global tempSensors, tempReadings, status
    x = 0
    while x < len(tempSensors):
        try:
            filename = "/sys/bus/w1/devices/" + tempSensors[x] + "/w1_slave"
            file = open(filename)
            filecontent = file.read()
            file.close()
            stringValue = filecontent.split("\n")[1].split(" ")[9]
            floatValue = float(stringValue[2:]) / 1000
            temperature = '%6.2f' % floatValue
            tempReadings.insert(x, temperature)
            x = x + 1
        except:
            tempReadings.insert(x, 'undefined')
            x = x + 1

init()

while status == 1:
    x = 0
    readValues()
    while x < len(tempSensors):
        print (x, " ", tempReadings[x], " °C")
        x = x + 1
        status = 0
