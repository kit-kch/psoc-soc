export DESIGN_NAME = soc_top
export DESIGN_PATH := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))../../
export PLATFORM    = ihp-sg13g2

export ADDITIONAL_LEFS += $(PLATFORM_DIR)/lef/RM_IHPSG13_1P_4096x16_c3_bm_bist.lef \
    $(PLATFORM_DIR)/lef/RM_IHPSG13_1P_256x48_c2_bm_bist.lef
export ADDITIONAL_LIBS += $(PLATFORM_DIR)/lib/RM_IHPSG13_1P_4096x16_c3_bm_bist_typ_1p20V_25C.lib \
    $(PLATFORM_DIR)/lib/RM_IHPSG13_1P_256x48_c2_bm_bist_typ_1p20V_25C.lib
export ADDITIONAL_GDS += $(PLATFORM_DIR)/gds/RM_IHPSG13_1P_4096x16_c3_bm_bist.gds \
    $(PLATFORM_DIR)/gds/RM_IHPSG13_1P_256x48_c2_bm_bist.gds

RTL_DIR = $(DESIGN_PATH)src/hdl
SCRIPT_DIR = $(DESIGN_PATH)script/sg13g2

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

export VERILOG_FILES = $(addprefix $(RTL_DIR)/,$(RTL_SOURCES))
export SDC_FILE = $(SCRIPT_DIR)/constraint.sdc
export FOOTPRINT_TCL = $(SCRIPT_DIR)/footprint.tcl
export SEAL_GDS = $(SCRIPT_DIR)/sealring.gds

export PLACE_DENSITY = 0.65
# Reduce HALO size around SRAM macros
export MACRO_BLOCKAGE_HALO = 2

# Have to specify this, but it's ignored as we use manual floorplan in footprint.tcl
export CORE_UTILIZATION = 0.8

export USE_FILL = 1
export TNS_END_PERCENT = 100

export SYNTH_MEMORY_MAX_BITS = 12288
# For debugging, disable later
export SYNTH_HIERARCHICAL=1