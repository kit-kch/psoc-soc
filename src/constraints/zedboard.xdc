# Debug PMOD pins
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN V4 [get_ports {debug[7]}];             # "JD2_N"
set_property IOSTANDARD LVCMOS33 [get_ports {debug[7]}];
set_property PACKAGE_PIN V5 [get_ports {debug[6]}];             # "JD2_P"
set_property IOSTANDARD LVCMOS33 [get_ports {debug[6]}];
set_property PACKAGE_PIN W7 [get_ports {debug[5]}];             # "JD1_N"
set_property IOSTANDARD LVCMOS33 [get_ports {debug[5]}];
set_property PACKAGE_PIN V7 [get_ports {debug[4]}];             # "JD1_P"
set_property IOSTANDARD LVCMOS33 [get_ports {debug[4]}];
set_property PACKAGE_PIN AA4 [get_ports {debug[3]}];            # "JC2_N"
set_property IOSTANDARD LVCMOS33 [get_ports {debug[3]}];
set_property PACKAGE_PIN Y4 [get_ports {debug[2]}];             # "JC2_P"
set_property IOSTANDARD LVCMOS33 [get_ports {debug[2]}];
set_property PACKAGE_PIN AB6 [get_ports {debug[1]}];            # "JC1_N"
set_property IOSTANDARD LVCMOS33 [get_ports {debug[1]}];
set_property PACKAGE_PIN AB7 [get_ports {debug[0]}];            # "JC1_P"
set_property IOSTANDARD LVCMOS33 [get_ports {debug[0]}];

# ----------------------------------------------------------------------------
# Bank 13
# Note that the bank voltage for IO Bank 13 is fixed to 3.3V on ZedBoard.
# ----------------------------------------------------------------------------

## Audio Codec
#set_property PACKAGE_PIN AB1 [get_ports {ac_addr0_clatch}];     # "AC-ADR0"
#set_property IOSTANDARD LVCMOS33 [get_ports {ac_addr0_clatch}];
#set_property PACKAGE_PIN Y5  [get_ports {ac_addr1_cdata}];      # "AC-ADR1"
#set_property IOSTANDARD LVCMOS33 [get_ports {ac_addr1_cdata}];
#set_property PACKAGE_PIN Y8  [get_ports {ac_dac_sdata}];        # "AC-GPIO0"
#set_property IOSTANDARD LVCMOS33 [get_ports {ac_dac_sdata}];
#set_property PACKAGE_PIN AA6 [get_ports {ac_bclk}];             # "AC-GPIO2"
#set_property IOSTANDARD LVCMOS33 [get_ports {ac_bclk}];
#set_property PACKAGE_PIN Y6  [get_ports {ac_lrclk}];            # "AC-GPIO3"
#set_property IOSTANDARD LVCMOS33 [get_ports {ac_lrclk}];
#set_property PACKAGE_PIN AB2 [get_ports {ac_mclk}];             # "AC-MCLK"
#set_property IOSTANDARD LVCMOS33 [get_ports {ac_mclk}];
#set_property PACKAGE_PIN AB4 [get_ports {ac_scl_cclk}];         # "AC-SCK"
#set_property IOSTANDARD LVCMOS33 [get_ports {ac_scl_cclk}];
##set_property PACKAGE_PIN AA7 [get_ports {ac_adc_sdata}];       # "AC-GPIO1"
##set_property IOSTANDARD LVCMOS33 [get_ports {ac_adc_sdata}];
##set_property PACKAGE_PIN AB5 [get_ports {iic_rtl_sda_io}];     # "AC-SDA"
##set_property IOSTANDARD LVCMOS33 [get_ports {iic_rtl_sda_io}];

