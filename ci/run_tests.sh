#!/bin/bash

# The fileset to be simulated

SET=$1
OUTDIR=$PWD/out/

source /tools/xilinx/set_xilinx2018.2.sh
set -x

vivado -mode batch -source "ci/gen_sim_scripts.tcl" || exit 1


echo "========== simulating $SET =========="
pushd psoc_fpga.sim/$SET/behav/xsim
    ./compile.sh || exit 1
    ./elaborate.sh || exit 1
    ./simulate.sh
    # Grepping the log files is not pretty, but xsim does not seem to offer any other solution.
    if grep -q 'Test OK' simulate.log; then
        popd
        echo "Simulation successful"
        exit 0
    fi
    mkdir -p $OUTDIR
    cp -v simulate.log $OUTDIR
popd
echo "Simulation failed"
exit 1
