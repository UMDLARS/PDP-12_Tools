#!/bin/bash

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..
source $TOOLS_ROOT_DIR/scripts/detail/path-variables.sh

# Build minicom
cd $MINICOM_DIR
./autogen.sh
./configure
make -j$(nproc)
