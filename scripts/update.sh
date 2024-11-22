#!/bin/sh

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..
source $TOOLS_ROOT_DIR/scripts/detail/path-variables.sh

# Reset any changes
git -C $TOOLS_ROOT_DIR reset --hard
git -C $MINICOM_DIR reset --hard
git -C $DSKSRV_DIR reset --hard
git -C $SIMH_DIR reset --hard

# Pull latest commits.
git -C $TOOLS_ROOT_DIR pull
git -C $TOOLS_ROOT_DIR submodule update

# Update mincom config.
$SCRIPTS_DIR/minicom-update-config.sh

# Update 8tools.
$SCRIPTS_DIR/8tools-update.sh

# Rebuild everything.
$SCRIPTS_DIR/build-all.sh
