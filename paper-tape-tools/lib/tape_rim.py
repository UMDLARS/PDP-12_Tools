import struct
from . import tape_common

def encode_addr_and_data(addr, data):
    addr_b1 = ((addr >> 6) & 0o77) | (1 << 6)
    addr_b2 = addr & 0o77

    data_b1 = (data >> 6) & 0o77
    data_b2 = data & 0o77

    return struct.pack("BBBB", addr_b1, addr_b2, data_b1, data_b2)

def read_tape(tape_fp, func):
    done = False
    prev = 0
    while(not done):
        # Read first byte.
        b = tape_fp.read(1)
        if(b == b''):
            done = True
            continue
        new = int.from_bytes(b)

        # Check if this is a leader.
        if(new == tape_common.LEADER):
            continue

        # Shift byte over.
        new <<= 6

        # Read second byte
        b = tape_fp.read(1)
        if(b == b''):
            done = True
            continue
        new |= int.from_bytes(b)

        # Check if this is an address, if not write value to address in prev.
        if(new >> 12 == 0):
            # Call user function.
            func(prev, new)

            # Clear value.
            new = 0

        # Save new to prev.
        prev = new & 0o7777
