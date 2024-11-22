#!/bin/sh

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..

# Copy minicom config to $HOME
cp $TOOLS_ROOT_DIR/resources/minicom-data/minirc.dfl $HOME/.minirc.PDP12
echo "pu convf            $(pwd)/minicom-data/7bit-high8th.tbl" >> $HOME/.minirc.PDP12
