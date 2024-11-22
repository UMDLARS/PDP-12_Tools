#!/bin/sh

TOOLS_ROOT_DIR=$(readlink -f $(dirname $0))/..
source $TOOLS_ROOT_DIR/scripts/detail/path-variables.sh
source $TOOLS_ROOT_DIR/scripts/detail/tty-config.sh

# Setup tty device the same way minicom does.
stty -F $CONFIG_TTY_DEVICE ospeed 19200 ispeed 19200 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke cstopb -ixon time 5

# Send the bootloader.
$MINICOM_DIR/src/ascii-xfr -dnsv $DSKSRV_DIR/SerialDisk/bootloader/bootloader.rim > $CONFIG_TTY_DEVICE
