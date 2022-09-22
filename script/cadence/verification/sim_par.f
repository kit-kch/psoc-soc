
## Digital Sources
## This is now the result of placen adn route placed in neighbor synthesis folder
## We also need to add the models for the logic cells now

## Synthesized design
../${SIM_NAME}.innovus/stream_out/netlist.simulation.nonFlat.v

## Logic cells
$BASE/script/cadence/common/ams_h18/ah18_CORELIB_HV.v

## Test Bench
## This stays the same
../../src/sim/tb_${SIM_NAME}.v

-access +rwc
-timescale 1ns/1ps