#!/bin/bash

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..
source $TOOLS_ROOT_DIR/scripts/detail/path-variables.sh

# Reset any changes and pull updates on the main repo.
git -C $TOOLS_ROOT_DIR reset --hard
git -C $TOOLS_ROOT_DIR pull

# Run the stage2 update script.
# Updating is split into two stages to avoid breaking stuff if we
# ever decide to move around/add/remove scripts related to updating.
# After pulling repo updates, we'll still be executing the `update.sh`
# script from the previous version of the repo.
# If, E.g., that old update script used `build-all.sh`, but `build-all.sh`
# no longer exists in the newer version of the repo, the update would break.
# To work around this, we split the updating logic into two scripts.
# This first one just pulls the latest repo changes, then executes
# `detail/update-stage2.sh.
# `detail/update-stage2.sh` then does all of the other updating logic.
# We will never move `detail/update-stage2.sh`, so there can never be any
# breakages.
$SCRIPTS_DIR/detail/update-stage2.sh
