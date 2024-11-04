#!/bin/sh

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))
cd $TOOLS_ROOT_DIR

# Setup ttyUSB1 the same way minicom does.
stty -F /dev/ttyUSB1 ospeed 19200 ispeed 19200 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke cstopb -ixon time 5

# Send the bootloader.
minicom/src/ascii-xfr -dnsv os8diskserver/SerialDisk/bootloader/bootloader.rim > /dev/ttyUSB1
