export DESIGN_NAME = soc_top
export DESIGN_PATH := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))../../
export PLATFORM    = ihp-sg13g2

RTL_DIR = $(DESIGN_PATH)src/hdl
SCRIPT_DIR = $(DESIGN_PATH)script/sg13g2

RTL_SOURCES = reset_logic.v \
    clock_generator.v \
    i2s_master.v \
    psoc_dac_fpga.v \
    sfifo.v \
    i2s_wb_regfile.v \
    psoc_audio.v \
    sg13g2/neorv32_wrap.v \
	sg13g2/soc_top.v

export VERILOG_FILES = $(addprefix $(RTL_DIR)/,$(RTL_SOURCES))
export SDC_FILE = $(SCRIPT_DIR)/constraint.sdc

export USE_FILL = 1

export CORE_UTILIZATION = 60
export TNS_END_PERCENT = 100

# FIXME
export SYNTH_MEMORY_MAX_BITS = 20000000