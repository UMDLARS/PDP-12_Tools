#!/bin/bash

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..
cd $TOOLS_ROOT_DIR/os8-disk-server/diskserver-env/simh

DISKS_DIR=$TOOLS_ROOT_DIR/os8-disk-server/disks

# Run os8diskserver in the background.
$TOOLS_ROOT_DIR/os8-disk-server/os8diskserver/SerialDisk/server/server -1 $DISKS_DIR/boot-pdp12.rk05 -2 $DISKS_DIR/games.rk05 -3 $DISKS_DIR/disk3.rk05 -4 $DISKS_DIR/disk4.rk05 >/dev/null 2>/dev/null &

# Save disk server pid.
SERVER_PID="$!"

# Trap on exit to kill the disk server.
trap 'kill "$SERVER_PID" 2> /dev/null' EXIT

# Run minicom.
$TOOLS_ROOT_DIR/scripts/minicom-run.sh
