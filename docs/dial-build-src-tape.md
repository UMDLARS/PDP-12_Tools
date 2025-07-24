# Building LAP6-DIAL-MS From Source Tapes
LAP6-DIAL-MS (DIAL-MS) source code was distributed across two LINCtapes, `DEC-12-SEZB-U1` and `DEC-12-SEZB-U2`.
This is a tutorial on how to compile DIAL-MS from these two tapes.

This is based on the `BUILDING LAP6-DIAL SOURCES Program Description (DEC-12-ZR9A-D)` document from DEC, some instructions have been shuffled around to avoid the need to swap tapes multiple times.
That document also appears to assume that you're building DIAL-MS with the source tape mounted as a secondary device (unit 1 or 11) under another complete system.
However, the source tapes include a basic DIAL environment themselves that is completely usable for building DIAL-MS, this tutorial uses that builtin version of DIAL to build DIAL-MS.

This also assumes that you're building DIAL-MS onto another LINCtape, but most of these instructions can be applied when building DIAL-MS onto other devices as well.

Any time a `#` shows up after a command in this tutorial, the `#` and everything after to the end of the line is a comment.

## Setup
Prior to building DIAL-MS, you'll need a "new" LINCtape that's marked with 256 word blocks and has at least 512 blocks.
Marking a tape with MARK12 using either the standard LINC or 896 block format will work.
I usually go with the 896 word block format because there's no reason not to.
DIAL-MS won't use more than 512 blocks itself, but you can still manually put stuff in the upper blocks with, e.g., `PIP`.

This new tape must be mounted on a LINCtape transport designated unit 1, which must have `WRITE ENABLE` and `REMOTE` set.

This tutorial doesn't cover marking tapes, but I'll note that both DIAL-MS source tapes include a copy of `MARK12` (with 896 block format support).

You'll also, of course, need a set of DIAL-MS source tapes...
and a functioning PDP-12...
with functioning LINCtape transports...

## Actually Building It
This section will be split into three subsections:
1) Building the base system,
2) Building bundled system utilities (`PIP`, `CREF`), and
3) Booting your new system for the first time.

Prior to continuing, make sure you have a LINCtape formatted and mounted on unit 1 as described in [setup](#Setup)

### Building The Base System
In this section you'll build the base DIAL-MS system consisting of the assembler, editor, and standard DIAL-MS commands.

#### Booting Into The Second Source Tape
We're starting with the second source tape here since it contains most of the base system soures, while the first tape mostly contains extra program sources.
Both tapes conveniently include a version of DIAL that can be used to build DIAL (yes you use DIAL to build DIAL).
So the first thing we'll do is boot into that.

1) Start by mounting the second source tape (`DEC-12-SEZB-U2`) on LINCtape transport unit 0 with `REMOTE` and `WRITE ENABLE` set
(DIAL requires that `WRITE ENABLE` is set to function and automatically writes the text buffer back to tape, even if it hasn't been modified, we won't be modifying anything on the source tape).
2) Set the `MODE` switch on the PDP-12's console to `LINC`.
3) Press the `I/O PRESET` switch, make sure the `LINC MODE` light is on and the instruction and data field indicators indicate 2 and 3, respectively.
4) Set the `RIGHT SWITCHES` to `0701` and the `LEFT SWITCHES` to `7300`.
5) Press the `DO` switch, LINCtape unit 0 will begin moving then stop shortly after; continue once it has stopped.
6) Press the `START 20` switch to start DIAL, LINCtape unit 0 will begin moving again and shortly after the DIAL editor will come up.
    - If nothing shows up, make sure you have the `BRIGHTNESS` knob on the VR12 display turned up.
7) You are now booted into the second DIAL-MS source tape :)

#### _Acutally_ Building It
Now that we're in the build environment, we can actually build DIAL-MS now.

