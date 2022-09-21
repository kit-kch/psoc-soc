set sdc_version 1.4



########################################################################################
#
#       Clocks
#
########################################################################################

#Define functional clock


#100MHz
create_clock -name clk-add -period 100 -waveform {0.0 50} [get_ports clk]





set_clock_uncertainty -setup 0.010 clk
set_clock_uncertainty -hold  0.040 clk






########################################################################################
#
#       Input Delays
#
########################################################################################

#Sets the input delay of 2ns for the signals that are sampled into the clock_slow domain Ivan 5


set_input_transition 0.2 [all_inputs]



########################################################################################
#
#       Capacitive Loads
#
########################################################################################


#Sets the output capacity to 100fF on all outputs
set_load 0.1 [all_outputs]




########################################################################################
#
#       Output Delays
#
########################################################################################

set_max_transition 0.5  [all_outputs]

#set_output_delay -clock clk 0.01 [all_outputs]




#Set the output delay for the ADC control signals to 2 ns Jochen clk_fsm Ivan clk_slow
#note the time given is the time window to next clk change here could be 19ns for hard constrain




########################################################################################
#
#       Multi Cycle Paths
#
########################################################################################




########################################################################################
#
#       Other Stuff
#
########################################################################################

