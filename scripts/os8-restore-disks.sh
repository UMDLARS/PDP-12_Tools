#!/bin/sh

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..
source $TOOLS_ROOT_DIR/scripts/detail/path-variables.sh

# Create directory if needed.
if [ ! -d $DSKSRV_DISKS_DIR ]; then
    mkdir $DSKSRV_DISKS_DIR
fi

cp $RES_UNMODIF_DISKS_DIR/boot-pdp12.rk05 $DSKSRV_DISKS_DIR/
cp $RES_UNMODIF_DISKS_DIR/boot-simh.rk05 $DSKSRV_DISKS_DIR/
cp $RES_UNMODIF_DISKS_DIR/games.rk05 $DSKSRV_DISKS_DIR/
cp $RES_UNMODIF_DISKS_DIR/blank.rk05 $DSKSRV_DISKS_DIR/disk3.rk05
cp $RES_UNMODIF_DISKS_DIR/blank.rk05 $DSKSRV_DISKS_DIR/disk4.rk05
