#!/bin/bash

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))
cd $TOOLS_ROOT_DIR/diskserver-env/pdp12

echo $TOOLS_ROOT_DIR

# Run os8diskserver in the background.
../../os8diskserver/SerialDisk/server/server -1 ../../disks/boot-pdp12.rk05 -2 ../../disks/games.rk05 -3 ../../disks/disk3.rk05 -4 ../../disks/disk4.rk05 >/dev/null 2>/dev/null &

# Save disk server pid.
SERVER_PID="$!"

# Trap on exit to kill the disk server.
trap 'kill "$SERVER_PID" 2> /dev/null' EXIT

# Run minicom on ttyUSB1
$TOOLS_ROOT_DIR/minicom/src/minicom -D /dev/ttyUSB1 PDP12
