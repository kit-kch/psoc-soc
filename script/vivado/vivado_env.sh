#!/bin/bash

# Only source vivado if this was not done before
if ! [ -x "$(command -v vivado)" ]; then
    module load xilinx/2024.1
fi

# Allow sourcing this script without params. Otherwise exec command
if [ $# -ne 0 ]; then
    exec "$@"
fi