# Audio Codec
set_property PACKAGE_PIN LA07_N [get_ports {ac_addr0_clatch}];     # "AC-ADR0"  SPI_SD_SS
set_property IOSTANDARD LVCMOS33 [get_ports {ac_addr0_clatch}];
set_property PACKAGE_PIN LA20_N  [get_ports {ac_addr1_cdata}];      # "AC-ADR1" SPI_MOSI
set_property IOSTANDARD LVCMOS33 [get_ports {ac_addr1_cdata}];
set_property PACKAGE_PIN LA17_N_CC [get_ports {ac_dac_sdata}];        # "AC-GPIO0" I2S_SDIN
set_property IOSTANDARD LVCMOS33 [get_ports {ac_dac_sdata}];
set_property PACKAGE_PIN LA01_N_CC [get_ports {ac_bclk}];             # "AC-GPIO2"  I2S_SCLK
set_property IOSTANDARD LVCMOS33 [get_ports {ac_bclk}];
set_property PACKAGE_PIN LA17_P_CC  [get_ports {ac_lrclk}];            # "AC-GPIO3" I2S_LRCLK
set_property IOSTANDARD LVCMOS33 [get_ports {ac_lrclk}];
set_property PACKAGE_PIN LA01_P_CC [get_ports {ac_mclk}];             # "AC-MCLK" I2S_MCLK
set_property IOSTANDARD LVCMOS33 [get_ports {ac_mclk}];
set_property PACKAGE_PIN LA00_P_CC [get_ports {ac_scl_cclk}];         # "AC-SCK" SPI_SCK
set_property IOSTANDARD LVCMOS33 [get_ports {ac_scl_cclk}];
#set_property PACKAGE_PIN AA7 [get_ports {ac_adc_sdata}];       # "AC-GPIO1"
#set_property IOSTANDARD LVCMOS33 [get_ports {ac_adc_sdata}];
#set_property PACKAGE_PIN AB5 [get_ports {iic_rtl_sda_io}];     # "AC-SDA"
#set_property IOSTANDARD LVCMOS33 [get_ports {iic_rtl_sda_io}];

## Clock source
#set_property PACKAGE_PIN Y9  [get_ports {sys_clk}];             # "GCLK"
#set_property IOSTANDARD LVCMOS33 [get_ports {sys_clk}];

# Clock source
set_property PACKAGE_PIN CLK0_M2C_P  [get_ports {sys_clk}];             # "GCLK" CLK_IN
set_property IOSTANDARD LVCMOS33 [get_ports {sys_clk}];


# ----------------------------------------------------------------------------
# Bank 35
# ----------------------------------------------------------------------------

# DIP switches
set_property PACKAGE_PIN M15 [get_ports {dip[7]}];              # "SW7"
set_property IOSTANDARD LVCMOS18 [get_ports {dip[7]}];
set_property PACKAGE_PIN H17 [get_ports {dip[6]}];              # "SW6"
set_property IOSTANDARD LVCMOS18 [get_ports {dip[6]}];
set_property PACKAGE_PIN H18 [get_ports {dip[5]}];              # "SW5"
set_property IOSTANDARD LVCMOS18 [get_ports {dip[5]}];
set_property PACKAGE_PIN H19 [get_ports {dip[4]}];              # "SW4"
set_property IOSTANDARD LVCMOS18 [get_ports {dip[4]}];
set_property PACKAGE_PIN F21 [get_ports {dip[3]}];              # "SW3"
set_property IOSTANDARD LVCMOS18 [get_ports {dip[3]}];
set_property PACKAGE_PIN H22 [get_ports {dip[2]}];              # "SW2"
set_property IOSTANDARD LVCMOS18 [get_ports {dip[2]}];
set_property PACKAGE_PIN G22 [get_ports {dip[1]}];              # "SW1"
set_property IOSTANDARD LVCMOS18 [get_ports {dip[1]}];
set_property PACKAGE_PIN F22 [get_ports {dip[0]}];              # "SW0"
set_property IOSTANDARD LVCMOS18 [get_ports {dip[0]}];



# ----------------------------------------------------------------------------
# Bank 33
# Note that the bank voltage for IO Bank 33 is fixed to 3.3V on ZedBoard.
# ----------------------------------------------------------------------------

# LED outputs
set_property PACKAGE_PIN U14 [get_ports {led[7]}];              # "LD7"
set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}];
set_property PACKAGE_PIN U19 [get_ports {led[6]}];              # "LD6"
set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}];
set_property PACKAGE_PIN W22 [get_ports {led[5]}];              # "LD5"
set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}];
set_property PACKAGE_PIN V22 [get_ports {led[4]}];              # "LD4"
set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}];
set_property PACKAGE_PIN U21 [get_ports {led[3]}];              # "LD3"
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}];
set_property PACKAGE_PIN U22 [get_ports {led[2]}];              # "LD2"
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}];
set_property PACKAGE_PIN T21 [get_ports {led[1]}];              # "LD1"
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}];
set_property PACKAGE_PIN T22 [get_ports {led[0]}];              # "LD0"
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}];



# ----------------------------------------------------------------------------
# Bank 34
# ----------------------------------------------------------------------------

