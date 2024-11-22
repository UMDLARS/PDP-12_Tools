#!/bin/sh

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..

make -C $TOOLS_ROOT_DIR/simh pdp8
