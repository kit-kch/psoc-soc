#!/bin/bash

# Only source vivado if this was not done before
if ! [ -x "$(command -v vivado)" ]; then
    source /tools/xilinx/set_xilinx2022.1.sh &>/dev/null
fi

# Allow sourcing this script without params. Otherwise exec command
if [ $# -ne 0 ]; then
    exec "$@"
fi