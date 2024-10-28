#!/bin/sh

cd $(dirname $0)

# Build os8diskserver
./os8diskserver/makeos8diskserver

# Build simh
make -C simh pdp8
