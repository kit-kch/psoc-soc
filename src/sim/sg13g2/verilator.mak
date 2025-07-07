# Makefile
# See https://docs.cocotb.org/en/stable/quickstart.html for more info

include common.mak
SIM ?= verilator

ifeq ($(GATES),yes)
# Gate level simulation:
# OpenROAD creates dummy load cells, that don't have their outputs connected
COMPILE_ARGS += -Wno-PINMISSING
endif

# NEORV32 generates a lot of these
COMPILE_ARGS += -Wno-UNOPTFLAT

# Enable waveform output
EXTRA_ARGS += --trace --trace-fst --trace-structs

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim