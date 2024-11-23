#!/bin/bash

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..
source $TOOLS_ROOT_DIR/scripts/detail/path-variables.sh

# Build minicom
$SCRIPTS_DIR/minicom-build.sh

# Build os8diskserver
$SCRIPTS_DIR/os8-build-server.sh

# Build simh
$SCRIPTS_DIR/simh-build.sh
