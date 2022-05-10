# Clock domain crossing for reset signal
set_false_path -from [get_pins {reset_counter_reg[5]/C}]
create_clock -period 10.000 -name sys_clk -waveform {0.000 5.000} [get_ports sys_clk]

# RST button
# ------------------------------------------------------
set_property PACKAGE_PIN P16 [get_ports btn_rst]
set_property IOSTANDARD LVCMOS33 [get_ports btn_rst]

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




# ======================================================
# FMC Pins for PSOC Boards
# ======================================================

# JTAG
# ------------------------------------------------------
# LA14_P, Bank 34
set_property PACKAGE_PIN K19 [get_ports {jtag_trst_i}]
set_property IOSTANDARD LVCMOS33 [get_ports {jtag_trst_i}]
# LA06_P, Bank 34
set_property PACKAGE_PIN L21 [get_ports {jtag_tck_i}]
set_property IOSTANDARD LVCMOS33 [get_ports {jtag_tck_i}]
# LA06_N, Bank 34
set_property PACKAGE_PIN L22 [get_ports {jtag_tdi_i}]
set_property IOSTANDARD LVCMOS33 [get_ports {jtag_tdi_i}]
# LA26_N, Bank 35
set_property PACKAGE_PIN E18 [get_ports {jtag_tdo_o}]
set_property IOSTANDARD LVCMOS33 [get_ports {jtag_tdo_o}]
# LA26_P, Bank 35
set_property PACKAGE_PIN F18 [get_ports {jtag_tms_i}]
set_property IOSTANDARD LVCMOS33 [get_ports {jtag_tms_i}]

# Clock Oscillator
# ------------------------------------------------------
# CLK0_M2C_P, Bank 34
#set_property PACKAGE_PIN L18 [get_ports {sys_clk}];
#set_property IOSTANDARD LVCMOS33 [get_ports {sys_clk}]

# Audio Codec
# ------------------------------------------------------
# FIXME: This is the zedboard!
#set_property PACKAGE_PIN T17 [get_ports {ac_addr0_clatch}];     # "AC-ADR0"  SPI_SD_SS
set_property PACKAGE_PIN AB1 [get_ports ac_addr0_clatch]
set_property IOSTANDARD LVCMOS33 [get_ports ac_addr0_clatch]
#set_property PACKAGE_PIN AA9  [get_ports {ac_addr1_cdata}];      # "AC-ADR1" JA4
set_property PACKAGE_PIN Y5 [get_ports ac_addr1_cdata]
set_property IOSTANDARD LVCMOS33 [get_ports ac_addr1_cdata]
#set_property PACKAGE_PIN B20 [get_ports {ac_dac_sdata}];        # "AC-GPIO0" LA17_CC_N
#set_property PACKAGE_PIN AB11 [get_ports {ac_dac_sdata}];        # "AC-GPIO0" JA7 Temporary
set_property PACKAGE_PIN Y8 [get_ports ac_dac_sdata]
set_property IOSTANDARD LVCMOS33 [get_ports ac_dac_sdata]
#set_property PACKAGE_PIN N20 [get_ports {ac_bclk}];             # "AC-GPIO2"  I2S_SCLK   LA01_N_CC
set_property PACKAGE_PIN AA6 [get_ports ac_bclk]
set_property IOSTANDARD LVCMOS33 [get_ports ac_bclk]
#set_property PACKAGE_PIN B19  [get_ports {ac_lrclk}];            # "AC-GPIO3" I2S_LRCLK   LA17_P_CC
set_property PACKAGE_PIN Y6 [get_ports ac_lrclk]
set_property IOSTANDARD LVCMOS33 [get_ports ac_lrclk]
#set_property PACKAGE_PIN N19 [get_ports {ac_mclk}];             # "AC-MCLK"  LA01_P_CC
set_property PACKAGE_PIN AB2 [get_ports ac_mclk]
set_property IOSTANDARD LVCMOS33 [get_ports ac_mclk]
#set_property PACKAGE_PIN AA7 [get_ports {ac_adc_sdata}];       # "AC-GPIO1"
#set_property IOSTANDARD LVCMOS33 [get_ports {ac_adc_sdata}];
#set_property PACKAGE_PIN AB5 [get_ports {iic_rtl_sda_io}];     # "AC-SDA"
#set_property IOSTANDARD LVCMOS33 [get_ports {iic_rtl_sda_io}];
set_property PACKAGE_PIN AB4 [get_ports ac_scl_cclk]
set_property IOSTANDARD LVCMOS33 [get_ports ac_scl_cclk]

# These are on the extension board:
# LA01_CC_P, Bank 34
#set_property PACKAGE_PIN N19 [get_ports ac_mclk]
#set_property IOSTANDARD LVCMOS33 [get_ports ac_mclk]
# LA01_CC_N, Bank 34
#set_property PACKAGE_PIN N20 [get_ports ac_bclk]
#set_property IOSTANDARD LVCMOS33 [get_ports ac_bclk]
# LA17_CC_P, Bank 35
#set_property PACKAGE_PIN B19 [get_ports ac_lrclk]
#set_property IOSTANDARD LVCMOS33 [get_ports ac_lrclk]
# LA17_CC_N, Bank 35
#set_property PACKAGE_PIN B20 [get_ports ac_dac_sdata]
#set_property IOSTANDARD LVCMOS33 [get_ports ac_dac_sdata]

