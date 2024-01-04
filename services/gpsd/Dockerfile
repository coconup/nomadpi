FROM alpine

RUN apk add --no-cache \
      gpsd \
      bash \
      gpsd-clients \
      usbutils

EXPOSE 2947

ADD run.sh /run.sh

# CMD ["gpsd", "-N", "-n", "-G", "-D", "3", "-S", "2947", "-F", "/var/run/gpsd/gpsd.sock", $USB_DEVICE_PATH]
CMD /run.sh
