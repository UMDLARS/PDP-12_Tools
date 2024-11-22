#!/bin/sh

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..
cd $TOOLS_ROOT_DIR/diskserver-env/simh

# Run simh
$TOOLS_ROOT_DIR/simh/BIN/pdp8
