#digital source files


## Main Hardware RTL files
####
$BASE/src/hdl/binary_counter.v
$BASE/src/hdl/thermometer_encoder.v
$BASE/src/hdl/encoder_top.v

## Simulation testbench
#####
$BASE/src/sim/tb_thermometer_encoder.v

## Simulator arguments
#########
-access +rwc 
-timescale 1ns/1ps
-gui