#!/bin/sh

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..
source $TOOLS_ROOT_DIR/scripts/detail/path-variables.sh

make -C $DSKSRV_DIR/SerialDisk/server
