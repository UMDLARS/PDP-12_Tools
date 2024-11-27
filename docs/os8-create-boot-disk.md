# Boot Disk Image Generation
This document details how to recreate our boot (`boot-pdp12.rk05` and `boot-simh.rk05`) and games (`games.rk05`) disk images.

Our OS/8 boot and games rk05 disk images are derived from the "OCK boot" OS/8 disk image provided by the PiDP-8/I project.
We apply a set of changes on top of the PiDP-8/I image to enabling using os8diskserver and PDP-12 specific features.


## Required Resources
* This repository.
* "OCK boot" ock.rk05 OS/8 image from the PiDP-8/I project: https://tangentsoft.com/pidp8i/wiki?name=Home
* OS/8 FORTRAN IV LIBRARY Sources (we used those from the PiDP-8/I project under `src/os8/ock/LANGUAGE/FORTRAN4/`; these are included on the second side of the `resources/unmodified-umd-disks/umd-resource.rk05` disk image in this repo).

## Disable The Init Script
The mitigate some issues later, we'll want to first disable the INIT script provided by the PiDP-8/I ock.rk05 image. To do this, we'll use simh to execute the `SET SYS NO INIT` command on the image.

If you are using the copy of simh provided by this repo, you can execute it from the root of this repo using:
```
./simh/BIN/pdp8
```

Inside simh, attach the ock.rk05 image to rk0, boot from rk0, then execute `SET SYS NO INIT`:
```
PDP-8 simulator V4.0-0 Current        git commit id: 524a98b2
sim> attach rk0 path/to/ock.rk05
sim> boot rk0

PIDP-8/I TRUNK:ID[76133AACD0] - OS/8 V3D COMBINED KIT - KBM V3T - CCL V3
A
BUILT FROM SOURCE BY TANGENT@PIDP8I ON 2021.02.14 AT 15:37:06 MST

RESTART ADDRESS = 07600

TYPE:
    .DIR                -  TO GET A LIST OF FILES ON DSK:
    .DIR SYS:           -  TO GET A LIST OF FILES ON SYS:
    .R PROGNAME         -  TO RUN A SYSTEM PROGRAM
    .HELP FILENAME      -  TO TYPE A HELP FILE

.SET SYS NO INIT

.
```

To exit out of simh, press Ctrl+E then type `exit` into the simh shell.
```
.
Simulation stopped, PC: 01207 (KSF)
sim> exit
Goodbye
```

### Injecting The SerialDisk System Handler
Since the SerialDisk handlers are not yet installed with BUILD, we'll need to use a tool from os8diskserver to inject the SerialDisk system handler. Assuming you're using the os8diskserver included with this repo:
```
ODS_PATH=os8-disk-server/os8diskserver/SerialDisk
gcc $ODS_PATH/tools/pal.c -o $ODS_PATH/tools/pal
make -C $ODS_PATH/handler
make -C $ODS_PATH/installer
$ODS_PATH/installer/handler_installer $ODS_PATH/handler/sdsksy.bin path/to/ock.rk05
```


### Copying The SerialDisk Handler Sources
While the above process did install the SerialDisk system handler, it did it in a somewhat hacky way and didn't install the non-system handler.
So next we'll be copying over the source files for both the system and non-system SerialDisk handlers so that we can properly install them later.

First, we'll unpack the ock.rk05 image. This can be done using the os8xplode script provided by 8tools:
```
./8tools/os8xplode path/to/ock.rk05
```

This will create the following new directories containing the contents of the ock.rk05 image:
* ock.rk05.0
* ock.rk05.1

From os8diskserver, copy the `sdsksy.pal` and `sdskns.pal` files located under `os8-disk-server/os8diskserver/SerialDisk/handler` into `ock.rk05.0` as `sdsksy.pa` and `sdskns.pa` respectively.

To repack the ock.rk05 image, we use the `os8implode` and `mkdsk` scripts, which are also provided by 8tools:
```
./8tools/os8implode ock.rk05
./8tools/mkdsk ock.rk05.xml+
```

This will create a new `ock.rk05.new` disk image that now contains the source files for the two handlers.

### Building the SerialDisk Handlers
We can now boot our image either on the PDP-12 system or under simh to properly install the SerialDisk handlers and setup everything else.

