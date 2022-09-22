[![pipeline status](https://gitlab.itiv.kit.edu/psoc/psoc_fpga/badges/master/pipeline.svg)](https://gitlab.itiv.kit.edu/psoc/psoc_fpga/commits/master)

# Using the repository

## The Vivado project

```bash
# To generate the project
make project

# To update the tcl file from the current project state
make tcl

# To open the gui
make ui

# Generate all bistreams
make bitstream

# Or just some
make standalone.bit
make soc.bit

# Run all simulations
make sim

# Or just some
make i2s_master.sim
make sine_generator.sim

# Run simulations and generate bitstreams
make
# or, alternatively
make all

# To remove all vivado build files
make clean
```

## Cadence

```bash

# Behavorial simulation
make thermometer_encoder.xrun

# Same, but open the GUI:
make GUI=1 thermometer_encoder.xrun

# Synthesize
make thermometer_encoder.genus

# Simulate the synthesized design (must run make thermometer_encoder.genus before!)
make thermometer_encoder.xrun2

# Same, but open the GUI:
make GUI=1 thermometer_encoder.xrun2

# Implement the design (must run make encoder_top.genus before!)
make encoder_top.innovus

# Simulate the implemented design (must run make encoder_top.innovus before!)
make encoder_top.xrun3

# Same, but open the GUI:
make GUI=1 encoder_top.xrun3
```