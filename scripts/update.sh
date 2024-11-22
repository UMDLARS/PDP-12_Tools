#!/bin/sh

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..

# Reset any changes
git -C $TOOLS_ROOT_DIR reset --hard
git -C $TOOLS_ROOT_DIR/minicom reset --hard
git -C $TOOLS_ROOT_DIR/os8-disk-server/os8diskserver reset --hard
git -C $TOOLS_ROOT_DIR/simh reset --hard

# Pull latest commits.
git -C $TOOLS_ROOT_DIR pull
git -C $TOOLS_ROOT_DIR submodule update

# Update mincom config.
$TOOLS_ROOT_DIR/scripts/minicom-update-config.sh

# Update 8tools.
$TOOLS_ROOT_DIR/scripts/8tools-update.sh

# Rebuild everything.
$TOOLS_ROOT_DIR/scripts/build-all.sh

