#!/bin/bash

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..
source $TOOLS_ROOT_DIR/scripts/detail/path-variables.sh

cd $DSKSRV_SIMH_ENV_DIR

# Run simh
$TOOLS_ROOT_DIR/simh/BIN/pdp8 "$@"
