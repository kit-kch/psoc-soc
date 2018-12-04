#!/bin/bash

source /tools/xilinx/set_xilinx2018.2.sh

TOP_MODULE=$1
shift
SOURCE_FILES=$@
SOURCE_PATHS=`for f in $SOURCE_FILES; do echo -n "../src/hdl/$f "; done`

set -x
mkdir run-tests
cd run-tests

echo "========== COMPILING VERILOG SOURCES =========="
xvlog ../src/hdl/*.v || (echo 'Compilation failed'; exit 1)

TESTBENCHES="adau_spi_master_tb tb_i2s_master tb_adau_command_list"

EC=0
PASSING=""
FAILING=""

fail() {
    EC=1
    FAILING="$FAILING $tb"
    continue
}

for tb in $TESTBENCHES; do
    echo "========== Running testbench: $tb =========="
    xelab -debug typical $tb -s $tb || fail

    xsim -R -onerror quit $tb
    # There ought to be a better way to detect whether Verilog code has
    # called $error than to grep the logs, but right now I can't find it.
    grep -s '^Error:' xsim.log && fail

    PASSING="$PASSING $tb"
done

echo "Passing testbenches: $PASSING"
echo "Failing techbenches: $FAILING"

exit $EC
