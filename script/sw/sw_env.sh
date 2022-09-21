#!/bin/bash

# Only export path if gcc is not already available
if ! [ -x "$(command -v riscv32-unknown-elf-gcc)" ]; then
    export PATH=$PATH:/tools/riscv/rv32i-ilp32-gcc/2022.08.26_12.1.0/bin
fi

# Only export path if openocd is not already available
if ! [ -x "$(command -v openocd)" ]; then
    export PATH=$PATH:/tools/psoc/openocd/bin
fi

# Allow sourcing this script without params. Otherwise exec command
if [ $# -ne 0 ]; then
    exec "$@"
fi
