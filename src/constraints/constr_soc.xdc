# Clock Oscillator
# ------------------------------------------------------
# CLK0_M2C_P, Bank 34
set_property PACKAGE_PIN L18 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# Audio Codec
# ------------------------------------------------------
# LA01_CC_P, Bank 34
set_property PACKAGE_PIN N19 [get_ports i2s_mclk]
set_property IOSTANDARD LVCMOS33 [get_ports i2s_mclk]
# LA01_CC_N, Bank 34
set_property PACKAGE_PIN N20 [get_ports i2s_sclk]
set_property IOSTANDARD LVCMOS33 [get_ports i2s_sclk]
# LA17_CC_P, Bank 35
set_property PACKAGE_PIN B19 [get_ports i2s_lrclk]
set_property IOSTANDARD LVCMOS33 [get_ports i2s_lrclk]
# LA17_CC_N, Bank 35
set_property PACKAGE_PIN B20 [get_ports i2s_sdata]
set_property IOSTANDARD LVCMOS33 [get_ports i2s_sdata]

# JTAG
# ------------------------------------------------------
# LA14_P, Bank 34
set_property PACKAGE_PIN K19 [get_ports jtag_trst_i]
set_property IOSTANDARD LVCMOS33 [get_ports jtag_trst_i]
# LA06_P, Bank 34
set_property PACKAGE_PIN L21 [get_ports jtag_tck_i]
set_property IOSTANDARD LVCMOS33 [get_ports jtag_tck_i]
# LA06_N, Bank 34
set_property PACKAGE_PIN L22 [get_ports jtag_tdi_i]
set_property IOSTANDARD LVCMOS33 [get_ports jtag_tdi_i]
# LA26_N, Bank 35
set_property PACKAGE_PIN E18 [get_ports jtag_tdo_o]
set_property IOSTANDARD LVCMOS33 [get_ports jtag_tdo_o]
# LA26_P, Bank 35
set_property PACKAGE_PIN F18 [get_ports jtag_tms_i]
set_property IOSTANDARD LVCMOS33 [get_ports jtag_tms_i]

# GPIO
# ------------------------------------------------------
# GPIO2, LA03_N, Bank 34
set_property PACKAGE_PIN P22 [get_ports {gpio_o[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[0]}]
# GPIO3, LA03_P, Bank 34
set_property PACKAGE_PIN N22 [get_ports {gpio_o[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[1]}]
# GPIO0, LA19_P, Bank 35
set_property PACKAGE_PIN G15 [get_ports gpio_i]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_i]
# GPIO1, LA19_N, Bank 35
set_property PACKAGE_PIN G16 [get_ports arstn]
set_property IOSTANDARD LVCMOS33 [get_ports arstn]

# PWM LED
# ------------------------------------------------------
# LA21_P, Bank 35
set_property PACKAGE_PIN E19 [get_ports pwm_led]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_led]

# QSPI / XIP
# ------------------------------------------------------
# QSPI_Q0 (FLASH DI), LA20_P, Bank 35
set_property PACKAGE_PIN G20 [get_ports xip_sdo_o]
set_property IOSTANDARD LVCMOS33 [get_ports xip_sdo_o]
# QSPI_Q1 (FLASH DO), LA20_N, Bank 35
set_property PACKAGE_PIN G21 [get_ports xip_sdi_i]
set_property IOSTANDARD LVCMOS33 [get_ports xip_sdi_i]
# QSPI_Q2, LA12_P, Bank 34
set_property PACKAGE_PIN P20 [get_ports xip_q2]
set_property IOSTANDARD LVCMOS33 [get_ports xip_q2]
# QSPI_Q3, LA12_N, Bank 34
set_property PACKAGE_PIN P21 [get_ports xip_q3]
set_property IOSTANDARD LVCMOS33 [get_ports xip_q3]
# QSPI_SCK, LA00_CC_P, Bank 34
set_property PACKAGE_PIN M19 [get_ports xip_clk_o]
set_property IOSTANDARD LVCMOS33 [get_ports xip_clk_o]

# QSPI_SS, LA30_P, Bank 35
set_property PACKAGE_PIN C15 [get_ports {xip_csn_o}]
set_property IOSTANDARD LVCMOS33 [get_ports {xip_csn_o}]

# UART
# ------------------------------------------------------
# UART_TX, LA02_P, Bank 35
set_property PACKAGE_PIN P17 [get_ports uart0_rxd_i]
set_property IOSTANDARD LVCMOS33 [get_ports uart0_rxd_i]
# UART_RX, LA02_N, Bank 35
set_property PACKAGE_PIN P18 [get_ports uart0_txd_o]
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
set_property PACKAGE_PIN B15 [get_ports btn_l]
set_property IOSTANDARD LVCMOS33 [get_ports btn_l]
# GPIO_BTNB, LA22_N, Bank 35
set_property PACKAGE_PIN F19 [get_ports btn_u]
set_property IOSTANDARD LVCMOS33 [get_ports btn_u]
# GPIO_BTNC, LA25_P, Bank 35
set_property PACKAGE_PIN D22 [get_ports btn_d]
set_property IOSTANDARD LVCMOS33 [get_ports btn_d]
# GPIO_BTND, LA22_P, Bank 35
set_property PACKAGE_PIN G19 [get_ports btn_r]
set_property IOSTANDARD LVCMOS33 [get_ports btn_r]
# GPIO_BTNCE, LA25_N, Bank 13
set_property PACKAGE_PIN C22 [get_ports btn_c]
set_property IOSTANDARD LVCMOS33 [get_ports btn_c]

# SPI
# ------------------------------------------------------
# SPI_SCK, LA14_N, Bank 34
set_property PACKAGE_PIN K20 [get_ports spi_sck_o]
set_property IOSTANDARD LVCMOS33 [get_ports spi_sck_o]
# SPI_MOSI, LA10_N, Bank 34
set_property PACKAGE_PIN T19 [get_ports spi_sdo_o]
set_property IOSTANDARD LVCMOS33 [get_ports spi_sdo_o]
# SPI_MISO, LA10_P, Bank 34
set_property PACKAGE_PIN R19 [get_ports spi_sdi_i]
set_property IOSTANDARD LVCMOS33 [get_ports spi_sdi_i]
# SPI_SD_SS, LA21_N, Bank 35
set_property PACKAGE_PIN E20 [get_ports spi_ss_sd]
set_property IOSTANDARD LVCMOS33 [get_ports spi_ss_sd]
# SPI_03_SS, LA04_P, Bank 34
set_property PACKAGE_PIN M21 [get_ports spi_ss_2]
set_property IOSTANDARD LVCMOS33 [get_ports spi_ss_2]
# SPI_04_SS, LA04_N, Bank 34
set_property PACKAGE_PIN M22 [get_ports spi_ss_3]
set_property IOSTANDARD LVCMOS33 [get_ports spi_ss_3]


# PHONE_L / PHONE_R
# ------------------------------------------------------
# PHONE_L, LA11_P, Bank 34
set_property PACKAGE_PIN N17 [get_ports phone_l]
set_property IOSTANDARD LVCMOS33 [get_ports phone_l]
# PHONE_R, LA11_N, Bank 34
set_property PACKAGE_PIN N18 [get_ports phone_r]
set_property IOSTANDARD LVCMOS33 [get_ports phone_r]


create_clock -period 10.173 -name clk -waveform {0.000 5.087} [get_ports clk]
