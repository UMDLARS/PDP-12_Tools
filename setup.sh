#!/bin/sh

# Make a copy of the disk images.
cp -r unmodified-umd-disks disks

# Build everything.
./build.sh
