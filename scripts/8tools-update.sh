#!/bin/sh

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..
cd $TOOLS_ROOT_DIR/8tools

git svn rebase