1) Build the editor by entering the following commands in command mode, which you can get into by entering a linefeed (`CTRL-J` in the likely chance you don't have a linefeed key):
    ```
    ZE              #Zero the binary work area
    AS EDITOR1,0    #Build the editor from unit 0
    ```
2) Load `PIP` by entering `LO PIP,0` in command mode.
    - While using `PIP`, you may want to set `WRITE LOCK` on unit 0 to make sure you don't accidentally write to unit 0. `PIP` is like DIAL's version of `dd`!
3) In `PIP`, enter the the following sequence to copy the editor to the correct locations on the new tape:
    ```
    A           #Copy 010 blocks from 0400 (binary work area) to 0300 (editor's home)
    C
    L1;400,10
    L1;300
    A           #Copy 07 blocks from 0371 to 0311
    C
    L1;371,7
    L1;311
    A           #Copy 1 block from 0415 to 0320
    C
    L1;415,1
    L1;320
    A           #Copy 1 block from 0423 to 0321
    C
    L1;423,1
    L1;321
    ```
4) Exit back to DIAL by entering `CTRL-D`.
5) Build the system build tool using the following commands (again, in command mode, this will be assumed henceforth):
    ```
    ZE
    AS BUILD,0      #Build BUILD... huh
    ```
6) Load `PIP` again (`LO PIP,0`) and copy the following blocks to their new homes:
    ```
    A           #Copy 1 block from 0400 to 0310
    C
    L1;400,1
    L1;310
    A           #Copy 1 block from 0406 to 0345
    C
    L1;406,1
    L1;345
    A           #Copy 1 block from 0407 to 0365
    C
    L1;407,1
    L1;365
    A           #Copy 1 block from 0405 to 0366
    C
    L1;405,1
    L1;366
    ```
7) Exit back to DIAL (`CTRL-D`).
8) Build the assembler using the following commands:
    ```
    ZE
    AS ASSEM1,0     #Assemble the assembler... double huh
    ```
9) Then copy it over using `PIP`:
    ```
    A           #Copy 011 blocks from 0370 to 0330
    C
    L1;370,11
    L1;330
    A           #Copy 1 block from 0402 to 0344
    C
    L1;402,1
    L1;344
    A           #Copy 02 blocks sfrom 0403 to 0326
    C
    L1;403,2
    L1;326
    A           #Copy 03 blocks from 0405 to 0341
    C
    L1;405,3
    L1;341
    A           #Copy 1 block from 0422 to 0324
    C
    L1;422,1
    L1;324
    ```
10) Exit back to DIAL.
11) Build the `PS`, `PX`, and `DX` command using the following commands:
    ```
    ZE
    AS PRINTMS,0    #Build the print source command
    AS PXDXSRC,0    #Build the print/display index commands
    ```
12) And copy them over using `PIP`:
    ```
    A           #Copy 04 blocks from 0400 to 0361
    C
    L1;400,4
    L1;361
    ```
13) Exit back to DIAL.
14) Build the binary loader using the following commands:
    ```
    ZE
    AS LOADER,0     #Build the program loader
    ```
15) You guessed, copy it with `PIP`:
    ```
    A           #Copy 2 blocks from 0420 (nice) to 0354
    C
    L1;420,2
    L1;345
    ```
16) Exit back to DIAL.
17) We're now done with the second source tape! You can safely exit DIAL using the `EX` command (stopping the machine should also be fine).
18) Unmount the second source the second source tape from unit 0 (leave your new tape on unit 1) and boot the first DIAL-MS source tape (`DEC-12-SEZB-U1`) using the same procedure [from earlier](#Booting-Into-The-Second-Source-Tape)
19) Aaaand back to building. Build the file commands using the following commands:
    ```
    ZE
    AS FILECOMS,0   #Build the file commands
    ```
20) Then copy it over using `PIP` one final time:
    ```
    A           #Copy 04 blocks from 0400 to 0350
    C
    L1;400,4
    L1;350
    ```
