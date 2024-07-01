import csv
import struct
import sys
from lib import tape_rim as tr
from lib import tape_common as tc

if(len(sys.argv) != 3):
    print("Missing args!")
    print("{} csv rim".format(sys.argv[0]))
    exit(1)

# Open csv file.
rim = bytes()
with open(sys.argv[1], "r") as csv_file:
    csv_reader = csv.reader(csv_file)
    for row in csv_reader:
        # Ignore empty lines.
        if(len(row) == 0):
            continue

        # Add leader byte if this row contains "LEAD"
        if(row[0] == "LEAD"):
            rim += tc.LEADER
            continue

        # Encode address and data.
        addr = int(row[0], 8)
        data = int(row[1], 8)
        rim += tr.encode_addr_and_data(addr, data)

# Dump rim data to a file.
with open(sys.argv[2], "wb") as rim_file:
    rim_file.write(rim)
