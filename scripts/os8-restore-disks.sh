#!/bin/sh

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..
cd $(dirname $0)
#rm -rf disks

# Create directory if needed.
if [ ! -d "$TOOLS_DIR_DIR/disks" ]; then
    mkdir "$TOOLS_DIR_DIR/disks"
fi

cp $TOOLS_ROOT_DIR/resources/unmodified-umd-disks/boot-pdp12.rk05 $TOOLS_ROOT_DIR/disks/
cp $TOOLS_ROOT_DIR/resources/unmodified-umd-disks/boot-simh.rk05 $TOOLS_ROOT_DIR/disks/
cp $TOOLS_ROOT_DIR/resources/unmodified-umd-disks/games.rk05 $TOOLS_ROOT_DIR/disks/
cp $TOOLS_ROOT_DIR/resources/unmodified-umd-disks/blank.rk05 $TOOLS_ROOT_DIR/disks/disk3.rk05
cp $TOOLS_ROOT_DIR/resources/unmodified-umd-disks/blank.rk05 $TOOLS_ROOT_DIR/disks/disk4.rk05
