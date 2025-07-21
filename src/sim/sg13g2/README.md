# IHP SG13G2 ASIC Tests

## Installing Dependencies

In order to run the tests, you need to install some dependency libraries.
Create a python venv like this:
```bash
mkdir -p .build
python3 -m venv .build/.env
source .build/.env/bin/activate
pip install -r common/requirements.txt
```

## Simulator Setup

Make sure your desired simulator is set up properly. Here are some tips for the setup at ITIV:

* Verilator: Use DistroBox with IIC-OSIC-TOOLS container, should work out of the box
* Icarus Verilog: Use DistroBox with IIC-OSIC-TOOLS container.
  Have to execute `export LD_LIBRARY_PATH=/foss/tools/iverilog/lib` before.
* Questa: Make sure to have questa in your path and licenses set up properly.
  At ITIV:
  ```bash
  source /etc/profile.d/modules.sh
  module load questa/2023.4
  ```
* Xcelium: Make sure to have questa in your path and licenses set up properly.
  At ITIV:
  ```bash
  source /etc/profile.d/modules.sh
  module load cadence/xceliummain/24.03.004
  ```

## Running Behavorial Tests

After setting up your simulator, we need to set up access to the IHP PDK.
The simulation will need to load some simulation models from there.

To set up, simply export `FLOW_HOME` to point to your [ORFS](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts) installation:
```bash
export FLOW_HOME=/home/nq5949/Dokumente/oseda/orfs/flow/
```

Then simply run the desired Makefile:
```bash
make -f icarus.mak
make -f questa.mak
make -f verilator.mak -j40
make -f xcelium.mak
```
Note that you can speed up compilation for Verilator using `-j`.

## Running Gate-Level Tests

To run gate level tests, simply run the Makefile with `GATES=yes`.
For this to work, you must have first synthesized your design in ORFS, as the Gate-Level Test will load the synthesized netlist.
```bash
make GATES=yes -f icarus.mak
make GATES=yes -f questa.mak
make GATES=yes -f verilator.mak -j40
make GATES=yes -f xcelium.mak
```

## Running a Single Test

Note that you can also run a single test instead of running them all.
For example, for the `test_blink_led` test do:
```bash
make TESTCASE=test_blink_led -f icarus.mak
make TESTCASE=test_blink_led -f questa.mak
make TESTCASE=test_blink_led -f verilator.mak -j40
make TESTCASE=test_blink_led -f xcelium.mak
```

## Rebuilding Test Firmware

The firmware used in the tests is stored in the `firmware.raw_exe.bin` file in each test folder.
The source code is available in the `firmware` subfolder.
To recompile the application, simply run this command:
```bash
make clean_all
make bin
```
and copy the resulting `raw_exe.bin` file to `firmware.raw_exe.bin`.