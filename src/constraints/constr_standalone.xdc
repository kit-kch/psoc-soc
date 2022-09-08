
# RST button
# ------------------------------------------------------
set_property PACKAGE_PIN P16 [get_ports arst]
set_property IOSTANDARD LVCMOS33 [get_ports arst]

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
set_property PACKAGE_PIN N20 [get_ports i2s_bclk]
set_property IOSTANDARD LVCMOS33 [get_ports i2s_bclk]
# LA17_CC_P, Bank 35
set_property PACKAGE_PIN B19 [get_ports i2s_lrclk]
set_property IOSTANDARD LVCMOS33 [get_ports i2s_lrclk]
# LA17_CC_N, Bank 35
set_property PACKAGE_PIN B20 [get_ports i2s_sdata]
set_property IOSTANDARD LVCMOS33 [get_ports i2s_sdata]

create_clock -period 10.173 -name clk -waveform {0.000 5.0865} [get_ports clk]
# Clock domain crossing for reset signal
set_false_path -from [get_pins arst]
