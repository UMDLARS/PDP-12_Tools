#!/bin/sh

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..
cd $(dirname $0)/..

# Build minicom
$TOOLS_ROOT_DIR/scripts/minicom-build.sh

# Build os8diskserver
$TOOLS_ROOT_DIR/scripts/os8-build-server.sh

# Build simh
$TOOLS_ROOT_DIR/scripts/simh-build.sh
