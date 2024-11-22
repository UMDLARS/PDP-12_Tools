#!/bin/sh

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..
source $TOOLS_ROOT_DIR/scripts/detail/path-variables.sh

# Create config files for tty & disk server devices.
echo "/dev/ttyUSB0" > $CONFIG_DIR/disk-server-device.txt
echo "/dev/ttyUSB1" > $CONFIG_DIR/tty-server-device.txt
