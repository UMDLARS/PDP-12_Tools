#!/bin/sh

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..

# Build minicom
cd $TOOLS_ROOT_DIR/minicom
./autogen.sh
./configure
make -j$(nproc)
