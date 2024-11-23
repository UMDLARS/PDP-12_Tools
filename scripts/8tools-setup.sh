#!/bin/bash

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..
cd $TOOLS_ROOT_DIR

git svn clone https://svn.so-much-stuff.com/svn/trunk/pdp8/8tools/
