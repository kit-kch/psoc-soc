# See https://docs.cocotb.org/en/stable/quickstart.html for more info
SIM ?= xcelium
include common.mak

EXTRA_ARGS += -access +rwc
EXTRA_ARGS += +dumpvars
EXTRA_ARGS += -sv
ifneq ($(GATES),yes)
# If we don't do gate-level, we don't have hold times and hold checks in the RAM simulation fail...
EXTRA_ARGS += +notimingcheck
else
# But even in GL test, this does not work?
EXTRA_ARGS += +notimingcheck
endif

include $(shell cocotb-config --makefiles)/Makefile.sim