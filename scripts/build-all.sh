#!/bin/sh

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..
cd $(dirname $0)/..

# Build minicom
cd $TOOLS_ROOT_DIR/minicom
./autogen.sh
./configure
make -j$(nproc)

# Build os8diskserver
make -C $TOOLS_ROOT_DIR/os8diskserver/SerialDisk/server

# Build simh
make -C $TOOLS_ROOT_DIR/simh pdp8
