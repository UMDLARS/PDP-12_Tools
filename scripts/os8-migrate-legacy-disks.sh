#!/bin/bash

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..
source $TOOLS_ROOT_DIR/scripts/detail/path-variables.sh

if [ ! -d $LEGACY_DISKS_DIR ]; then
    exit
fi

# Delete disks dir and move the legacy disks dir.
rm -rf $DSKSRV_DISKS_DIR
mv $LEGACY_DISKS_DIR $DSKSRV_DISKS_DIR