If it does not exist, create a `disks` directory in the root of this repository.
If this directory does exist, make sure it is empty.
Create copies of the following within the `disks` directory:
* Your `ock.rk05.new` to `os8-disk-server/disks/boot-pdp12.rk05` and/or `os8-disk-server/disks/boot-simh.rk05`, depending on whether you'll be using the PDP-12 or SIMH for this process.
* `resources/unmodified-umd-disks/blank.rk05` to `os8-disk-server/disks/games.rk05`
* `resources/unmodified-umd-disks/umd-resource` to `os8-disk-server/disks/disk3.rk05`
* An untouched copy of your `ock.rk05` to `os8-disk-server/disks/disk4.rk05`

Now, perform the instructions in this repository's main readme to boot OS/8 on the PDP-12 or in SIMH.

Now running OS/8, we use the following commands to compile both of the SerialDisk handlers:
```
.COMPILE SYS:<SYS:SDSKSY.PA
.COMPILE SYS:<SYS:SDSKNS.PA
```

The output of these commands should look like this:
```
.COMPILE SYS:<SYS:SDSKSY.PA
ERRORS DETECTED: 0
LINKS GENERATED: 0

.COMPILE SYS:<SYS:SDSKNS.PA
ERRORS DETECTED: 0
LINKS GENERATED: 0

.
```

And if we run `DIR SYS:` we should see `SDSKSY.BN` and `SDSKNS.BN` files:
```
.DIR SYS:

          

[...]
UWF16K.SV  24               SDSKSY.BN   1               SDSKNS.BN   2


1691 FREE BLOCKS

.
```

### Installing the SerialDisk Handlers
With the SerialDisk handlers built, we can now install them using `BUILD`.

First, start `BUILD` using `RUN SYS BUILD`.
This should bring up a new `$` prompt, if we execute `PR` (or `PRINT`) we should see something like this:
```
.RUN SYS BUILD

$PR

RK8E: *SYS  *RKA0 *RKB0 
RK05:  RKA0  RKB0 *RKA1 *RKB1 *RKA2 *RKB2  RKA3  RKB3 
RX02:  RXA0  RXA1 
KL8E: *TTY  
LPSV: *LPT  
TC08:  SYS   DTA0 
TC  : *DTA0 *DTA1  DTA2  DTA3  DTA4  DTA5  DTA6  DTA7 
PT8E: *PTP  *PTR  
TD8E:  SYS   DTA0  DTA1 
ROM :  SYS   DTA0  DTA1 
TD8A:  DTA0  DTA1 

DSK=RK8E:RKB0
$
```

With `BUILD` running, you may first want to unload some of the handlers you will not need, this can be done with the `UN` (or `UNLOAD`) command.
We unload the RK8E and RK05 handlers:
```
$UN RK8E
$UN RK05
```

The SerialDisk handlers can then be loaded using the `LO` (or `LOAD`) command:
```
$LO SYS:SDSKSY
$LO SYS:SDSKNS
```

The `PR` command should now show the `SDSY` and `SDNS` handlers:
```
$PR

RX02:  RXA0  RXA1 
KL8E: *TTY  
LPSV: *LPT  
TC08:  SYS   DTA0 
TC  : *DTA0 *DTA1  DTA2  DTA3  DTA4  DTA5  DTA6  DTA7 
PT8E: *PTP  *PTR  
TD8E:  SYS   DTA0  DTA1 
ROM :  SYS   DTA0  DTA1 
TD8A:  DTA0  DTA1 
SDSY:  SYS   SDA0  SDB0 
SDNS:  SDA0  SDB0  SDA1  SDB1  SDA2  SDB2  SDA3  SDB3 

DSK=RK8E:RKB0
```

The SerialDisk handlers are loaded, but they are not yet active for any of the SerialDisk devices.
To activate them, we use the `IN` (or `INSERT`) command, for now we'll activate just the system devices, SDA2, and SDB2:
```
$IN SDSY:SYS,SDA0,SDB0
$IN SDNS:SDA2,SDB2
```

We will also assign the default disk (`DSK`), for now we will use `SDSY:SDB0`:
```
DSK=SDSY:SDB0
```

