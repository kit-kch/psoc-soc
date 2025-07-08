# See https://docs.cocotb.org/en/stable/quickstart.html for more info
SIM ?= icarus
WAVES = 1
include common/common.mak

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim