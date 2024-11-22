#!/bin/sh

# Setup minicom config.
./minicom-update-config.sh

# Make a copy of the disk images.
./os8-restore-disks.sh

# Clone 8tools
./8tools-setup.sh

# Build everything.
./build-all.sh
