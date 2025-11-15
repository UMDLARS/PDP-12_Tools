#!/bin/bash

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..
source $TOOLS_ROOT_DIR/scripts/detail/path-variables.sh
source $TOOLS_ROOT_DIR/scripts/detail/serial-config.sh

# Run minicom on CONFIG_TTY_DEVICE
$MINICOM_DIR/src/minicom -D $CONFIG_TTY_DEVICE PDP12 "$@"
