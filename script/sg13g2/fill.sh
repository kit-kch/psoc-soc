#!/bin/bash
set -e

# Need files from full PDK, not shipped in ORFS
PDKPATH=/foss/pdks/ihp-sg13g2

klayout -n sg13g2 -zz -r $PDKPATH/libs.tech/klayout/tech/scripts/filler.py -rd "output_file=$FLOW_HOME/results/ihp-sg13g2/soc_top/base/7_filled.gds" $FLOW_HOME/results/ihp-sg13g2/soc_top/base/6_1_merged.gds