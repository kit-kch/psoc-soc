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
SW_ENV=$(abspath ./script/sw/sw_env.sh)
CADENCE_ENV=$(abspath ./script/cadence/cadence_env.sh)

####################################################################################################
# Abbreviations
####################################################################################################
XPR_FILE=build/psoc/psoc.xpr

####################################################################################################
# Rules
####################################################################################################
.PHONY: all sim bitstream project ui standalone.bit soc.bit clean i2s_sin i2s_sin_ir dac_bit

# High-level wrapper targets
all: sim bitstream sw
sim: $(SIM_SETS)
bitstream: standalone.bit soc.bit
sw: i2s_sin i2s_sin_ir dac_bit boardtest

clean:
	cd ext/psoc_demo_sw/i2s_sin && $(SW_ENV) make clean
	cd ext/psoc_demo_sw/i2s_sin_ir && $(SW_ENV) make clean
	cd ext/psoc_demo_sw/dac_bit && $(SW_ENV) make clean
	cd ext/psoc_boardtest_sw && $(SW_ENV) make clean
	rm -rvf build
	rm -rvf out

# Project and UI
project: $(XPR_FILE)
$(XPR_FILE): script/vivado/gen_prj.tcl
	rm -rvf build
	mkdir -p build
	cd build && echo 'set origin_dir_loc "../script/vivado"; source ../script/vivado/gen_prj.tcl' | $(VIVADO_ENV) vivado -mode tcl

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

# Software
i2s_sin:
	mkdir -p out
	cd ext/psoc_demo_sw/i2s_sin && $(SW_ENV) make exe
	cp -v ext/psoc_demo_sw/i2s_sin/neorv32_exe.bin out/i2s_sin.exe.bin

i2s_sin_ir:
	mkdir -p out
	cd ext/psoc_demo_sw/i2s_sin_ir && $(SW_ENV) make exe
	cp -v ext/psoc_demo_sw/i2s_sin_ir/neorv32_exe.bin out/i2s_sin_ir.exe.bin

dac_bit:
	mkdir -p out
	cd ext/psoc_demo_sw/dac_bit && $(SW_ENV) make exe
	cp -v ext/psoc_demo_sw/dac_bit/neorv32_exe.bin out/dac_bit.exe.bin

boardtest:
	mkdir -p out
	cd ext/psoc_boardtest_sw && $(SW_ENV) make exe
	cp -v ext/psoc_boardtest_sw/neorv32_exe.bin out/boardtest.exe.bin

# Cadence

# Synthesis
%.genus:
	mkdir -p out
	mkdir -p build/$*.genus/
	cd build/$*.genus; \
		export HDL_TOP=$*; \
		$(CADENCE_ENV) genus -overwrite -files ../../script/cadence/implementation/synthesis/synthesize.tcl

# Implementation
%.innovus:
	mkdir -p out
	mkdir -p build/$*.innovus/
	cd build/$*.innovus; \
		export HDL_TOP=$*; \
		$(CADENCE_ENV) innovus -files ../../script/cadence/implementation/placeandroute/innovus_parameters.tcl

# Simulation
%.xrun:
	mkdir -p out
	mkdir -p build/$*.xrun/
	cd build/$*.xrun; \
		GUI_ARG=$$([ -z "$(GUI)" ] && echo "" || echo "-gui"); \
		export SIM_NAME=$*; \
		$(CADENCE_ENV) xrun -f ../../script/cadence/verification/sim_rtl.f $$GUI_ARG

# sim_gtl
%.xrun2:
	mkdir -p out
	mkdir -p build/$*.xrun/
	cd build/$*.xrun; \
		GUI_ARG=$$([ -z "$(GUI)" ] && echo "" || echo "-gui"); \
		export SIM_NAME=$*; \
		$(CADENCE_ENV) xrun -f ../../script/cadence/verification/sim_gtl.f $$GUI_ARG

# sim_par
%.xrun3:
	mkdir -p out
	mkdir -p build/$*.xrun/
	cd build/$*.xrun; \
		GUI_ARG=$$([ -z "$(GUI)" ] && echo "" || echo "-gui"); \
		export SIM_NAME=$*; \
		$(CADENCE_ENV) xrun -f ../../script/cadence/verification/sim_par.f $$GUI_ARG

# 
%.xrun4:
	mkdir -p out
	mkdir -p build/$*.xrun/
	cd build/$*.xrun; \
		GUI_ARG=$$([ -z "$(GUI)" ] && echo "" || echo "-gui"); \
		export SIM_NAME=$*; \
		$(CADENCE_ENV) xrun -f ../../script/cadence/verification/sim_par.f -define SDF_ANNOTATE $$GUI_ARG