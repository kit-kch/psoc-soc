#!/bin/bash

echo "Setting up licenses"
source ./ci/itiv-setup.sh
mkdir -p out
set -ex

COMMAND=$1
case "$COMMAND" in
      implement_standalone)
          echo "Testing standalone implementation"
          vivado -mode batch -source "ci/fpga_standalone.tcl" -nojournal -log "fpga_standalone.log"
          cp -v psoc_fpga/psoc_fpga.runs/impl_1/fpga_standalone_top.bit out/
          ;;
      implement_soc)
          echo "Testing SOC implementation"
          vivado -mode batch -source "ci/fpga_soc.tcl" -nojournal -log "fpga_soc.log"
          cp -v psoc_fpga/psoc_fpga.runs/impl_1/fpga_rsicv_top.bit out/
          ;;
      *)
          printf "Unknown command: '%s'\n\n" "$COMMAND" >&2
          exit 1;
          ;;
esac
