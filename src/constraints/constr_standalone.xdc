# Clock Oscillator
# ------------------------------------------------------
# CLK0_M2C_P, Bank 34
set_property PACKAGE_PIN L18 [get_ports clk];
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

# GPIO
# ------------------------------------------------------
# GPIO2, LA03_N, Bank 34
set_property PACKAGE_PIN P22 [get_ports {gpio_o[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[0]}]
# GPIO3, LA03_P, Bank 34
set_property PACKAGE_PIN N22 [get_ports {gpio_o[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[1]}]
# GPIO1, LA19_N, Bank 35
set_property PACKAGE_PIN G16 [get_ports arstn]
set_property IOSTANDARD LVCMOS33 [get_ports arstn]

create_clock -period 10.173 -name clk -waveform {0.000 5.087} [get_ports clk]