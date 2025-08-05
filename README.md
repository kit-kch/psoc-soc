[![Pipeline Status](https://gitlab.itiv.kit.edu/psoc-admin/psoc-soc-ci/badges/main/pipeline.svg)](https://gitlab.itiv.kit.edu/psoc-admin/psoc-soc-ci/-/commits/main)

# KIT PSoC Lab RISC-V Reference SoC

## External Repositories

We include some external repositories in the [ext](ext) folder as submodules, so make sure to clone with the `--recursive` flag.
Currently we include the following repositories:

### NEORV32 Fork

`neorv32` contains [our fork](https://github.com/kit-kch/psoc-neorv32) of the [NEORV32](https://github.com/stnolting/neorv32) SoC.

Please note that we have frozen our NEORV32 version, whereas the upstream version is constantly being updated.
Due to this, the documentation on the official website might not match the code used here.
Please refer to [our fork site](https://github.com/kit-kch/psoc-neorv32) and the generated documentation instead:
* [Datasheet](https://kit-kch.github.io/psoc-neorv32/)
* [User Guide](https://kit-kch.github.io/psoc-neorv32/ug/)
* [API Reference](https://kit-kch.github.io/psoc-neorv32/sw/)

### XIP Bootloader

`psoc-xip-bootloader` contains our [custom bootloader](https://github.com/kit-kch/psoc-xip-bootloader) to boot from external SPI flash.

## Tools, Compilers, etc

### Compiler and GDB

At ITIV, we just use the compiler installed in `/tools/riscv/riscv-none-elf-gcc-xpack/xpack-riscv-none-elf-gcc-14.2.0-3/` which is set up by the `psoc.sh` script:
```bash
source /tools/psoc/psoc.sh riscv
```

Outside of ITIV, you need to set up the [xPack GNU RISC-V Embedded GCC v14.2.0-3](https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases/tag/v14.2.0-3) toolchain by yourself.

### OpenOCD

As our `JTAGSPI` support has currently not been upstreamed, you need our custom [OpenOCD fork](https://github.com/kit-kch/psoc-openocd).
For ITIV PSoC students, this fork is installed in `/tools/riscv/openocd/2025.07.25_0.12.0+bd577aad8a` and set up by soureing `psoc.sh`:
```bash
source /tools/psoc/psoc.sh riscv
```

Outside of ITIV, you need to compile OpenOCD by yourself:
```bash
# In empty rocky 8 container, first install libraries
dnf config-manager --set-enabled powertools
dnf groupinstall "Development Tools"
dnf install jimtcl-devel libftdi-devel

# Now build
git clone https://github.com/kit-kch/psoc-openocd.git openocd
cd openocd
git checkout neorv
./bootstrap
./configure --prefix=/
make -j24
make DESTDIR=/tools/psoc/openocd/2025.07.25_0.12.0+bd577aad8a install
```

### Bootloader

Refer to the [psoc-xip-bootloader](https://github.com/kit-kch/psoc-xip-bootloader) instructions.

### Vivado

Vivado is used for FPGA synthesis and some behavorial simulations.
At ITIV, [vivado_env.sh](script/vivado/vivado_env.sh) uses `module load xilinx/2024.1` in case Vivado was not set up previously.
You can however also use the `psoc.sh` script to do this explicitly:
```bash
source /tools/psoc/psoc.sh vivado
```

If you're not at ITIV, you will have to install Vivado 2024.1 and make sure it's in `$PATH`.

### OpenRoad / ORFS

We use OpenRoad and ORFS to synthesize the ASIC for the SG13G2 Open PDK target.
The OpenRoad synthesis flow at ITIV is meant to be run in the [IIC-OSIC-TOOLS](https://github.com/iic-jku/IIC-OSIC-TOOLS) container, version `2025.05`.
The CI will automatically run in that container.
When running locally you can use [distrobox](https://distrobox.it):

```bash
# Create distrobox
distrobox create -i docker.io/hpretl/iic-osic-tools:2025.05 asic

# Make sure we see the tools
distrobox enter asic
sudo ln -s /headless/.bashrc /etc/profile.d/z99_iic_osic_env.sh
chsh -s /bin/bash
exit

# Login again and run tools
distrobox enter asic
```

ORFS is not shipped with `IIC-OSIC-TOOLS`, but the [setup_orfs.sh](script/sg13g2/setup_orfs.sh) script will automatically clone the correct version from git.

### Cocotb

Cocotb is used to simulate the whole SoC for the ASIC SG13G2 target.
The [setup_cocotb.sh](script/sg13g2/setup_cocotb.sh) script automatically sets up a venv with the correct version of cocotb and required libraries.
You just need to have a recent enough python with venv support.

### QuestaSim

Cocotb is used as a backend for cocotb for the ASIC simulations.
At ITIV, [questa_env.sh](script/sg13g2/questa_env.sh) uses `module load questa/2023.4` in case QuestaSim was not set up previously.
If you're not at ITIV, you will have to install QuestaSim 2023.4 and make sure it's in `$PATH`.

### Other Simulators

The ASIC simulation in [src/sim/sg13g2](src/sim/sg13g2/) provides support for other simulators.
For example, you can also use Verilator or Icarus Verilog, which are shippped with the IIC-OSIC-TOOLS container.

## Running Firmware

To run firmware on the ASIC or FPGA, there are two main points to remember:

### Compilling Code Accordingly

We are using the execute-in-place (XIP) peripheral.
This means the entry point of your code needs to be mapped to the XIP base address `0xE0000000`.
With the neorv linker script, this can be achieved by defining `__neorv32_rom_base` accordingly.
All our reference code includes `psoc_lib.mk` from the [psoc-sw-lib](https://github.com/kit-kch/psoc-sw-lib) repository.
Apart from providing low-level drivers for our custom hardware components, this makefile also sets `__neorv32_rom_base`.

### Programming the SPI Flash

The software needs to be programmed to the SPI flash, but our [psoc-fmc-board](https://gitlab.itiv.kit.edu/psoc-admin/psoc_board/-/tree/master/doc?ref_type=heads) does not provide any option to program it externally.
To program it from the FPGA or ASIC, you could use the extended [psoc-xip-bootloader](https://github.com/kit-kch/psoc-xip-bootloader).
However, to reduce ROM size, our default design only includes the tiny bootloader, which does not support programming.

As an alternative that's more convenient anyway, we implemented [JTAGSPI](https://www.jpfau.org/blog/implementing-jtagspi-tap/) in [our fork](https://github.com/kit-kch/psoc-neorv32/tree/jtagspi2) of the NEORV32 debug core.
JTAGSPI allows to programm the SPI flash using JTAG, which we include for debugging anyway.
Unfortunately, you currently also need our custom [OpenOCD fork](https://github.com/kit-kch/psoc-openocd) to make use of this feature. 

Once you have the software stack installed, programming is quite convenient.

* First connect the JTAG adapter according to the [Signal Mapping](doc/Signal%20mapping.md) file.

* Then start OpenOCD with the [script/openocd_neorv32_jtaghs2.cfg](script/openocd_neorv32_jtaghs2.cfg) file from this repo:
  ```bash
  openocd -f ./script/openocd_neorv32_jtaghs2.cfg
  # Alternatively, to select an adapter with a specific ID
  openocd -c 'adapter serial 210249B1B925' -f ./script/openocd_neorv32_jtaghs2.cfg
  ```
* Finally, connect using gdb, load the program and run:
  ```bash
  riscv-none-elf-gdb
  target extended-remote localhost:3333
  file main.elf
  load
  # Example how to set a breakpoint
  break main
  j *(0xFFE00000)
  ```

The nice thing here is that GDB knows that the memory region at `0xE0000000` provided by the XIP peripheral is read-only.
It therefore automatically uses the OpenOCD flash feature, which uses JTAGSPI to program the flash.
In addition, it now automatically uses HW breakpoints for this region, as SW breakpoints only work in writable memory.
Note that there's only one hardware breakpoint, so you can't have multiple breakpoints in GDB.

To reset the application without confusing the debugger, the best way is to just jump to the code entrypoint.
For some reason, jumping to the main application does usually not work.
Jumping to the bootloader entrypoint as shown above however works fine.

Hint: If you want to tunnel the OpenOCD connection, you can do so like this:
```bash
ssh -R 33340:localhost:3333 nq5949@work3.itiv.kit.edu
```

## Implementing the Hardware Design

### The Vivado project

For FPGA development on the Zedboard, you will need these commands:

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

### IHP SG13G2 Tapeout

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

# Make the sealring GDS (script/sg13g2/sealring.gds)
make sg13g2_sealring

# Do the actual RTL2GDS flow
make sg13g2

# View the results in the GUI
make sg13g2_ui

# Do final fills
make sg13g2_fill

# Run quick DRC
make sg13g2_drc

# Run full DRC
make sg13g2_ui
```

To view the final results in klayout, open `7_filled.gds` in the results directory:

```bash
klayout $FLOW_HOME/results/ihp-sg13g2/soc_top/base/7_filled.gds

# To view the DRC results:
klayout  $FLOW_HOME/results/ihp-sg13g2/soc_top/base/7_filled.gds -m $FLOW_HOME/results/ihp-sg13g2/soc_top/base/8_drc_sg13g2_minimal.lyrdb
klayout  $FLOW_HOME/results/ihp-sg13g2/soc_top/base/7_filled.gds -m $FLOW_HOME/results/ihp-sg13g2/soc_top/base/8_drc_sg13g2_maximal.lyrdb
```

For simulation instructions for the SG13G2 ASIC, see [src/sim/sg13g2/README.md](src/sim/sg13g2/README.md).