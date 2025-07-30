#!/bin/bash
set -e

PDKPATH=/foss/pdks/ihp-sg13g2
DRC_DIR=$PDKPATH/libs.tech/klayout/tech/drc
RESULT_DIR=$FLOW_HOME/results/ihp-sg13g2/soc_top/base

klayout -n sg13g2 -zz -r $DRC_DIR/sg13g2_minimal.lydrc -rd "in_gds=$RESULT_DIR/7_filled.gds" -rd "log_file=$RESULT_DIR/8_drc_sg13g2_minimal.2.log" -rd "report_file=$RESULT_DIR/8_drc_sg13g2_minimal.lyrdb"  | tee $RESULT_DIR/8_drc_sg13g2_minimal.log

# Check that there are 0 violations
cat $RESULT_DIR/8_drc_sg13g2_maximal.log | grep -q "Number of DRC errors: 0"
exit $?