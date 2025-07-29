#!/bin/bash
set -e

DRC_DIR=$FLOW_HOME/platforms/ihp-sg13g2/drc
RESULT_DIR=$FLOW_HOME/results/ihp-sg13g2/soc_top/base

klayout -n sg13g2 -zz -r $DRC_DIR/sg13g2_maximal.lydrc -rd "in_gds=$RESULT_DIR/7_filled.gds" -rd "log_file=$RESULT_DIR/drc_sg13g2_maximal.log" -rd "report_file=$RESULT_DIR/drc_sg13g2_maximal.lyrdb"