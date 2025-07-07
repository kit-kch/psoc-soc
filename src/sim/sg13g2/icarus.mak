# Makefile
# See https://docs.cocotb.org/en/stable/quickstart.html for more info

include common.mak
SIM ?= icarus
WAVES = 1

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim