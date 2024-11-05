#!/bin/sh

cd $(dirname $0)

# Build minicom
cd minicom
./autogen.sh
./configure
make -j$(nproc)
cd ..

# Build os8diskserver
make -C ./os8diskserver/SerialDisk/server

# Build simh
make -C simh pdp8