# GPIO
# ------------------------------------------------------
# GPIO2, LA03_N, Bank 34
set_property PACKAGE_PIN P22 [get_ports {gpio_o[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[0]}]
# GPIO3, LA03_P, Bank 34
set_property PACKAGE_PIN N22 [get_ports {gpio_o[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[1]}]
# GPIO0, LA19_P, Bank 35
set_property PACKAGE_PIN G15 [get_ports {gpio_i[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_i[0]}]
# GPIO1, LA19_N, Bank 35
set_property PACKAGE_PIN G16 [get_ports {gpio_i[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_i[1]}]

# PWM LED
# ------------------------------------------------------
# LA21_P, Bank 35
set_property PACKAGE_PIN E19 [get_ports {pwm_led}]
set_property IOSTANDARD LVCMOS33 [get_ports {pwm_led}]

# QSPI / XIP
# ------------------------------------------------------
# QSPI_Q0 (FLASH DI), LA20_P, Bank 35
set_property PACKAGE_PIN G20 [get_ports {xip_sdo_o}]
set_property IOSTANDARD LVCMOS33 [get_ports {xip_sdo_o}]
# QSPI_Q1 (FLASH DO), LA20_N, Bank 35
set_property PACKAGE_PIN G21 [get_ports {xip_sdi_i}]
set_property IOSTANDARD LVCMOS33 [get_ports {xip_sdi_i}]
# QSPI_Q2, LA12_P, Bank 34
set_property PACKAGE_PIN P20 [get_ports {xip_q2}]
set_property IOSTANDARD LVCMOS33 [get_ports {xip_q2}]
# QSPI_Q3, LA12_N, Bank 34
set_property PACKAGE_PIN P21 [get_ports {xip_q3}]
set_property IOSTANDARD LVCMOS33 [get_ports {xip_q3}]
# QSPI_SCK, LA00_CC_P, Bank 34
set_property PACKAGE_PIN M19 [get_ports {xip_clk_o}]
set_property IOSTANDARD LVCMOS33 [get_ports {xip_clk_o}]

# QSPI_SS, LA30_P, Bank 35
#set_property PACKAGE_PIN C15 [get_ports {xip_csn_o}]
#set_property IOSTANDARD LVCMOS33 [get_ports {xip_csn_o}]
# FIXME PMOD
set_property PACKAGE_PIN AA9 [get_ports {xip_csn_o}]
set_property IOSTANDARD LVCMOS33 [get_ports {xip_csn_o}]

# UART
# ------------------------------------------------------
# UART_TX, LA02_P, Bank 35
set_property PACKAGE_PIN P17 [get_ports uart0_rxd_i];
set_property IOSTANDARD LVCMOS33 [get_ports uart0_rxd_i]
# UART_RX, LA02_N, Bank 35
set_property PACKAGE_PIN P18 [get_ports uart0_txd_o];
set_property IOSTANDARD LVCMOS33 [get_ports uart0_txd_o]

# I2C
# ------------------------------------------------------
# I2C_SCL, I2C_SCL_F, FMC-SCL, Bank 13
set_property PACKAGE_PIN R7 [get_ports i2c_scl];
set_property IOSTANDARD LVCMOS33 [get_ports i2c_scl]
# I2C_SDA, I2C_SDA_F, FMC-SDA, Bank 13
set_property PACKAGE_PIN U7 [get_ports i2c_sda];
set_property IOSTANDARD LVCMOS33 [get_ports i2c_sda]

# Buttons
# ------------------------------------------------------
# GPIO_BTNA, LA30_N, Bank 35
set_property PACKAGE_PIN B15 [get_ports btn_l];
set_property IOSTANDARD LVCMOS33 [get_ports btn_l]
# GPIO_BTNB, LA22_N, Bank 35
set_property PACKAGE_PIN F19 [get_ports btn_u];
set_property IOSTANDARD LVCMOS33 [get_ports btn_u]
# GPIO_BTNC, LA25_P, Bank 35
set_property PACKAGE_PIN D22 [get_ports btn_d];
set_property IOSTANDARD LVCMOS33 [get_ports btn_d]
# GPIO_BTND, LA22_P, Bank 35
set_property PACKAGE_PIN G19 [get_ports btn_r];
set_property IOSTANDARD LVCMOS33 [get_ports btn_r]
# GPIO_BTNCE, LA25_N, Bank 13
set_property PACKAGE_PIN C22 [get_ports btn_c];
set_property IOSTANDARD LVCMOS33 [get_ports btn_c]

# SPI
# ------------------------------------------------------
# SPI_MISO, LA10_P, Bank 34
set_property PACKAGE_PIN R19 [get_ports spi_miso];
set_property IOSTANDARD LVCMOS33 [get_ports spi_miso]
# SPI_MOSI, LA10_N, Bank 34
set_property PACKAGE_PIN T19 [get_ports spi_mosi];
set_property IOSTANDARD LVCMOS33 [get_ports spi_mosi]
# SPI_SCK, LA14_N, Bank 34
set_property PACKAGE_PIN K20 [get_ports spi_clk];
set_property IOSTANDARD LVCMOS33 [get_ports spi_clk]
# SPI_SD_SS, LA21_N, Bank 35
set_property PACKAGE_PIN E20 [get_ports spi_sd_ss];
set_property IOSTANDARD LVCMOS33 [get_ports spi_sd_ss]
# SPI_03_SS, LA04_P, Bank 34
set_property PACKAGE_PIN M21 [get_ports spi_flash_ss];
set_property IOSTANDARD LVCMOS33 [get_ports spi_flash_ss]
# SPI_04_SS, LA04_N, Bank 34
set_property PACKAGE_PIN M22 [get_ports spi_flash_ss];
set_property IOSTANDARD LVCMOS33 [get_ports spi_flash_ss]