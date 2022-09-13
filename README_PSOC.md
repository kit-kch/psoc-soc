# Using Various Tools

## Vivado

Refer to [README.md](README.md).

## Logic Analyzer

```bash
source /tools/psoc/psoc.sh logic
Logic&
```

## OpenOCD

* Connect GND and VDD to 3.3V
* FMC does not seem to be working
* Connect to PMODS: TCK (JB4), TDO (JB3), TDI(JB2), TMS(JB1)

```bash
/tools/psoc/openocd/bin/openocd -f ./sw/openocd/openocd_neorv32_jtaghs2.cfg
```

Then start gdb:
```bash
riscv32-unknown-elf-gdb
```

Then use gdb commands:
```
target extended-remote localhost:3333
```

To load a new program:
```
file main.elf
load
continue
```

Alternatively, `run` starts the bootloader.

To use breakpoints (have to use HW breakpoints when using flash):
```
hbreak *0x20000000
# To delete
del 1
```

Some useful commands:
```
# Print next instruction
set disassemble-next-line on
# step instruction
stepi
```