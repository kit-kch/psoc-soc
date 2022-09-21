#digital source files


## Main Hardware RTL files
####
$BASE/source_code/hdl/binary_counter.v
$BASE/source_code/hdl/thermometer_encoder.v
$BASE/source_code/hdl/encoder_top.v

## Simulation testbench
#####
$BASE/verification/encoder_sim.v

## Simulator arguments
#########
-access +rwc 
-timescale 1ns/1ps
-gui