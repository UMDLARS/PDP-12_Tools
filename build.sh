#!/bin/sh

cd $(dirname $0)

# Build os8diskserver
make -C ./os8diskserver/SerialDisk/server

# Build simh
make -C simh pdp8
