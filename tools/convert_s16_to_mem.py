#!/usr/bin/env python3
import struct
import sys
import math
from functools import partial

# Format python number as 2's complement hex value
def tohex(val, nbits):
    assert (val >= -(2**(nbits - 1)))
    assert (val <= (2**(nbits - 1) - 1))
    hexdigits = math.ceil(nbits / 4)
    entry_format = "{:0" + str(hexdigits) + "x}"
    return entry_format.format((val + (1 << nbits)) % (1 << nbits))

fileName = sys.argv[1]

print("@00000000")
i = 0
with open(fileName, mode='rb') as file: 
    for chunk in iter(partial(file.read, 2), b''):
        i = i + 1
        value = struct.unpack("<h", chunk)[0]
        print(tohex(value, 24), end=" ")

print("")
print("")
print("Wrote ", i, "values")
