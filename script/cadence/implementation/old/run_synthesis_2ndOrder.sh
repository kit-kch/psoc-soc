#!/bin/bash

#GUI=-gui

source /opt/eda/environment/edi110_path.bash
source /opt/eda/environment/rc121_path.bash
rc ${GUI} -f ./scripts/synthesize_2ndOrder.tcl

