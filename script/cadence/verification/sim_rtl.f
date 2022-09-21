
# RTL Files
# Reference the encounter_top.f netlist file
########
-f $BASE/src/hdl/encoder_top.f


# Testbench Files
########
$BASE/src/sim/tb_thermometer_encoder.v


## Simulator Arguments
#############
-access +rwc
-timescale 1ns/1ps