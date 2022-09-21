#!/bin/bash
#UI=-gui

#source /opt/eda/environment/rc_latest_path.bash
source /opt/eda/environment/rc121_path.bash
rc ${GUI} -f ./scripts/synthesize_1stOrder.tcl
#reset
