# PDP-12 Tools
This repository contains a set of tools for working with UMD's PDP-12 computer. These tools include:
* Our fork of minicom, which includes some workarounds for our setup.
* os8diskserver
* simh
* A set of rk05 disk images containing os/8, games, and system handlers.
* A set of scripts for booting os/8 both on UMD's PDP-12 as well as simh.

## Setup
If you have not already, clone this repo somewhere using:
```
git@github.com:UMDLARS/PDP-12_Tools.git
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