The `PR` command should now show a `*` next to SDSY's and SDNS's devices and `DSK` should now be `SDSY:SDB0`:
```
$PR

RX02:  RXA0  RXA1 
KL8E: *TTY  
LPSV: *LPT  
TC08:  SYS   DTA0 
TC  : *DTA0 *DTA1  DTA2  DTA3  DTA4  DTA5  DTA6  DTA7 
PT8E: *PTP  *PTR  
TD8E:  SYS   DTA0  DTA1 
ROM :  SYS   DTA0  DTA1 
TD8A:  DTA0  DTA1 
SDSY: *SYS  *SDA0 *SDB0 
SDNS:  SDA0  SDB0  SDA1  SDB1 *SDA2 *SDB2  SDA3  SDB3 

DSK=SDSY:SDB0
```

We can now exit out of build using the `BOOT` command.
When `WRITE ZERO DIRECT?` comes up, press the enter/return key:
```
$BOOT
WRITE ZERO DIRECT?
SYS BUILT
.
```

Note: We do not save `BUILD` right now, as for whatever reason it breaks `BUILD`?
We will save it later after also cleaning up the loaded handlers.

At this point, `SDA0`, `SDB0`, `SDA2`, and `SDB2` should be usable.
You should be able to use `DIR SDA2:` and have it show the following:
```
.DIR SDA2:

          

ASR33 .PA  10               BAT   .PA  12               CR8E  .PA  21
CS    .PA  23               DF32NS.PA   8               DF32SY.PA   9
DUMP  .PA  19               KL8E  .PA  52               L645  .PA   8
LINCNS.PA  10               LINCSY.PA   9               LPSV  .PA  12
LQP   .PA  14               LSPT  .PA  10               PT8E  .PA  11
RF08NS.PA  10               RF08SY.PA   9               RK08NS.PA  11
RK08SY.PA  16               RK8ENA.PA  17               RK8ENS.PA  17
RK8ESY.PA  15               RL0   .PA  28               RL1   .PA  28
RL2   .PA  28               RL3   .PA  28               RLC   .PA  27
RLSY  .PA  31               ROMMSY.PA   9               RX78C .PA  34
RXNS  .PA  32               RXSY1 .PA  39               RXSY2 .PA  39
SDSKNS.PA  32               SDSKSY.PA  37               TC08NS.PA  14
TC08SY.PA  13               TD8EA .PA  20               TD8EB .PA  20
TD8EC .PA  20               TD8ED .PA  20               TD8ESY.PA  20
TM8E  .PA  28               VR12  .PA  20               VT50  .PA  11
VXNS  .PA  14               VXSY  .PA  14               

2312 FREE BLOCKS
```

### Installing Additional Handlers
To be able to use additional features of the PDP-12 and SIMH, we will want to install some additional handlers.
The handlers we will install will depend on whether the boot image is intended to primarily target the PDP-12 or SIMH.

Note: Building an image targetting the PDP-12 with PDP-12 handlers using SIMH works fine, so does building a SIMH image with SIMH handlers using the PDP-12.

We will first run `BUILD` again using `RUN SYS BUILD`:
```
.RUN SYS BUILD

$
```

For sake of simplicity, we will unload all loaded handlers.
The `PR` command can be used to get a list of all installed handlers:
```
$PR

RK8E: *SYS  *RKA0 *RKB0 
RK05:  RKA0  RKB0 *RKA1 *RKB1 *RKA2 *RKB2  RKA3  RKB3 
RX02:  RXA0  RXA1 
KL8E: *TTY  
LPSV: *LPT  
TC08:  SYS   DTA0 
TC  : *DTA0 *DTA1  DTA2  DTA3  DTA4  DTA5  DTA6  DTA7 
PT8E: *PTP  *PTR  
TD8E:  SYS   DTA0  DTA1 
ROM :  SYS   DTA0  DTA1 
TD8A:  DTA0  DTA1 

DSK=RK8E:RKB0
```

Then the `UN` command can be used to unload them:
```
$UN RK8E
$UN RK05
$UN RX02
$UN KL8E
$UN LPSV
$UN TC08
$UN TC
$UN PT8E
$UN TD8E
$UN ROM
$UN TD8A
```

The `PR` command should now show nothing aside from `DSK`:
```
$PR


DSK=RK8E:RKB0
```

