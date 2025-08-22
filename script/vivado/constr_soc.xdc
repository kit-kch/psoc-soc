# Audio Codec
# ------------------------------------------------------
# LA01_CC_P, Bank 34, i2s_mclk
set_property PACKAGE_PIN N19 [get_ports {pads[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[0]}]
# LA01_CC_N, Bank 34, i2s_sclk
set_property PACKAGE_PIN N20 [get_ports {pads[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[2]}]
# LA17_CC_P, Bank 35, i2s_lrclk
set_property PACKAGE_PIN B19 [get_ports {pads[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[3]}]
# LA17_CC_N, Bank 35. i2s_sdata
set_property PACKAGE_PIN B20 [get_ports {pads[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[1]}]

# JTAG
# ------------------------------------------------------
# LA06_P, Bank 34, jtag_tck
set_property PACKAGE_PIN L21 [get_ports {pads[22]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[22]}]
# LA06_N, Bank 34, jtag_tdi
set_property PACKAGE_PIN L22 [get_ports {pads[23]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[23]}]
# LA26_N, Bank 35, jtag_tdo
set_property PACKAGE_PIN E18 [get_ports {pads[24]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[24]}]
# LA26_P, Bank 35, jtag_tms
set_property PACKAGE_PIN F18 [get_ports {pads[25]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[25]}]

# ARSTN
# ------------------------------------------------------
# GPIO1, LA19_N, Bank 35, arstn
set_property PACKAGE_PIN G16 [get_ports {pads[31]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[31]}]

# QSPI / XIP
# ------------------------------------------------------
# QSPI_Q0 (FLASH DI), LA20_P, Bank 35, xip_sdo
set_property PACKAGE_PIN G20 [get_ports {pads[29]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[29]}]
# QSPI_Q1 (FLASH DO), LA20_N, Bank 35, xip_sid
set_property PACKAGE_PIN G21 [get_ports {pads[28]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[28]}]
# QSPI_Q2, LA12_P, Bank 34
set_property PACKAGE_PIN P20 [get_ports xip_q2]
set_property IOSTANDARD LVCMOS33 [get_ports xip_q2]
# QSPI_Q3, LA12_N, Bank 34
set_property PACKAGE_PIN P21 [get_ports xip_q3]
set_property IOSTANDARD LVCMOS33 [get_ports xip_q3]
# QSPI_SCK, LA00_CC_P, Bank 34, xip_clk
set_property PACKAGE_PIN M19 [get_ports {pads[27]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[27]}]

# QSPI_SS, LA30_P, Bank 35, xip_csn
set_property PACKAGE_PIN C15 [get_ports {pads[26]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[26]}]

# UART
# ------------------------------------------------------
# UART_TX, LA02_P, Bank 35, uart0_rxd
set_property PACKAGE_PIN P17 [get_ports {pads[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[9]}]
# UART_RX, LA02_N, Bank 35, uart0_txd
set_property PACKAGE_PIN P18 [get_ports {pads[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[8]}]

# I2C
# ------------------------------------------------------
# I2C_SCL, I2C_SCL_F, FMC-SCL, Bank 13, i2c_scl
set_property PACKAGE_PIN R7 [get_ports {pads[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[7]}]
# I2C_SDA, I2C_SDA_F, FMC-SDA, Bank 13, i2c_sda
set_property PACKAGE_PIN U7 [get_ports {pads[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[6]}]


# GPIO Buttons (shared with SPI Pins)
# ------------------------------------------------------
# GPIO_BTNA, LA30_N, Bank 35, btn_l/spi_sck
set_property PACKAGE_PIN B15 [get_ports {pads[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[10]}]
# GPIO_BTNB, LA22_N, Bank 35, btn_u/spi_sdo
set_property PACKAGE_PIN F19 [get_ports {pads[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[11]}]
# GPIO_BTNC, LA25_P, Bank 35, btn_d/spi_sdi
set_property PACKAGE_PIN D22 [get_ports {pads[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[12]}]
# GPIO_BTND, LA22_P, Bank 35, btn_r/spi_ss0
set_property PACKAGE_PIN G19 [get_ports {pads[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[13]}]

# LEDs Buttons (shared with PWM Pins)
# ------------------------------------------------------
# GPIO2, LA03_N, Bank 34, d2/pwm0
set_property PACKAGE_PIN P22 [get_ports {pads[20]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[20]}]
# GPIO3, LA03_P, Bank 34, d3/pwm1
set_property PACKAGE_PIN N22 [get_ports {pads[21]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[21]}]

# PHONE_L / PHONE_R
# ------------------------------------------------------
# PHONE_L, LA11_P, Bank 34, audio_l
set_property PACKAGE_PIN N17 [get_ports {pads[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[4]}]
# PHONE_R, LA11_N, Bank 34, audio_r
set_property PACKAGE_PIN N18 [get_ports {pads[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[5]}]


# SD CARD
# ------------------------------------------------------
# SPI_SCK, LA14_N, Bank 34, clk
set_property PACKAGE_PIN K20 [get_ports {pads[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[14]}]
# SPI_MOSI, LA10_N, Bank 34, cmd
set_property PACKAGE_PIN T19 [get_ports {pads[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[15]}]
# SPI_MISO, LA10_P, Bank 34, dat0
set_property PACKAGE_PIN R19 [get_ports {pads[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[16]}]
# SPI_SD_SS, LA21_N, Bank 35, cd/dat3
set_property PACKAGE_PIN E20 [get_ports {pads[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[19]}]

# GPIO_BTNCE, LA25_N, Bank 13, btn_c/spi_ss1
set_property PACKAGE_PIN C22 [get_ports {pads[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[17]}]
# GPIO0, LA19_P, Bank 35, sw3/spi_ss2
set_property PACKAGE_PIN G15 [get_ports {pads[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[18]}]

# Clock Oscillator
# ------------------------------------------------------
# CLK0_M2C_P, Bank 34, clk
set_property PACKAGE_PIN L18 [get_ports {pads[30]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pads[30]}]
create_clock -period 10.173 -name clk -waveform {0.000 5.087} [get_ports {pads[30]}]