import sys
import struct
from lib import tape_bin as tb
from lib import tape_common as tc

# Open bin file.
fp = open(sys.argv[1], "rb")

# Alloc memory image.
mem = bytearray(tc.tc.MEM_FIELD_COUNT * tc.MEM_SIZE * 2)

# This function will be called by tb.read_tape for each value in the bin tape.
def writer(field, addr, data):
    base = field * tc.MEM_SIZE + addr * 2
    bs = struct.pack(">H", data)
    mem[base]       = bs[0]
    mem[base + 1]   = bs[1]

# Call the tape reading function.
chksum = tb.read_tape(fp, writer)

# Print checksum result.
print("Checksum Diff = {}".format(chksum))

# Write memory to file.
with open(sys.argv[2], "wb") as out:
    out.write(mem)
