set sdc_version 1.4



########################################################################################
#
#       Clocks
#
########################################################################################

#Define functional clock


#400
#create_clock -name clk_800p -add -period 2.5 -waveform {0.0 1.25} [get_ports clk_800p]

#1.6GHz
create_clock -name clk_800p -add -period 1.25 -waveform {0.0 0.625} [get_ports clk_800p]


create_clock -name clkIn_4n -add -period 6.25 -waveform {0.0 3.125} [get_ports clkIn_4n]
create_generated_clock -source clkIn_4n -name clk_8n -divide_by 2 [get_pins {SerializerTop_I/SerializerMain_I/Cnt4_reg[0]/q}]


#create_clock -name clkIn_4n -add -period 5.0 -waveform {0.0 2.5} [get_pins {SerializerTop_I/ClockGen_I/FastCnt5_reg[2]/Q}]

#create_generated_clock -source clk_800p -name clkIn_4n -divide_by 5 [get_pins {SerializerTop_I/ClockGen_I/FastCnt5_reg[2]/Q}]

create_generated_clock -source clk_800p -name clk_3n2 -divide_by 4 [get_pins {SerializerTop_I/ClockGen_I/FastCnt4_reg[1]/q}]

#create_generated_clock -source clk_800p -name clk_8n -divide_by 10 [get_pins {SerializerTop_I/SerializerMain_I/Cnt4_reg[0]/q}]

create_generated_clock -source clk_800p -name clk_1n6 -divide_by 2 [get_pins {SerializerTop_I/ClockGen_I/clkOut_1n6_reg/q}]


set_clock_uncertainty -setup 0.010 clk_800p
set_clock_uncertainty -hold  0.050 clk_800p

set_clock_uncertainty -setup 0.010 clk_1n6
set_clock_uncertainty -hold  0.050 clk_1n6

set_clock_uncertainty -setup 0.080 clkIn_4n
set_clock_uncertainty -hold  0.080 clkIn_4n

set_clock_uncertainty -setup 0.080 clk_3n2
set_clock_uncertainty -hold  0.080 clk_3n2

set_clock_uncertainty -setup 0.080 clk_8n
set_clock_uncertainty -hold  0.080 clk_8n




#old
#set_clock_transition -rise 0.200 [get_clocks clk]
#set_clock_transition -fall 0.200 [get_clocks clk]
#set_clock_transition -rise 0.400 [get_clocks clk_slow]
#set_clock_transition -fall 0.400 [get_clocks clk_slow]

#set_max_transition 1 -clock_path [clk]
#set_max_capacitance 1 -clock_path [clk]

#set_max_capacitance 0.02 [get_ports {clk_slow}]
#set_max_fanout 1.0 [get_ports *]

########################################################################################
#
#       Input Delays
#
########################################################################################

#Sets the input delay of 2ns for the signals that are sampled into the clock_slow domain Ivan 5


set_input_delay -clock clk_8n 2.0 [get_ports {RowAddFromDet*}]
set_input_delay -clock clk_8n 2.0 [get_ports {ColAddFromDet*}]
set_input_delay -clock clk_8n 2.0 [get_ports {TSFromDet*}]
set_input_delay -clock clk_8n 2.0 [get_ports {PriFromDet}]
set_input_delay -network_latency_included -clock clk_8n 2.0 [get_ports {syncRes}]

set_input_delay -clock clk_800p 0.1 [get_ports {data_valid}]


set_input_delay -clock clk_8n 2.0 [get_ports {ckdivend*}]
set_input_delay -clock clk_8n 2.0 [get_ports {timerend*}]
set_input_delay -clock clk_8n 2.0 [get_ports {slowdownend*}]
set_input_delay -clock clk_8n 2.0 [get_ports {maxcycend*}]

set_input_transition 0.2 [all_inputs]



########################################################################################
#
#       Capacitive Loads
#
########################################################################################


#Sets the output capacity to 300fF on all outputs
set_load 0.3 [all_outputs]
#Overwrites the output capacity with 10fF for all outputs that go to pads Jochen 10 Ivan 20
set_load 0.02 [get_ports {d_out* data_stop}]



########################################################################################
#
#       Output Delays
#
########################################################################################

set_max_transition 0.5 [get_ports {clkOut_4n}]
set_output_delay -clock clk_800p 0.0 [get_ports {clkOut_4n}]

set_max_transition 0.5 [get_ports {d_out*}]

#was -0.5

#set_output_delay -clock clk_800p 0.0 [get_ports {d_out*}]

#Set the output delay for the ADC control signals to 2 ns Jochen clk_fsm Ivan clk_slow
#note the time given is the time window to next clk change here could be 19ns for hard constrain

set_output_delay -clock clk_8n 2.0 [get_ports {TSToDet*}]
set_output_delay -clock clk_8n 2.0 [get_ports {LdCol}]
set_output_delay -clock clk_8n 2.0 [get_ports {RdCol}]
set_output_delay -clock clk_8n 2.0 [get_ports {LdPix}]
set_output_delay -clock clk_8n 2.0 [get_ports {PullDN}]


########################################################################################
#
#       Multi Cycle Paths
#
########################################################################################

#Set multi cycle path for all pedestal signals that go the the ADCs
#set_multicycle_path 2 -through [get_ports {pedestals_out*}]

#relaxing of conditions

set_false_path -from [get_clocks clkIn_4n] -to [get_clocks clk_800p]
set_false_path -from [get_clocks clkIn_4n] -to [get_clocks clk_3n2]

#set_false_path -from [get_clocks clk_slow] -to [get_clocks clk]


set_clock_groups -asynchronous  -name asynch_clock -group {clkIn_4n} -group {clk_800p} 


#this is good
set_false_path -from SerializerTop_I/SerializerMain_I/TenToEight_reg* -to SerializerTop_I/SerializerMain_I/Tree1R_reg*
set_false_path -from SerializerTop_I/SerializerMain_I/TenToEight_reg* -to SerializerTop_I/SerializerMain_I/Tree1L_reg*

#this is good
#set_false_path -from [get_pins SerializerTop_I/SerializerMain_I/TenToEight_reg*/q] -to [get_pins SerializerTop_I/SerializerMain_I/Tree1R_reg*/d]


#for deserializer: (fast to slow)

#for setup: the destination latch edge (setup edge) is delayed by N-1 source ck period (clk period) with respect to worst case (source edge)
#this removed 14
#set_multicycle_path 2 -start -setup -from [get_clocks clk] -to [get_clocks clk_slow]

#for hold: the destination latch edge (hold edge) is shifted by N+1 source ck period (clk period) in past with respect to setup edge
#for hold: if hold violation try 2
#this removed 14 
#set_multicycle_path 1 -start -hold -from [get_clocks clk] -to [get_clocks clk_slow]

#for serializer (slow to fast)

#for setup: the destination latch edge (setup edge) is delayed by N-1 DESTINATION ck period (clk period) with respect to worst case (source edge)
#this removed 14 
#set_multicycle_path 2 -end -setup -from [get_clocks clk_slow] -to [get_clocks clk]

#for hold: the destination latch edge (hold edge) is shifted by N+1 DESTINATION ck period (clk period) in past with respect respect to setup edge
#for hold: if hold violation try 2
#this removed 14 
#set_multicycle_path 1 -end -hold -from [get_clocks clk_slow] -to [get_clocks clk]


########################################################################################
#
#       Other Stuff
#
########################################################################################

set_propagated_clock [all_clocks]  
