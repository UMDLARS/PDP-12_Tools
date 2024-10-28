#!/bin/sh

cd $(dirname $0)
#rm -rf disks

# Create directory if needed.
if [ ! -d "disks" ]; then
    mkdir "disks"
fi

cp unmodified-umd-disks/boot-pdp12.rk05 disks/
cp unmodified-umd-disks/boot-simh.rk05 disks/
cp unmodified-umd-disks/games.rk05 disks/
cp unmodified-umd-disks/blank.rk05 disks/disk3.rk05
cp unmodified-umd-disks/blank.rk05 disks/disk4.rk05