21) Exit back to DIAL-MS, and you're done! You now have a functioning blank DIAL-MS tape.
    You may exit DIAL and [start your new tape](#) or continue and [build the bundled utilities](#).

### Building the Bundled Utilities
The first DIAL-MS source tape includes the following extra utilities:
* `PIP` - Allows copying data to and from different locations -- operating both on files and raw block data.
* `CREF12` - Provides a listing off all symbols in a source program, along with where all of those symbols are used.
* `GENASYS`

Building `GENASYS` is not possible without additional resources because DEC included the wrong ED with these sources.
`GENASYS` needs FRED, but DEC included MILDRED; the EDs are not compatibile with eachother.
Very incompatible.
Although FRED is kinda cringe so I understand DECs decision.

All of these can be built separate, so they'll have their own subsections.
But each section requires that you are booted into the first DIAL-MS source tape, if coming from the system build section you don't need to do anything.
If you are not, follow the procedure [here](#Booting-Into-The-Second-Source-Tape) but using the first DIAL-MS source tape.
Also make sure your new tape is mounted as LINCtape unit 1.

#### Building PIP
`PIP` can be built using the following commands in command mode, which you can enter by entering a linefeed (`CTRL-J` if you don't have a linefeed character):
```
ZE          #Zero the binary work area
AS PIP1,0   #Build PIP from sources on unit 0
SB PIP,1,P  #Save built binary to unit 1, and set it up to start at location 0200 in PDP-8 mode
```
`PIP` is now built and ready to go!

#### Building CREF12
`CREF12` can be built in most the same way as `PIP`.
Use the following commands in command mode:
```
ZE              #Zero the binary work area
AS CREF12,0     #Build CREF12 from sources on unit 0
SB CREF12,1,P   #Save built binary to unit 1 and set it up to start at location 0200 in PDP-8 mode
```
`CREF12` is now built and ready to go!

#### Build GENASYS
If you're able to deal with the FRED... dilema... its build procedure is a bit more complicated.
Enter the following commands in command mode:
```
ZE                  #Zero the binary work area
AS FRED,0           #Assemble the almighty FRED... WAIT NO-
AS GENASYS,0        #Assemble GENASYS itself
SB GENASYS,0,P,200  #Save built binary to unit 1 and set it up to start at location 0400 in PDP-8 mode
```

### Booting Your New System
#### First Time Boot
Booting DIAL-MS for the first time requires a slightly different procedure than a typical boot.
This procedure is:
1) Mount the DIAL-MS system tape on a LINCtape transport designated unit 0.
2) Set `REMOTE` and `WRITE ENABLE` on LINCtape unit 0.
3) The the console `MODE` switch to `LINC`.
4) Set the `LEFT SWITCHES` to `0701` and the `RIGHT SWITCHES` to `7310`.
5) Press the `I/O PRESET` switch.
6) Press the `DO` switch, LINCtape unit 0 will begin moving, continue once it stops.
7) Press the `START 20` switch. LINCtape unit 0 will begin moving again, once it's done you'll be booted into the DIAL editor.

#### Subsequent Boots
All subsequent boots use the following procedure:
This procedure is:
1) Mount the DIAL-MS system tape on a LINCtape transport designated unit 0.
2) Set `REMOTE` and `WRITE ENABLE` on LINCtape unit 0.
3) The the console `MODE` switch to `LINC`.
4) Set the `LEFT SWITCHES` to `0701` and the `RIGHT SWITCHES` to `7300`.
5) Press the `I/O PRESET` switch.
6) Press the `DO` switch, LINCtape unit 0 will begin moving, continue once it stops.
7) Press the `START 20` switch. LINCtape unit 0 will begin moving again, once it's done you'll be booted into the DIAL editor.

The only difference is that the first boot reads blocks starting at 0310 instead of 0300.
Block 0310 contains the system build routine, which sets up the device handlers and system device information (is it a LINCtape? RK05?)

