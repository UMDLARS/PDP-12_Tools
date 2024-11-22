#!/bin/sh

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..
cd $(dirname $0)
#rm -rf disks

DISKS_DIR=$TOOLS_ROOT_DIR/os8-disk-server/disks
UNMODIF_DISK_DIR=$TOOLS_ROOT_DIR/resources/unmodified-umd-disks

# Create directory if needed.
if [ ! -d $DISKS_DIR ]; then
    mkdir $DISKS_DIR
fi

cp $UNMODIF_DISKS_DIR/boot-pdp12.rk05 $DISKS_DIR/
cp $UNMODIF_DISKS_DIR/boot-simh.rk05 $DISKS_DIR/
cp $UNMODIF_DISKS_DIR/games.rk05 $DISKS_DIR/
cp $UNMODIF_DISKS_DIR/blank.rk05 $DISKS_DIR/disk3.rk05
cp $UNMODIF_DISKS_DIR/blank.rk05 $DISKS_DIR/disk4.rk05
