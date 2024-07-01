import sys
from lib import tape_bin as tb

# Open bin file.
fp = open(sys.argv[1], "rb")

# This function will be called by tb.read_tape for each value in the bin tape.
def writer(field, addr, data):
    print("{}:{}\t{}".format(field, oct(addr), oct(data)))

# Call the tape reading function.
chksum = tb.read_tape(fp, writer)

# Print checksum result.
print("Checksum Diff = {}".format(chksum))
