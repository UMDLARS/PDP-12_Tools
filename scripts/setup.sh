#!/bin/sh

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..
source $TOOLS_ROOT_DIR/scripts/detail/path-variables.sh

# Setup minicom config.
$SCRIPTS_DIR/minicom-update-config.sh

# Make a copy of the disk images.
$SCRIPTS_DIR/os8-restore-disks.sh

# Clone 8tools
$SCRIPTS_DIR/8tools-setup.sh

# Build everything.
$SCRIPTS_DIR/build-all.sh
