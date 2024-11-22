# PDP-12 Tools
This repository contains a set of tools for working with UMD's PDP-12 computer. These tools include:
* Our fork of minicom, which includes some workarounds for our setup.
* os8diskserver
* simh
* A set of rk05 disk images containing os/8, games, and system handlers.
* A set of scripts for booting os/8 both on UMD's PDP-12 as well as simh.

## Dependencies
* Ubuntu (22.04+)/Debian (12+): `sudo apt install build-essential autoconf gettext pkgconf ncurses-dev`

## Setup
If you have not already, clone this repo somewhere using:
```
git clone git@github.com:UMDLARS/PDP-12_Tools.git --recursive
```

With the repo cloned, you can run the setup script.
This script will compile everything and create a copies of the os/8 rk05 disk images:
```
./setup.sh
```

## Updating
To update this repo, simply pull the latest commit:
```
git pull
git submodule update --recursive
```
Then run the build script to rebuild everything:
```
./build.sh
```

## OS/8
OS/8 can be booted in either simh or on our PDP-12 computer.
Only the boot disk/disk1 is different between the two environment, the default disk/games disk/disk2, disk3, and disk4 are shared.
This makes it possible to work on something under the simh environment and later test it on the PDP-12 with minimal effort, or vice-versa.

Both environment behave largely the same, but there are some differences:
* The simh image has the TC08NS handler installed, allowing the use of DECTape images.
* The PDP-12 image has the LINCNS handler installed, allowing the use of physical LINCTapes.
* The PDP-12 image has the VR12 handler installed, allowing the use of the VR12 scope/display.
* Only the PDP-12 can use LINC mode and its associated features.

### Booting OS/8 on the PDP-12
Before anything, make sure your computer is plugged into the USB hub that's connected to the PDP-12.
Additionally, make sure your current user has access to the `/dev/ttyUSBx` devices.
On most Linux distributions, this can be accomplished by adding yourself to the `dialout` group then rebooting:
```
sudo usermod -a -G dialout $USER
sudo reboot
```

Now you'll need to send the OS/8 bootloader.
On the PDP-12, punch in the RIM Loader, then with the RIM Loader running, execute the `send-os8-bootloader-pdp12.sh` script in this repo:
```
./send-os8-bootloader-pdp12.sh
```

Then on your computer, run the `boot-os8-pdp12.sh` script:
```
./boot-os8-pdp12.sh
```

Stop the RIM Loader and start the OS/8 bootloader by pressing the Start 20 switch.

You should now have a OS/8 command prompt on the minicom window opened by `boot-os8-pdp12.sh`.

### Booting OS/8 under simh
To boot OS/8 under simh, simply execute the `boot-os8-simh.sh` script:
```
./boot-os8-simh.sh
```

You should now have a simh window that you can run OS/8 commands in.

### Restoring disks to their default states
The `restore-disk-images.sh` script can be used to restore the OS/8 disk images to their default states:
```
./restore-disk-images.sh
```

