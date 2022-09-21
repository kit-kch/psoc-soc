
# RTL Files
# Reference the encounter_top.f netlist file
########
-f $BASE/rtl/encoder_top.f


# Testbench Files
########
$BASE/verification/encoder_sim.v


## Simulator Arguments
#############
-access +rwc 
-timescale 1ns/1ps




