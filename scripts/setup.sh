#!/bin/sh

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..

# Setup minicom config.
$TOOLS_ROOT_DIR/scripts/minicom-update-config.sh

# Make a copy of the disk images.
$TOOLS_ROOT_DIR/scripts/os8-restore-disks.sh

# Clone 8tools
$TOOLS_ROOT_DIR/scripts/8tools-setup.sh

# Build everything.
$TOOLS_ROOT_DIR/scripts/build-all.sh
