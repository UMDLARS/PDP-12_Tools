import sys
import struct
from lib import tape_rim as tr
from lib import tape_common as tc

# Open rim file.
fp = open(sys.argv[1], "rb")

# Alloc memory image.
mem = bytearray(tc.MEM_SIZE * 2)

# This function will be called by tr.read_tape for each entry in the rim tape.
def writer(addr, data):
    bs = struct.pack(">H", data)
    mem[addr * 2] = bs[0]
    mem[addr * 2 + 1] = bs[1]

# Call the tape reading function.
tr.read_tape(fp, writer)

# Write memory to file.
with open(sys.argv[2], "wb") as out:
    out.write(mem)
