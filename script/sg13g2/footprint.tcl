# ===============================================================================================================================
# Input configuration
# ===============================================================================================================================

# Chip dimensions
set DIE_MARGIN_X 270.24
set DIE_MARGIN_Y 272.16
# Use multiple of 3.78 (row height)
set CORE_HEIGHT 1024.38
set CORE_WIDTH 1450

# Macro dimensions
# https://github.com/IHP-GmbH/IHP-Open-PDK/blob/main/ihp-sg13g2/libs.ref/sg13g2_sram/lef/RM_IHPSG13_1P_4096x16_c3_bm_bist.lef
set SRAM1_WIDTH 416.64
set SRAM1_HEIGHT 618.3
# https://github.com/IHP-GmbH/IHP-Open-PDK/blob/main/ihp-sg13g2/libs.ref/sg13g2_sram/lef/RM_IHPSG13_1P_256x48_c2_bm_bist.lef
set SRAM2_WIDTH 596.48
set SRAM2_HEIGHT 118.78
# IO Pads
set IO_LENGTH 180
set BONDPAD_SIZE 70


# ===============================================================================================================================
# Calculate chip area and core positions
# ===============================================================================================================================
set CORE_X1 $DIE_MARGIN_X
set CORE_Y1 $DIE_MARGIN_Y
set CORE_X2 [expr {($CORE_X1 + $CORE_WIDTH)}]
set CORE_Y2 [expr {($CORE_Y1 + $CORE_HEIGHT)}]
set CORE_AREA [expr {$CORE_WIDTH * $CORE_HEIGHT}]

set DIE_HEIGHT [expr {(2*$DIE_MARGIN_Y + $CORE_HEIGHT)}]
set DIE_WIDTH [expr {(2*$DIE_MARGIN_X + $CORE_WIDTH)}]
set DIE_AREA [expr {$DIE_WIDTH * $DIE_HEIGHT}]

puts "--------------------------------------------------------------------------"
puts "Floorplan DIE: $DIE_WIDTH um X $DIE_HEIGHT um = $DIE_AREA um2"
puts "Floorplan CORE: $CORE_WIDTH um X $CORE_HEIGHT um = $CORE_AREA um2"
puts "Floorplan CORE: ($CORE_X1 $CORE_Y1) to ($CORE_X2 $CORE_Y2)"
puts "--------------------------------------------------------------------------"


# ===============================================================================================================================
# Initialize floorplan
# ===============================================================================================================================
initialize_floorplan \
    -die_area "0 0 $DIE_WIDTH $DIE_HEIGHT" \
    -core_area "$CORE_X1 $CORE_Y1 $CORE_X2 $CORE_Y2" \
    -site $::env(PLACE_SITE) 

# ===============================================================================================================================
# Set up IO sides
# ===============================================================================================================================
# sg13g2_io.lef defines sg13g2_ioSite for the sides, but no corner site
make_fake_io_site -name sg13g2_ioCSite -width $IO_LENGTH -height $IO_LENGTH

# Create IO Rows
make_io_sites \
    -horizontal_site sg13g2_ioSite \
    -vertical_site sg13g2_ioSite \
    -corner_site sg13g2_ioCSite \
    -offset $BONDPAD_SIZE

######## Place Pads ########
place_pads -row IO_EAST \
    {io/iob0/pad\[21\].inst} \
    {io/iob0/pad\[20\].inst} \
    {io/iob0/pad\[19\].inst} \
    {io/iob0/pad\[18\].inst} \
    {io/iob0/pad\[17\].inst} \
    {io/iob0/pad\[16\].inst} \
    {io/iob0/pad\[15\].inst} \
    {io/iob0/pad\[14\].inst} \
    io/iob1/u_pad_vddio_0 \
    io/iob1/u_pad_gndio_0

place_pads -row IO_WEST \
    io/iob1/u_pad_vddio_1 \
    io/iob1/u_pad_gndio_1 \
    io/iob1/u_pad_clk \
    io/iob1/u_pad_arstn \
    {io/iob0/pad\[0\].inst} \
    {io/iob0/pad\[1\].inst} \
    {io/iob0/pad\[2\].inst} \
    {io/iob0/pad\[3\].inst} \
    {io/iob0/pad\[4\].inst} \
    {io/iob0/pad\[5\].inst}

place_pads -row IO_NORTH \
    io/iob1/u_pad_vdd_0 \
    io/iob1/u_pad_gnd_0 \
    {io/iob0/pad\[6\].inst} \
    {io/iob0/pad\[7\].inst} \
    {io/iob0/pad\[8\].inst} \
    {io/iob0/pad\[9\].inst} \
    {io/iob0/pad\[10\].inst} \
    {io/iob0/pad\[11\].inst} \
    {io/iob0/pad\[12\].inst} \
    {io/iob0/pad\[13\].inst}

place_pads -row IO_SOUTH \
    io/iob1/u_pad_xip_sdo \
    io/iob1/u_pad_xip_sdi \
    io/iob1/u_pad_xip_clk \
    io/iob1/u_pad_xip_csn \
    io/iob1/u_pad_jtag_tms \
    io/iob1/u_pad_jtag_tdo \
    io/iob1/u_pad_jtag_tdi \
    io/iob1/u_pad_jtag_tck \
    io/iob1/u_pad_vdd_1 \
    io/iob1/u_pad_gnd_1

# Place corners
place_corners sg13g2_Corner

# Place IO fill
set iofill {sg13g2_Filler10000
            sg13g2_Filler4000
            sg13g2_Filler2000
            sg13g2_Filler1000
            sg13g2_Filler400
            sg13g2_Filler200} ;
place_io_fill -row IO_NORTH {*}$iofill
place_io_fill -row IO_SOUTH {*}$iofill
place_io_fill -row IO_WEST {*}$iofill
place_io_fill -row IO_EAST {*}$iofill

# Place the bondpads
place_bondpad -bond bondpad_70x70 io/iob1/u_pad_* -offset "5.0 -$BONDPAD_SIZE.0"
place_bondpad -bond bondpad_70x70 io/iob0/*.inst -offset "5.0 -$BONDPAD_SIZE.0"

# Connect ring signals
connect_by_abutment
remove_io_rows


# ===============================================================================================================================
# Place SRAM macros
# ===============================================================================================================================
set CPU_RAM1_X $CORE_X1
set CPU_RAM1_Y $CORE_Y1
set CPU_RAM2_X [expr {($CPU_RAM1_X + $SRAM1_WIDTH)}]
set CPU_RAM2_Y $CPU_RAM1_Y

set FIFO_RAM_X $CORE_X1
set FIFO_RAM_Y [expr {($CORE_Y2 - $SRAM2_HEIGHT)}]
set XCACHE_RAM_X [expr {($FIFO_RAM_X + $SRAM2_WIDTH)}]
set XCACHE_RAM_Y [expr {($CORE_Y2 - $SRAM2_HEIGHT)}]
place_macro -macro_name cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n1_row_n1_inst -location "$CPU_RAM1_X $CPU_RAM1_Y" -orientation R180
place_macro -macro_name cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n2_row_n1_inst -location "$CPU_RAM2_X $CPU_RAM2_Y" -orientation R180
place_macro -macro_name audio/fifo/mem/sram -location "$FIFO_RAM_X $FIFO_RAM_Y" -orientation R0
place_macro -macro_name cpu/inst/memory_system_neorv32_xip_enabled_neorv32_xipcache_enabled_neorv32_xcache_inst/neorv32_cache_memory_inst/mem -location "$XCACHE_RAM_X $XCACHE_RAM_Y" -orientation R0