# See https://docs.cocotb.org/en/stable/quickstart.html for more info
SIM ?= questa
include common.mak

ifneq ($(GATES),yes)
# If we don't do gate-level, we don't have hold times and hold checks in the RAM simulation fail...
EXTRA_ARGS += +notimingchecks
else
# But even in GL test, this does not work?
EXTRA_ARGS += +notimingchecks
endif


include $(shell cocotb-config --makefiles)/Makefile.sim