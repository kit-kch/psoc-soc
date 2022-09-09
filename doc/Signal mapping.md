Debug connector naming scheme:
- Jx - J7 (left) or J8 (right)
- Ry - Row y
- Pz - Pin z


| Signal | FPGA | FMC | Schematic | Debug connector |
|--------|------|-----|-----------|-----------------|
| System |
| arst | P16 | n/a | n/a | n/a |
| clk | L18 | CLK0_M2C_P | CLK_IN | n/a |
| Audio codec |
| i2s_mclk | N19 | LA01_CC_P | I2S_MCLK | J7 R2 P18 |
| i2s_bclk | N20 | LA01_CC_N | I2S_SCLK | J7 R2 P17 |
| i2s_lrclk | B19 | LA17_CC_P | I2S_LRCLK | J7 R2 P11 |
| i2s_sdata | B20 | LA17_CC_N | I2S_SDIN | J7 R2 P10 |
| Direct audio output |
| nd | N17 | LA11_P | PHONE_L | J8 R1 P12 |
| nd | N18 | LA11_N | PHONE_R | J8 R1 P11 |
| GPIO |
| gpio_i[0] | G15 | LA19_P | GPIO0 | J8 R2 P10 |
| gpio_i[1] | G16 | LA19_N | GPIO1 | J8 R2 P9 |
| gpio_o[0] | P22 | LA03_N | GPIO2 | J8 R2 P15 |
| gpio_o[1] | N22 | LA03_P | GPIO3 | J8 R2 P16 |
| pwm_led | E19 | LA21_P | PWM_LED | J8 R2 P8 |
| Buttons |
| btn_left | B15 | LA30_N | GPIO_BTNA | J8 R2 P3 |
| btn_up | F19 | LA22_N | GPIO_BTNB | J8 R1 P7 |
| btn_down | D22 | LA25_P | GPIO_BTNC | J8 R1 P6 |
| btn_right | G19 | LA22_P | GPIO_BTND | J8 R1 P8 |
| btn_center | C22 | LA25_N | GPIO_BTNCE | J8 R1 P5 |
| Execute in place QSPI |
| xip_sdo_o | G20 | LA20_P | QSPI_Q0 | J8 R1 P10 |
| xip_sdi_i | G21 | LA20_N | QSPI_Q1 | J8 R1 P9 |
| xip_q2 | P20 | LA12_P | QSPI_Q2 | J8 R2 P14 |
| xip_q3 | P21 | LA12_N | QSPI_Q3 | J8 R2 P13 |
| xip_clk_o | M19 | LA00_CC_P | QSPI_SCK | J8 R2 P18 |
| xip_csn_o | C15 | LA30_P | QSPI_nSS | J8 R2 P4 |
| UART |
| uart0_rxd_i | P17 | LA02_P | UART_TX | J8 R1 P16 |
| uart0_txd_o | P18 | LA02_N | UART_RX | J8 R1 P15 |
| I2C |
| i2c_scl | U7 | I2C_SCL_F | I2C_SCL | J7 R1 P3 |
| i2c_sda | R7 | I2C_SDA_F | I2C_SDA | J7 R1 P4 |
| SPI |
| nd | T19 | LA10_N | SPI_MOSI | J7 R1 P12 |
| nd | R19 | LA10_P | SPI_MISO | J7 R1 P11 |
| nd | K20 | LA14_N | SPI_SCK | J7 R1 P10 |
| nd | E20 | LA21_N | SPI_SD_!SS | J8 R2 P7 |
| nd | M21 | LA04_P | SPI_03_!SS | J8 R1 P12 |
| nd | M22 | LA04_N | SPI_04_!SS | J8 R1 P13 |
