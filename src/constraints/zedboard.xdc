# Debug PMOD pins
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN V4 [get_ports {debug[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug[7]}]
set_property PACKAGE_PIN V5 [get_ports {debug[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug[6]}]
set_property PACKAGE_PIN W7 [get_ports {debug[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug[5]}]
set_property PACKAGE_PIN V7 [get_ports {debug[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug[4]}]
set_property PACKAGE_PIN AA4 [get_ports {debug[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug[3]}]
set_property PACKAGE_PIN Y4 [get_ports {debug[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug[2]}]
set_property PACKAGE_PIN AB6 [get_ports {debug[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug[1]}]
set_property PACKAGE_PIN AB7 [get_ports {debug[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug[0]}]

# ----------------------------------------------------------------------------
# Bank 13
# Note that the bank voltage for IO Bank 13 is fixed to 3.3V on ZedBoard.
# ----------------------------------------------------------------------------


# Clock source
# set_property PACKAGE_PIN L18  [get_ports {sys_clk}];
set_property PACKAGE_PIN Y9 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]



# Audio Codec
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



# ----------------------------------------------------------------------------
# Bank 35
# ----------------------------------------------------------------------------

## DIP switches
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



# ----------------------------------------------------------------------------
# Bank 33
# Note that the bank voltage for IO Bank 33 is fixed to 3.3V on ZedBoard.
# ----------------------------------------------------------------------------

# LED outputs
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



# ----------------------------------------------------------------------------
# Bank 34
# ----------------------------------------------------------------------------

# Push buttons

set_property PACKAGE_PIN A18 [get_ports btn_c]
set_property IOSTANDARD LVCMOS33 [get_ports btn_c]
set_property PACKAGE_PIN E20 [get_ports btn_d]
set_property IOSTANDARD LVCMOS33 [get_ports btn_d]
set_property PACKAGE_PIN E19 [get_ports btn_l]
set_property IOSTANDARD LVCMOS33 [get_ports btn_l]
set_property PACKAGE_PIN C22 [get_ports btn_r]
set_property IOSTANDARD LVCMOS33 [get_ports btn_r]
set_property PACKAGE_PIN D22 [get_ports btn_u]
set_property IOSTANDARD LVCMOS33 [get_ports btn_u]

# Clock domain crossing for reset signal
set_false_path -from [get_pins {reset_counter_reg[5]/C}]


# ----------------------------------------------------------------------------
# Bank 35
# NeoRV32
# ----------------------------------------------------------------------------

# GPIO

#set_property PACKAGE_PIN Y11 [get_ports {gpio_o[7]}];
#set_property PACKAGE_PIN AA11 [get_ports {gpio_o[6]}];
#set_property PACKAGE_PIN Y10 [get_ports {gpio_o[5]}];
#set_property PACKAGE_PIN AA9 [get_ports {gpio_o[4]}];
set_property PACKAGE_PIN F19 [get_ports {gpio_o[1]}]
set_property PACKAGE_PIN G19 [get_ports {gpio_o[0]}]
#set_property PACKAGE_PIN G16 [get_ports {gpio_o[1]}];        # LA19_N
#set_property PACKAGE_PIN G15 [get_ports {gpio_o[0]}];        # LA19_P
#set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[7]}];
#set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[6]}];
#set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[5]}];
#set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[4]}];
#set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[3]}];
#set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[2]}];
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[0]}]


## GPIO Temporary

#set_property PACKAGE_PIN AA8 [get_ports {gpio_o[7]}] #JA10
#set_property PACKAGE_PIN AB9 [get_ports {gpio_o[6]}] #JA9
#set_property PACKAGE_PIN AB10 [get_ports {gpio_o[5]}] #JA8
#set_property PACKAGE_PIN AB11 [get_ports {gpio_o[4]}] #JA7
#set_property PACKAGE_PIN LA22_N [get_ports {gpio_o[3]}]
#set_property PACKAGE_PIN LA22_P [get_ports {gpio_o[2]}]
#set_property PACKAGE_PIN AA11 [get_ports {gpio_o[1]}] #JA2
#set_property PACKAGE_PIN Y11 [get_ports {gpio_o[0]}] #JA1

#set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[0]}]

# ----------------------------------------------------------------------------
# Bank 36
# NeoRV32
# ----------------------------------------------------------------------------


# UART
#set_property PACKAGE_PIN P17 [get_ports uart0_rxd_i]; # LA02_N
set_property PACKAGE_PIN V10 [get_ports uart0_rxd_i]
set_property IOSTANDARD LVCMOS33 [get_ports uart0_rxd_i]

#set_property PACKAGE_PIN P18 [get_ports uart0_txd_o]; # LA02_P
set_property PACKAGE_PIN W11 [get_ports uart0_txd_o]
set_property IOSTANDARD LVCMOS33 [get_ports uart0_txd_o]


# ----------------------------------------------------------------------------
# Bank 37
# ----------------------------------------------------------------------------

# CLK

#create_clock -period 8.30 -name sys_clk -waveform {0.000 4.2} [get_ports sys_clk]
create_clock -period 10.000 -name sys_clk -waveform {0.000 5.000} [get_ports sys_clk]


# ----------------------------------------------------------------------------
# Bank 39
# ----------------------------------------------------------------------------

# SPI SD

set_property PACKAGE_PIN M19 [get_ports spi_clk]
#set_property PACKAGE_PIN Y10 [get_ports {spi_clk}];         # SPI_SCK JA3 Temporary
set_property PACKAGE_PIN G20 [get_ports spi_miso]
#set_property PACKAGE_PIN Y11 [get_ports spi_miso];      # SPI_MISO JA1 Temporary
set_property PACKAGE_PIN G21 [get_ports spi_mosi]
#set_property PACKAGE_PIN AA11 [get_ports spi_mosi];      # SPI_MOSI JA2 Temporary
set_property PACKAGE_PIN T17 [get_ports spi_sd_ss]

set_property IOSTANDARD LVCMOS33 [get_ports spi_miso]
set_property IOSTANDARD LVCMOS33 [get_ports spi_mosi]
set_property IOSTANDARD LVCMOS33 [get_ports spi_sd_ss]
set_property IOSTANDARD LVCMOS33 [get_ports spi_clk]

# ----------------------------------------------------------------------------
# Bank 40
# ----------------------------------------------------------------------------

# PWM

set_property PACKAGE_PIN A19 [get_ports pwm_led]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_led]



# ----------------------------------------------------------------------------
# Bank 41
# ----------------------------------------------------------------------------

#RST

set_property PACKAGE_PIN P16 [get_ports btn_rst]
set_property IOSTANDARD LVCMOS33 [get_ports btn_rst]





# ----------------------------------------------------------------------------
# Bank 42
# ----------------------------------------------------------------------------

#SPI_FLASH_SS

set_property PACKAGE_PIN T16 [get_ports spi_flash_ss]
set_property IOSTANDARD LVCMOS33 [get_ports spi_flash_ss]




# ----------------------------------------------------------------------------
# Bank 43
# ----------------------------------------------------------------------------

#I2C

set_property PACKAGE_PIN U7 [get_ports i2c_sda]
set_property PACKAGE_PIN R7 [get_ports i2c_scl]
#set_property PACKAGE_PIN AB10 [get_ports i2c_sda]; #I2C_SDA JA8 Temporary
#set_property PACKAGE_PIN AB9 [get_ports i2c_scl]; #I2C_SCL JA9 Temporary
set_property IOSTANDARD LVCMOS33 [get_ports i2c_sda]
set_property IOSTANDARD LVCMOS33 [get_ports i2c_scl]


create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 32768 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list pll/inst/clk_soc]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 48 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {i2s/audio_data_fifo/din[0]} {i2s/audio_data_fifo/din[1]} {i2s/audio_data_fifo/din[2]} {i2s/audio_data_fifo/din[3]} {i2s/audio_data_fifo/din[4]} {i2s/audio_data_fifo/din[5]} {i2s/audio_data_fifo/din[6]} {i2s/audio_data_fifo/din[7]} {i2s/audio_data_fifo/din[8]} {i2s/audio_data_fifo/din[9]} {i2s/audio_data_fifo/din[10]} {i2s/audio_data_fifo/din[11]} {i2s/audio_data_fifo/din[12]} {i2s/audio_data_fifo/din[13]} {i2s/audio_data_fifo/din[14]} {i2s/audio_data_fifo/din[15]} {i2s/audio_data_fifo/din[16]} {i2s/audio_data_fifo/din[17]} {i2s/audio_data_fifo/din[18]} {i2s/audio_data_fifo/din[19]} {i2s/audio_data_fifo/din[20]} {i2s/audio_data_fifo/din[21]} {i2s/audio_data_fifo/din[22]} {i2s/audio_data_fifo/din[23]} {i2s/audio_data_fifo/din[24]} {i2s/audio_data_fifo/din[25]} {i2s/audio_data_fifo/din[26]} {i2s/audio_data_fifo/din[27]} {i2s/audio_data_fifo/din[28]} {i2s/audio_data_fifo/din[29]} {i2s/audio_data_fifo/din[30]} {i2s/audio_data_fifo/din[31]} {i2s/audio_data_fifo/din[32]} {i2s/audio_data_fifo/din[33]} {i2s/audio_data_fifo/din[34]} {i2s/audio_data_fifo/din[35]} {i2s/audio_data_fifo/din[36]} {i2s/audio_data_fifo/din[37]} {i2s/audio_data_fifo/din[38]} {i2s/audio_data_fifo/din[39]} {i2s/audio_data_fifo/din[40]} {i2s/audio_data_fifo/din[41]} {i2s/audio_data_fifo/din[42]} {i2s/audio_data_fifo/din[43]} {i2s/audio_data_fifo/din[44]} {i2s/audio_data_fifo/din[45]} {i2s/audio_data_fifo/din[46]} {i2s/audio_data_fifo/din[47]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 1 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list i2s/audio_data_fifo/full]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list i2s/audio_data_fifo/wr_en]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_soc]
