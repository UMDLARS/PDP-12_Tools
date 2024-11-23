#!/bin/bash

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..
source $TOOLS_ROOT_DIR/scripts/detail/path-variables.sh

# Copy minicom config to $HOME
cp $RES_MINICOM_DATA_DIR/minirc.dfl $HOME/.minirc.PDP12
echo "pu convf            $RES_MINICOM_DATA_DIR/7bit-high8th.tbl" >> $HOME/.minirc.PDP12
