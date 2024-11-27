# Games Disk Image Generation
This document details how to recreate our games (`games.rk05`) disk image.

Our games disk image is derived from the "OCK boot" OS/8 disk image provided by the PiDP-8/I project.

## Required Resources
* This repository.
* "OCK boot" ock.rk05 OS/8 image from the PiDP-8/I project: https://tangentsoft.com/pidp8i/wiki?name=Home

## Creating The Games Disk
The contents of `os8-disk-server/disks` should be as follows:
* `boot-pdp12.rk05` (for PDP-12) or `boot-simh.rk05` (for simh): A bootable OS/8 rk05 disk image.
* `games.rk05`: An empty rk05 disk image that will become the games disk.
* `disk3.rk05`: A copy of `resources/unmodified-umd-disks/umd-resource.rk05`.
* `disk4.rk05`: A copy of ock.rk05.

To setup the `games.rk05` games disk, we will simply copy the contents of the second half of the `ock.rk05` disk to the games disk:
```
.COPY SDA1:<SDB3:*.*
```

Then we will copy SCPWR3 from `umd-resource.rk05` to `games.rk05` and build it:
```
.COPY SDA1:<SDB2:SPCWR3.12

.COMPILE SDA1:<SDA1:SPCWR3.12
ERRORS DETECTED: 0
LINKS GENERATED: 106
```
