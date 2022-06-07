# Clock domain crossing for reset signal
set_false_path -from [get_pins {reset_counter_reg[5]/C}]
create_clock -period 10.000 -name sys_clk -waveform {0.000 5.000} [get_ports sys_clk]

# Zedboard Clock GCLK
# ------------------------------------------------------
set_property PACKAGE_PIN Y9 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]

# Debug Pins on a PMOD
# ------------------------------------------------------
# "JD2_N"
set_property PACKAGE_PIN V4 [get_ports {debug[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug[7]}]
# "JD2_P"
set_property PACKAGE_PIN V5 [get_ports {debug[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug[6]}]
# "JD1_N"
set_property PACKAGE_PIN W7 [get_ports {debug[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug[5]}]
# "JD1_P"
set_property PACKAGE_PIN V7 [get_ports {debug[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug[4]}]
# "JC2_N"
set_property PACKAGE_PIN AA4 [get_ports {debug[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug[3]}]
# "JC2_P"
set_property PACKAGE_PIN Y4 [get_ports {debug[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug[2]}]
# "JC1_N"
set_property PACKAGE_PIN AB6 [get_ports {debug[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug[1]}]
# "JC1_P"
set_property PACKAGE_PIN AB7 [get_ports {debug[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug[0]}]

# DIP switches
# ------------------------------------------------------
set_property PACKAGE_PIN M15 [get_ports {dip[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dip[7]}]
set_property PACKAGE_PIN H17 [get_ports {dip[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dip[6]}]
set_property PACKAGE_PIN H18 [get_ports {dip[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dip[5]}]
set_property PACKAGE_PIN H19 [get_ports {dip[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dip[4]}]
set_property PACKAGE_PIN F21 [get_ports {dip[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dip[3]}]
set_property PACKAGE_PIN H22 [get_ports {dip[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dip[2]}]
set_property PACKAGE_PIN G22 [get_ports {dip[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dip[1]}]
set_property PACKAGE_PIN F22 [get_ports {dip[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dip[0]}]

# LED outputs
# ------------------------------------------------------
set_property PACKAGE_PIN U14 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]
set_property PACKAGE_PIN U19 [get_ports {led[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
set_property PACKAGE_PIN W22 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
set_property PACKAGE_PIN V22 [get_ports {led[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
set_property PACKAGE_PIN U21 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
set_property PACKAGE_PIN U22 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property PACKAGE_PIN T21 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property PACKAGE_PIN T22 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

# Push buttons
# ------------------------------------------------------
set_property PACKAGE_PIN P16 [get_ports {btn_c}];               # "BTNC"
set_property IOSTANDARD LVCMOS33 [get_ports {btn_c}];
set_property PACKAGE_PIN R16 [get_ports {btn_d}];               # "BTND"
set_property IOSTANDARD LVCMOS33 [get_ports {btn_d}];
set_property PACKAGE_PIN N15 [get_ports {btn_l}];               # "BTNL"
set_property IOSTANDARD LVCMOS33 [get_ports {btn_l}];
set_property PACKAGE_PIN R18 [get_ports {btn_r}];               # "BTNR"
set_property IOSTANDARD LVCMOS33 [get_ports {btn_r}];
set_property PACKAGE_PIN T18 [get_ports {btn_u}];               # "BTNU"
set_property IOSTANDARD LVCMOS33 [get_ports {btn_u}];



# ======================================================
# FMC Pins for PSOC Boards
# ======================================================


# Audio Codec
# ------------------------------------------------------

# These are on the extension board:
# LA01_CC_P, Bank 34
set_property PACKAGE_PIN N19 [get_ports ac_mclk]
set_property IOSTANDARD LVCMOS33 [get_ports ac_mclk]
# LA01_CC_N, Bank 34
set_property PACKAGE_PIN N20 [get_ports ac_bclk]
set_property IOSTANDARD LVCMOS33 [get_ports ac_bclk]
# LA17_CC_P, Bank 35
set_property PACKAGE_PIN B19 [get_ports ac_lrclk]
set_property IOSTANDARD LVCMOS33 [get_ports ac_lrclk]
# LA17_CC_N, Bank 35
set_property PACKAGE_PIN B20 [get_ports ac_dac_sdata]
set_property IOSTANDARD LVCMOS33 [get_ports ac_dac_sdata]