Now, we can add our handlers.
This section assumes that the first half of disk 3 (`disk3.rk05` under `disks`) contains built handlers (e.g., is a copy of `resources/unmodified-umd-disks/umd-resource.rk05`).
All of the handlers except the SerialDisk handlers are present on SDA2 (second side of `disk3.rk05`/`umd-resource.rk05`).
The SerialDisk handlers will still be on SYS from earlier.

#### Common Handlers
We always install and enable the following handlers (form: `HANDLER[DEV1,DEV2...]`):
* `SDNS[SYS,SDA0,SDB0]`: SerialDisk System Handler
* `SDSY[SDA1,SDB1,SDA2,SDB2,SDA3,SDB3]`: SerialDisk Non-System Handler
* `KL8E[TTY]`: TTY/Console Handler

The common handlers can be installed and enabled with:
```
$LO SYS:SDSKSY
$LO SYS:SDSKNS
$LO SDA2:KL8E
$IN SDSY:SYS,SDA0,SDB0
$IN SDNS:SDA1,SDB1,SDA2,SDB2,SDA3,SDB3
$IN KL8E:TTY
```

We will also now set the default disk (`DSK`) to SDNS:SDA1 (first side of `games.rk05`):
```
DSK=SDNS:SDA1
```

#### PDP-12 Handlers
On the PDP-12 we install and enable the following additional handlers:
* `LNC[LTA0, LTA1]`: LINCTape Non-System Handler.
* `KS33[PTR]`: Paper Tape Handler.
* `VR12[TV]`: Scope/Display/TV Handler.

The PDP-12 handlers can be installed and enabled using:
```
$LO SDA2:LINCNS
$LO SDA2:LSPT
$LO SDA2:VR12
$IN LNC:LTA0,LTA1
$IN KS33:PTR
$IN VR12:TV
```

With the PDP-12 handlers installed and enabled, the output of `PR` should look something like:
```
$PR

SDSY: *SYS  *SDA0 *SDB0 
SDNS:  SDA0  SDB0 *SDA1 *SDB1 *SDA2 *SDB2 *SDA3 *SDB3 
KL8E: *TTY  
LNC : *LTA0 *LTA1  LTA2  LTA3  LTA4  LTA5  LTA6  LTA7 
KS33:  PTP  *PTR  
VR12: *TV   

DSK=SDNS:SDA1
```

#### SIMH Handlers
On SIMH we install and enable the following additional handlers:
* `TC[DTA0,DTA1]`: DECTape Non-System Handler.
* `PT8E[PTP,PTR]`: Paper Tape/Paper Punch Handler.

The SIMH handlers can be installed and enabled using:
```
$LO SDA2:TC08NS
$LO SDA2:PT8E
$IN TC:DTA0,DTA1
$IN PT8E:PTP,PTR
```

With the SIMH handlers installed and enabled, the output of `PR` should look something like:
```
$PR

SDSY: *SYS  *SDA0 *SDB0 
SDNS:  SDA0  SDB0 *SDA1 *SDB1 *SDA2 *SDB2 *SDA3 *SDB3 
KL8E: *TTY  
TC  : *DTA0 *DTA1  DTA2  DTA3  DTA4  DTA5  DTA6  DTA7 
PT8E: *PTP  *PTR  

DSK=SDNS:SDA1
```

#### Exiting and Saving BUILD
With all desired handlers installed and enabled, we can exit `BUILD` using the `BOOT` command:
```
$BOOT
SYS BUILT
.
```

Finally, we can save `BUILD` so that we don't have to redo everything if/when we want to change something with `BUILD` in the future:
```
.SAVE SYS BUILD
```

### Disabling Pausing In The TTY
By default, the `KL8E` TTY handler will pause for a few seconds every once in awhile.
This does not serve much purpose in our setup (using a modern terminal emulator) and can be disabled.
If this behavior is desired, this section may be skipped.

To disable TTY pausing, the `SET TTY NO PAUSE` command may be used:
```
.SET TTY NO PAUSE

.
```

### Setting Up The Games Disk
This section assumes that an undisturbed copy of `ock.rk05` from the PiDP-8/I project is mounted as disk 4 (`ock.rk05` is `disks/disk4.rk05`).
Additionally, it is assumed that disk 3 is the UMD resource disk (`resources/unmodified-umd-disks/umd-resource.rk05` is `disks/disk3.rk05`).

