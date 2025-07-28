# See https://docs.cocotb.org/en/stable/quickstart.html for more info
SIM ?= questa
# Uncomment to dump waveform to vsim.wlf. View with vsimk vsim.wlf
#WAVES=1
include common/common.mak

ifneq ($(GATES),yes)
# If we don't do gate-level, we don't have hold times and hold checks in the RAM simulation fail...
EXTRA_ARGS += +notimingchecks
else
# But even in GL test, this does not work?
EXTRA_ARGS += +notimingchecks
endif

SIM_ARGS += -no_autoacc


include $(shell cocotb-config --makefiles)/Makefile.sim