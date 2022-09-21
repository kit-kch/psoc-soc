set location [file dirname [file normalize [info script]]]

source $location/innovus_parameters.tcl

innovus_0_0_load_design
flow_fullroute
#flow_signoff