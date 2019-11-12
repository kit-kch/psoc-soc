#!/usr/bin/env python3
import math

bit_depth = 24
f  = 523
fs = 48000
ampl_max = 2 ** (bit_depth - 1) - 1

# Format python number as 2's complement hex value
def tohex(val, nbits):
    assert (val >= -(2**(nbits - 1)))
    assert (val <= (2**(nbits - 1) - 1))
    hexdigits = math.ceil(nbits / 4)
    entry_format = "{:0" + str(hexdigits) + "x}"
    return entry_format.format((val + (1 << nbits)) % (1 << nbits))


# To ensure that we can build or sine out of quarter-sines,
# each quarter has to be identical expect for mirroring.
# To satisfy this, T / Ts = 2 + 2x must hold.
# ==> T = (2 + 2x) * Ts
# ==> x = ((T / Ts) - 2) / 2
x = int(((fs / f) - 2) / 2);
steps = (2 + 2*x)
f = fs / steps

print("Real frequency is", f, "Hz at", steps, "steps")
print("")

print("@00000000")

# Calculate 1/4 of a sine
peakVal = steps % 4 == 0
basesteps = math.floor(steps/4)
base = []
for n in range(basesteps + 1):
    x = 2 * math.pi * n / (steps)
    y = math.sin(x)
    y_i = int(y * ampl_max)
    base.append(y_i)


# Now mirror. Two cases: Value on peak or not.
ibase = list(map(lambda x: -x, base))

sin_lut = []
if peakVal:
    sin_lut.extend(base)
    sin_lut.extend(list(reversed(base))[1::])
    sin_lut.extend(ibase[1:])
    sin_lut.extend(list(reversed(ibase))[1:-1])
else:
    sin_lut.extend(base)
    sin_lut.extend(list(reversed(base)))
    sin_lut.extend(ibase[1:])
    sin_lut.extend(list(reversed(ibase))[:-1])

for n in range(steps):
    print(tohex(sin_lut[n], bit_depth), end=" ")

print("")
print("")
print("Generated table with", steps, "entries")
