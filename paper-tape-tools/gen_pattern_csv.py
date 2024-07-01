import sys

if(len(sys.argv) != 4):
    print("Missing args!")
    exit(1)

# Parse start addr, end addr, and pattern.
start   = int(sys.argv[1], 8)
end     = int(sys.argv[2], 8)
pattern = sys.argv[3]

# Generate csv.
for i in range(start, end+1):
    print("{},{}".format(oct(i)[2:], pattern))
