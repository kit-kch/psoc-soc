#!/bin/bash

# Only export path if gcc is not already available
if ! [ -x "$(command -v virtuoso)" ]; then
    ## This script will load the AMS H18 Technology design kit as well as the required software tools from Cadence:
    ## - XCELIUM for digital simulation
    ## - Genus/Innovus for Synthesis and Place and Route
    ## - Virtuoso/Spectre for analog simulation and layout if necessary
    source /tools/psoc/psoc.sh cadence

    ## This Environment variable saves the current folder path
    ##  Subsequent scripts and configuration files can reference file paths using $BASE so that scripts are independent from the current user
    export BASE="$(realpath $(dirname "$(readlink -f ${BASH_SOURCE[0]})")/../../)"

fi

# Allow sourcing this script without params. Otherwise exec command
if [ $# -ne 0 ]; then
    exec "$@"
fi
