#!/bin/bash

source /tools/xilinx/set_xilinx2020.2.sh
mkdir -p out
set -ex

COMMAND=$1
case "$COMMAND" in
    implement_standalone)
        echo "Testing standalone implementation"
        vivado -mode batch -source "ci/fpga_standalone.tcl" -nojournal -log "fpga_standalone.log"
        cp -v psoc_fpga.runs/impl_1/fpga_standalone_top.bit out/
        cp -v psoc_fpga.runs/impl_1/fpga_standalone_top_timing_summary_routed.rpt out/
        cp -v psoc_fpga.runs/impl_1/fpga_standalone_top_utilization_placed.rpt out/
        cp -v psoc_fpga.runs/synth_1/runme.log out/synthesis.log
        cp -v psoc_fpga.runs/impl_1/runme.log out/implementation.log
        ;;
    implement_soc)
        echo "Testing SOC implementation"
        vivado -mode batch -source "ci/fpga_soc.tcl" -nojournal -log "fpga_soc.log"
        cp -v psoc_fpga.runs/impl_1/fpga_riscv_top.bit out/
        cp -v psoc_fpga.runs/impl_1/fpga_riscv_top_timing_summary_routed.rpt out/
        cp -v psoc_fpga.runs/impl_1/fpga_riscv_top_utilization_placed.rpt out/
        cp -v psoc_fpga.runs/synth_1/runme.log out/synthesis.log
        cp -v psoc_fpga.runs/impl_1/runme.log out/implementation.log
        ;;
    *)
        printf "Unknown command: '%s'\n\n" "$COMMAND" >&2
        exit 1;
        ;;
esac
