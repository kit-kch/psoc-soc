#!/bin/bash

# The filesets to be simulated
SETS="i2s_master_tests spi_master_tests adau_command_list_tests sine_generator_tests cpu_ram_tests cpu_bus_logic_tests"

source /tools/xilinx/set_xilinx2018.2.sh
set -x

vivado -mode batch -source "ci/gen_sim_scripts.tcl" || exit 1

sim() {
    echo "========== simulating $1 =========="
    cd psoc_fpga/psoc_fpga.sim/$1/behav/xsim
    ./compile.sh || return
    ./elaborate.sh || return
    ./simulate.sh
    # Grepping the log files is not pretty, but xsim does not seem to offer any other solution.
    grep -q '^Error:' simulate.log && return 1
    grep -q 'Timing violation in scope' simulate.log && return 1
    return 0
}


FAILS=

for s in $SETS; do
    pushd .
    sim $s || FAILS="$s $FAILS"
    popd
done

if [ -n "$FAILS" ]; then
	echo "failing tests: $FAILS"
	exit 1
fi

