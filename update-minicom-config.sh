#!/bin/sh

# Copy minicom config to $HOME
cp ./minicom-data/minirc.dfl $HOME/.minirc.PDP12
echo "pu convf            $(pwd)/minicom-data/7bit-high8th.tbl" >> $HOME/.minirc.PDP12
