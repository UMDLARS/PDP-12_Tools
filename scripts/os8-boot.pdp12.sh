#!/bin/bash

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..
source $TOOLS_ROOT_DIR/scripts/detail/path-variables.sh

cd $DSKSRV_PDP12_ENV_DIR

# Run os8diskserver in the background.
$DSKSRV_DIR/SerialDisk/server/server -1 $DSKSRV_DISKS_DIR/boot-pdp12.rk05 -2 $DSKSRV_DISKS_DIR/games.rk05 -3 $DSKSRV_DISKS_DIR/disk3.rk05 -4 $DSKSRV_DISKS_DIR/disk4.rk05 >/dev/null 2>/dev/null &

# Save disk server pid.
SERVER_PID="$!"

# Trap on exit to kill the disk server.
trap 'kill "$SERVER_PID" 2> /dev/null' EXIT

# Run minicom.
$SCRIPTS_DIR/minicom-run.sh "$@"