To setup the `games.rk05` games disk, we will simply copy the contents of the second half of the `ock.rk05` disk (should be mounted as `disk4.rk05`) to the games disk:
```
.COPY SDA1:<SDB3:*.*
```

Then we will copy over and build SPCWR3 (Space War) to the games disk:
```
.COPY SDA1:<SDB2:SPCWR3.12

.COMPILE SDA1:<SDA1:SPCWR3.12
ERRORS DETECTED: 0
LINKS GENERATED: 106
```

### Adding PDP-12 FORTRAN Libraries
There are a few PDP-12 specific FORTRAN libraries that allow the use of PDP-12 specific features within FORTRAN.
By default, the PiDP-8/I project does not include these libraries, but we can add them.
Additionally, PiDP-8/I includes the `CLK8A` library, which doesn't work on the PDP-12, instead of the `CLOCK` library.
We can also replace the `CLK8A` library with the `CLOCK` library.

This section assumes that disk 3 is the UMD resource disk (`resources/unmodified-umd-disks/umd-resource.rk05` is `disks/disk3.rk05`).

First, we'll compile the necessary FORTRAN libraries:
```
.COMPILE ADC<SDB2:ADC.RA
.COMPILE CLOCK<SDB2:CLOCK.RA
.COMPILE PLOT<SDB2:PLOT.RA
.COMPILE REALTM<SDB2:REALTM.RA
```

Now we'll create a copy of `SYS:FORLIB.RL` with these new libraries added using `LIBRA`:
```
.R LIBRA
*FORLIB.RL,TTY:<SYS:FORLIB.RL,DSK:ADC.RL,CLOCK.RL,PLOT.RL,REALTM.RL/R
```

The output of the above should look something like this:
```
SYNC IS DUPLICATE NAME
CLOCK IS DUPLICATE NAME
#CLINT IS DUPLICATE NAME
TIME IS DUPLICATE NAME

LIBRA V 24A  CATALOG OF FORLIB.RL

IABS    ABS     SIGN    ISIGN   AMIN0   AMIN1   MIN0    MIN1
AMAX0   AMAX1   MAX0    MAX1    DIM     IDIM    EXP     EXP3
SIN     COS     TAN     TANH    SQRT    ASIN    ACOS    ATAN
FLOAT   CHARS   CHAR    CGET    CPUT    CHKEOF  ALOG10  DATE
ATAN2   IFIX    AINT    INT     SINH    ALOG    COSH    AMOD
MOD     #LTR    #EQ     #NE     #GE     #LE     #GT     #LT
#EXPII  #RFCV   #WFCV   #RFDV   #PAUSE  #EXPIR  #FIX    ONQI
ONQB    ADC     SYNC    CLOCK   #CLINT  TIME    PLOT    PLOTR
CLRPLT  SCALE   #DISP   SAMPLE  REALTM  ADB
```

`LIBRA` can be exited using Ctrl+C, then we can replace `SYS:FORLIB.RL` with our newly created `FORLIB.RL`:
```
.DEL SYS:FORLIB.RL
Files deleted:
FORLIB.RL

.COPY SYS:<DSK:FORLIB.RL
FILES COPIED:
FORLIB.RL
```

Finally, we can cleanup the files we don't need anymore:
```
.DEL ADC.RL,CLOCK.RL,PLOT.RL,REALTM.RL,FORLIB.RL
```

If using actual PDP-12 hardware, the following example from the OS/8 handbook can be used to test the scope/display, clock, and analog channel sampling:
```
        DIMENSION PLTBUF(400),DATBUF(50)
1       CALL CLRPLT(400,PLTBUF)
        CALL REALTM(DATBUF,50,3,1,500)
        CALL CLOCK(8,10)
        DO 100 I=1,500
100     CALL PLOT(1,I/384.,ADB(X)/1024.+.5)
C       NOW PAUSE SO THAT POINTS WILL BE DISPLAYED
        READ(4,10)Q
10      FORMAT(I2)
        GO TO 1
        STOP
        END
```

This example will sample data from analog channel 3 (the knob labeled "3" under "ANALOG CHANNELS 0-7") for 50 seconds, then display a fancy line on the scope/display.
