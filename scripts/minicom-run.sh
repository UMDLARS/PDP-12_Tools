#!/bin/sh

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..

# Run minicom on ttyUSB1
$TOOLS_ROOT_DIR/minicom/src/minicom -D /dev/ttyUSB1 PDP12
