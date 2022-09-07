#!/usr/bin/env python3
import struct
import sys
import math
from functools import partial
import os

# Format python number as 2's complement hex value
def tohex(val, nbits):
    assert (val >= -(2**(nbits - 1)))
    assert (val <= (2**(nbits - 1) - 1))
    hexdigits = math.ceil(nbits / 4)
    entry_format = "0x{:0" + str(hexdigits) + "x}"
    return entry_format.format((val + (1 << nbits)) % (1 << nbits))

fileName = sys.argv[1]

i = 0
with open(fileName, mode='rb') as file:
    entries = int(os.stat(fileName).st_size / 2)
    print("#include \"audio_buf.h\"")
    print()
    print("const size_t audio_buf_len = {};".format(entries))
    print("int32_t audio_buf[{}] = {{ ".format(entries))
    print("    ", end="")
    for chunk in iter(partial(file.read, 2), b''):
        i = i + 1
        value = struct.unpack("<h", chunk)[0]
        if i == entries:
            print(tohex(value, 24), "};")
        else:
            print(tohex(value, 24), end=", ")
            if i % 6 == 0:
                print("")
                print("    ", end="")