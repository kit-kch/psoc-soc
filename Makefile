####################################################################################################
# Configuration
####################################################################################################
SIMULATION_SETS = i2s_master \
    sine_generator

####################################################################################################
# Generated variables
####################################################################################################
SIM_SETS=$(addsuffix .sim,$(SIMULATION_SETS))

####################################################################################################
# Tool Commands
####################################################################################################
VIVADO=$(abspath ./prj/vivado.sh)

####################################################################################################
# Abbreviations
####################################################################################################
XPR_FILE=build/psoc/psoc.xpr

####################################################################################################
# Rules
####################################################################################################
.PHONY: all sim bitstream project ui standalone.bit soc.bit clean

# High-level wrapper targets
all: sim bitstream
sim: $(SIM_SETS)
bitstream: standalone.bit soc.bit

clean:
	rm -rvf build

# Project and UI
project: $(XPR_FILE)
$(XPR_FILE): prj/gen_prj.tcl
	rm -rvf build
	mkdir -p build
	cd build && $(VIVADO) -mode batch -source ../prj/gen_prj.tcl

ui: $(XPR_FILE)
	cd build && $(VIVADO) ../$(XPR_FILE)

# Bitstreams
standalone.bit: out/standalone.bit
out/standalone.bit: $(XPR_FILE)
	echo "Not implemented"

soc.bit: out/soc.bit
out/soc.bit:
	echo "Not implemented"

# Simulation
%.sim:
	echo "Not implemented"