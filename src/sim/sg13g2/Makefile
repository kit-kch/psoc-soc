# Makefile
# See https://docs.cocotb.org/en/stable/quickstart.html for more info

# defaults
SIM ?= verilator
TOPLEVEL_LANG ?= verilog
SRC_DIR = $(PWD)/../../hdl
PDK_DIR = $(FLOW_HOME)/platforms/ihp-sg13g2/verilog

RTL_SOURCES = \
    sg13g2/sfifo_mem.v \
    audio/sfifo.v \
    audio/clock_generator.v \
    audio/i2s_master.v \
    audio/psoc_dac_fpga.v \
    audio/i2s_wb_regfile.v \
    audio/psoc_audio.v \
    sg13g2/iobank0.v \
    sg13g2/iobank1.v \
    io/io_wb_regfile.v \
    io/iomux.v \
    io/io_subsystem.v \
    sg13g2/neorv32_wrap.v \
    reset_logic.v \
    wb_xbar.v \
	soc_top.v

ifneq ($(GATES),yes)
# RTL simulation:
SIM_BUILD = sim_build/rtl
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(RTL_SOURCES))
else
# Gate level simulation:
SIM_BUILD		= sim_build/gl
COMPILE_ARGS    += -DGL_TEST
COMPILE_ARGS    += -DFUNCTIONAL
COMPILE_ARGS    += -DUSE_POWER_PINS
COMPILE_ARGS    += -DSIM
COMPILE_ARGS    += -DUNIT_DELAY=\#1
VERILOG_SOURCES += $(PDK_DIR)/sg13g2_stdcell.v

# this gets copied in by the GDS action workflow
VERILOG_SOURCES += $(FLOW_HOME)/results/ihp-sg13g2/soc_top/base/6_final.v
endif

# Missing in ORFS PDK installation....
VERILOG_SOURCES += $(PWD)/RM_IHPSG13_1P_core_behavioral_bm_bist.v
VERILOG_SOURCES += $(PDK_DIR)/RM_IHPSG13_1P_256x48_c2_bm_bist.v
VERILOG_SOURCES += $(PDK_DIR)/RM_IHPSG13_1P_4096x16_c3_bm_bist.v
VERILOG_SOURCES += $(PDK_DIR)/sg13g2_io.v

# Allow sharing configuration between design and testbench via `include`:
COMPILE_ARGS 		+= -I$(SRC_DIR)

# NEORV32 generates a lot of these
COMPILE_ARGS += -Wno-UNOPTFLAT

# Enable waveform output
EXTRA_ARGS += --trace --trace-structs

# Include the testbench sources:
VERILOG_SOURCES += $(PWD)/sg13g2_tb.v
TOPLEVEL = sg13g2_tb

# MODULE is the basename of the Python test file
MODULE = sg13g2_tb

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim