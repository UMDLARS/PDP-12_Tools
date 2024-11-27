# PDP-12 Tools
This repository contains a set of tools for working with UMD's PDP-12 computer. These tools include:
* Our fork of minicom, which includes some workarounds for our setup.
* os8diskserver
* simh
* A set of rk05 disk images containing OS/8, games, and system handlers.
* A set of scripts for booting OS/8 both on UMD's PDP-12 as well as on simh.

## Dependencies
* Ubuntu (22.04+)/Debian (12+): `sudo apt install build-essential autoconf gettext pkgconf ncurses-dev git-svn`

## Setup
If you have not already, clone this repo somewhere using:
```
git clone git@github.com:UMDLARS/PDP-12_Tools.git --recursive
```

With the repo cloned, you can run the setup script.
This script will compile everything, setup configs, and create a copies of the OS/8 disk images:

WARNING: If you run this script in an already setup environment, your configs and OS/8 disks will be reset to their default states.
```
./scripts/setup.sh
```

## Updating
To update this repo, you may use the update script:

WARNING: This will reset any modifications you have made to files in this repo or its subrepos. Added files, like your os8 disks, will be kept
```
./scripts/update.sh
```