## Push buttons
#set_property PACKAGE_PIN P16 [get_ports {btn_c}];               # "BTNC"
#set_property IOSTANDARD LVCMOS18 [get_ports {btn_c}];
#set_property PACKAGE_PIN R16 [get_ports {btn_d}];               # "BTND"
#set_property IOSTANDARD LVCMOS18 [get_ports {btn_d}];
#set_property PACKAGE_PIN N15 [get_ports {btn_l}];               # "BTNL"
#set_property IOSTANDARD LVCMOS18 [get_ports {btn_l}];
#set_property PACKAGE_PIN R18 [get_ports {btn_r}];               # "BTNR"
#set_property IOSTANDARD LVCMOS18 [get_ports {btn_r}];
#set_property PACKAGE_PIN T18 [get_ports {btn_u}];               # "BTNU"
#set_property IOSTANDARD LVCMOS18 [get_ports {btn_u}];

## Clock domain crossing for reset signal
#set_false_path -from [get_pins {reset_counter_reg[5]/C}]

# Push buttons
set_property PACKAGE_PIN LA24_P [get_ports {btn_c}];               # "BTNC"
set_property IOSTANDARD LVCMOS18 [get_ports {btn_c}];
set_property PACKAGE_PIN LA21_N [get_ports {btn_d}];               # "BTND"
set_property IOSTANDARD LVCMOS18 [get_ports {btn_d}];
set_property PACKAGE_PIN LA21_P [get_ports {btn_l}];               # "BTNL"
set_property IOSTANDARD LVCMOS18 [get_ports {btn_l}];
set_property PACKAGE_PIN LA25_N [get_ports {btn_r}];               # "BTNR"
set_property IOSTANDARD LVCMOS18 [get_ports {btn_r}];
set_property PACKAGE_PIN LA25_P [get_ports {btn_u}];               # "BTNU"
set_property IOSTANDARD LVCMOS18 [get_ports {btn_u}];

# Clock domain crossing for reset signal
set_false_path -from [get_pins {reset_counter_reg[5]/C}]


# ----------------------------------------------------------------------------
# Bank 35
# NeoRV32
# ----------------------------------------------------------------------------

## GPIO

#set_property PACKAGE_PIN Y11 [get_ports {gpio_o[7]}]
#set_property PACKAGE_PIN AA11 [get_ports {gpio_o[6]}]
#set_property PACKAGE_PIN Y10 [get_ports {gpio_o[5]}]
#set_property PACKAGE_PIN AA9 [get_ports {gpio_o[4]}]
#set_property PACKAGE_PIN AB11 [get_ports {gpio_o[3]}]
#set_property PACKAGE_PIN AB10 [get_ports {gpio_o[2]}]
#set_property PACKAGE_PIN AB9 [get_ports {gpio_o[1]}]
#set_property PACKAGE_PIN AA8 [get_ports {gpio_o[0]}]

#set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[0]}]

# GPIO

set_property PACKAGE_PIN Y11 [get_ports {gpio_o[7]}]
set_property PACKAGE_PIN AA11 [get_ports {gpio_o[6]}]
set_property PACKAGE_PIN Y10 [get_ports {gpio_o[5]}]
set_property PACKAGE_PIN AA9 [get_ports {gpio_o[4]}]
set_property PACKAGE_PIN AB11 [get_ports {gpio_o[3]}]
set_property PACKAGE_PIN AB10 [get_ports {gpio_o[2]}]
set_property PACKAGE_PIN AB9 [get_ports {gpio_o[1]}]
set_property PACKAGE_PIN AA8 [get_ports {gpio_o[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[0]}]

# ----------------------------------------------------------------------------
# Bank 36
# NeoRV32
# ----------------------------------------------------------------------------

## UART
## JB3
#set_property PACKAGE_PIN V10 [get_ports uart0_rxd_i]
#set_property IOSTANDARD LVCMOS33 [get_ports {uart0_rxd_i}];
## JB2
#set_property PACKAGE_PIN W11 [get_ports uart0_txd_o]
#set_property IOSTANDARD LVCMOS33 [get_ports {uart0_txd_o}];

# UART
# JB3
set_property PACKAGE_PIN LA02_N [get_ports uart0_rxd_i]
set_property IOSTANDARD LVCMOS33 [get_ports {uart0_rxd_i}];
# JB2
set_property PACKAGE_PIN LA02_P [get_ports uart0_txd_o]
set_property IOSTANDARD LVCMOS33 [get_ports {uart0_txd_o}];


# ----------------------------------------------------------------------------
# Bank 37
# ----------------------------------------------------------------------------

# CLK

#create_clock -period 8.30 -name sys_clk -waveform {0.000 4.2} [get_ports sys_clk]
create_clock -period 10.000 -name sys_clk -waveform {0.000 5.000} [get_ports sys_clk]







