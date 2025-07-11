[![pipeline status](https://gitlab.itiv.kit.edu/psoc/psoc_fpga/badges/master/pipeline.svg)](https://gitlab.itiv.kit.edu/psoc/psoc_fpga/commits/master)

# Using the repository

## The Vivado project

For FPGA development, you will need these commands:

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

For Cadence work, use these commands:

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

## IHP SG13G2 Tapeout

To synthesize the design for IHPs [SG13G2 Open PDK](https://github.com/IHP-GmbH/IHP-Open-PDK), follow these instructions:


First set up the [IIC-OSIC-TOOLS](https://github.com/iic-jku/iic-osic-tools) or a similar ORFS toolchain.
One easy way to set this up is using [distrobox](https://distrobox.it), but any setup should work.
We currently use version `iic-osic-tools:2025.05`, so use this one to be sure everything is working.

After setting up the container, you will have to check out a matching ORFS version first:
```bash
git clone --quiet --filter=blob:none https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git orfs
cd orfs
git checkout $(cat $TOOLS/openroad-latest/ORFS_COMMIT)
```

Note that the ORFS version we test against is also saved in `ORFS_COMMIT` in this repository.

Then open a terminal in the container, make sure this git repository is checked out and you're in the main folder.
We then need to set some variables for the flow:

```bash
export YOSYS_EXE=$TOOLS/yosys/bin/yosys
export OPENROAD_EXE=$TOOLS/openroad-latest/bin/openroad
export OPENSTA_EXE=$TOOLS/openroad-latest/bin/sta
export FLOW_HOME=/home/nq5949/Dokumente/oseda/orfs/flow
```

`FLOW_HOME` needs to point to the `orfs/flow` folder you checked out from git.

You can then use the normal psoc Makefile:
```bash
# Compile NEORV32 VHDL to Verilog (src/hdl/sg13g2/neorv32_wrap.v)
make sg13g2_wrap

# Do the actual RTL2GDS flow
make sg13g2

# View the results in the GUI
make sg13g2_ui
```

For simulation instructiond for the SG13G2 ASIC, see [src/sim/sg13g2/README.md](src/sim/sg13g2/README.md).