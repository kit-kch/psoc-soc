| Signal | FPGA | FMC | Schematic |
|--------|------|-----|-----------|
| System |
| arst | P16 | n/a | n/a |
| clk | L18 | CLK0_M2C_P | CLK_IN |
| Audio codec |
| i2s_mclk | N19 | LA01_CC_P | I2S_MCLK |
| i2s_bclk | N20 | LA01_CC_N | I2S_SCLK |
| i2s_lrclk | B19 | LA17_CC_P | I2S_LRCLK |
| i2s_sdata | B20 | LA17_CC_N | I2S_SDIN |
| GPIO |
| gpio_i[0] | G15 | LA19_P | GPIO0 |
| gpio_i[1] | G16 | LA19_N | GPIO1 |
| gpio_o[0] | P22 | LA03_N | GPIO2 |
| gpio_o[1] | N22 | LA03_P | GPIO3 |
| pwm_led | E19 | LA21_P | PWM_LED |
| Execute in place QSPI |
| xip_sdo_o | G20 | LA20_P | QSPI_Q0 |
| xip_sdi_i | G21 | LA20_N | QSPI_Q1 |
| xip_q2 | P20 | LA12_P | QSPI_Q2 |
| xip_q3 | P21 | LA12_N | QSPI_Q3 |
| xip_clk_o | M19 | LA00_CC_P | QSPI_SCK |
| xip_csn_o | C15 | LA30_P | QSPI_nSS |
| UART |
| uart0_rxd_i | P17 | LA02_P | UART_TX |
| uart0_txd_o | P18 | LA02_N | UART_RX |
| I2C |
| i2c_scl | U7 | I2C_SCL_F | I2C_SCL |
| i2c_sda | R7 | I2C_SDA_F | I2C_SDA |
