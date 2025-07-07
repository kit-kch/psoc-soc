# See https://docs.cocotb.org/en/stable/quickstart.html for more info
SIM ?= xcelium
include common.mak

EXTRA_ARGS += -access +rwc
EXTRA_ARGS += +dumpvars

include $(shell cocotb-config --makefiles)/Makefile.sim