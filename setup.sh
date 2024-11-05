#!/bin/sh

# Copy minicom config to $HOME
cp ./minicom-data/minirc.dfl $HOME/.minirc.PDP12

# Make a copy of the disk images.
./restore-disk-images.sh

# Build everything.
./build.sh
