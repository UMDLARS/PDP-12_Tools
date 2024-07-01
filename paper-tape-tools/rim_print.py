import sys
from lib import tape_rim as tr

# Open rim file.
fp = open(sys.argv[1], "rb")

# This function will be called by tr.read_tape for each entry in the rim tape.
def writer(addr, data):
    print("{}\t{}".format(oct(addr), oct(data)))

# Call the tape reading function.
tr.read_tape(fp, writer)
