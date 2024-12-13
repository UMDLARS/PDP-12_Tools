# Copy files to and from an OS/8 RK05 disk image
This document details how to copy files to and from an OS/8 RK05 disk image using the tools provided by 8tools.

`$MY_RK05_IMAGE` refers to the RK05 disk image being targetted.

## Unpacking an OS/8 RK05 image
8tools' `os8xplode` tool may be used to unpack an OS/8 RK05 image:
```
./8tools/os8xplode $MY_RK05_IMAGE
```

This will create two new directories next to the original RK05 image.
The `$MY_RK05_IMAGE.0` and `$MY_RK05_IMAGE.1` contain the contents of the first and second halves of the provided RK05 image respectively.
`$MY_RK05_IMAGE.xml` will also be generated and contains information on start and end blocks for each file on the RK05 image along with information on where each file was extracted.

## Repacking an OS/8 RK05 image
8tools' `os8implode` and `mkdsk` tools may be used to repack an unpacked OS/8 RK05 disk image.
First, `os8implode` should be used to generate a new xml with location and block information based on the files in `$MY_RK05_IMAGE.0` and `$MY_RK05_IMAGE.1`.
`$MY_RK05_IMAGE` is passed as the argument to `os8implode`, but will not be touched or used in any capacity:
```
./8tools/os8implode $MY_RK05_IMAGE
```

This will generate the new xml at `$MY_RK05_IMAGE.xml+`

This new xml can be passed to `mkdsk` to generate a new RK05 image:
```
./8tools/mkdsk $MY_RK05_IMAGE.xml+
```
The new disk image will be located at `$MY_RK05_IMAGE.new`

The old disk image can be replaced with the new by:
```
cp $MY_RK05_IMAGE.new $MY_RK05_IMAGE
```

All of these steps can be combined into a one-liner:
```
./8tools/os8implode $MY_RK05_IMAGE && ./8tools/mkdsk $MY_RK05_IMAGE.xml+ && cp $MY_RK05_IMAGE.new $MY_RK05_IMAGE
```
