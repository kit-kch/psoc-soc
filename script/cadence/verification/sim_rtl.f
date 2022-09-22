
# RTL Files
########
-f ../../src/hdl/${SIM_NAME}.f

# Testbench Files
########
../../src/sim/tb_${SIM_NAME}.v

## Simulator Arguments
#############
-access +rwc
-timescale 1ns/1ps