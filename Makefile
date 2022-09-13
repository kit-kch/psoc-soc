####################################################################################################
# Configuration
####################################################################################################
SIMULATION_SETS = i2s_master \
    sine_generator clock_generator fpga_soc_top fpga_standalone_top

####################################################################################################
# Generated variables
####################################################################################################
SIM_SETS=$(addsuffix .sim,$(SIMULATION_SETS))

####################################################################################################
# Tool Commands
####################################################################################################
VIVADO_ENV=$(abspath ./script/vivado/vivado_env.sh)

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
	rm -rvf out

# Project and UI
project: $(XPR_FILE)
$(XPR_FILE): script/vivado/gen_prj.tcl
	rm -rvf build
	mkdir -p build
	cd build && $(VIVADO_ENV) vivado -mode batch -source ../script/vivado/gen_prj.tcl

ui: $(XPR_FILE)
	cd build && $(VIVADO_ENV) vivado ../$(XPR_FILE)

tcl: $(XPR_FILE)
	cd build && $(VIVADO_ENV) vivado -mode batch -source ../script/vivado/update_prj.tcl

# Bitstreams
# Always phony: we want to rebuild whenever this target is invoked
# Otherwise we'd have to add dependencies on all source files
standalone.bit: $(XPR_FILE)
	mkdir -p out
	cd build && $(VIVADO_ENV) vivado -mode batch -source ../script/vivado/standalone_bit.tcl -nojournal -log ../out/fpga_standalone.log
	cp -v build/psoc/psoc.runs/synth_1/runme.log out/synthesis.log
	cp -v build/psoc/psoc.runs/impl_1/runme.log out/implementation.log
	cp -v build/psoc/psoc.runs/impl_1/fpga_standalone_top_timing_summary_routed.rpt out/
	cp -v build/psoc/psoc.runs/impl_1/fpga_standalone_top_utilization_placed.rpt out/
	cp -v build/psoc/psoc.runs/impl_1/fpga_standalone_top.bit out/standalone.bit

soc.bit: $(XPR_FILE)
	mkdir -p out
	cd build && $(VIVADO_ENV) vivado -mode batch -source ../script/vivado/soc_bit.tcl -nojournal -log ../out/fpga_soc.log
	cp -v build/psoc/psoc.runs/synth_1/runme.log out/synthesis.log
	cp -v build/psoc/psoc.runs/impl_1/runme.log out/implementation.log
	cp -v build/psoc/psoc.runs/impl_1/fpga_soc_top_timing_summary_routed.rpt out/
	cp -v build/psoc/psoc.runs/impl_1/fpga_soc_top_utilization_placed.rpt out/
	cp -v build/psoc/psoc.runs/impl_1/fpga_soc_top.bit out/soc.bit

# Simulation
%.sim: $(XPR_FILE)
	mkdir -p out
	cd build && $(VIVADO_ENV) vivado -mode batch -source ../script/vivado/gen_sim.tcl -nojournal -log ../out/gen_sim.log
	cd build/psoc/psoc.sim/$*/behav/xsim && \
		$(VIVADO_ENV) ./compile.sh && \
		$(VIVADO_ENV) ./elaborate.sh && \
		$(VIVADO_ENV) ./simulate.sh
	cp -v build/psoc/psoc.sim/$*/behav/xsim/simulate.log out/$*.sim.log
	grep -q 'Test OK' out/$*.sim.log
