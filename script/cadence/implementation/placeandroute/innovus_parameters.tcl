## Design Parameters and configs
#########################

#Base from environment
set BASE $::env(BASE)


set sourcesFolder $BASE/src/hdl/

## Load the AMSH18 helper script
## This script produces a TCL array with required technology files sorted by type so they can be used later on
source $::env(BASE)/script/cadence/common/ams_h18/std_cells.tcl

## Location of the current script
set location [file dirname [file normalize [info script]]]
set parametersScript [file normalize [info script]]

## Call this command in innovus to reload all the scripts when something was changed
proc reload_parameters args {
	uplevel {source $parametersScript}
}

set top_module	encoder_top


## we are saving the Standard Cells library and corner names in variables to make the script easier to read
set cell_lib            CORELIB_HV
set cell_corner_slow    ah18_1.8V/WC
set cell_corner_fast    ah18_1.8V/BC
set selected_metal      a6


## Cells to use and not to use
#############
set clockbuffer_cells   {CLKBUFX2_HV CLKBUFX4_HV CLKBUFX6_HV}
set clockinverter_cells {CLKINVX2_HV CLKINVX4_HV CLKINVX6_HV} 
set clockgating_cells   {}

set TIE_CELLS {TIE0_HV TIE1_HV}
set ANTENNA_CELL ANTENNA_HV
set filler_cells {FILL1_HV_9T FILL2_HV_9T}

## Flow Stage: This variable to PR for "Place and Route" to differentiate from synthesis
set implStage "PR"

puts "(I) Flow Stage: $implStage"

#########################
## Load all steps
#############################
foreach script [glob -types f $location/innovus_\[0-9\]*.tcl] {
	source $script
}

## Make utility steps
## These commands can be used/changed to execute multiple steps after each other
################
proc flow_sub_plan args {
	innovus_1_1_floorplan
	innovus_1_2_placepins
	innovus_1_3_power_plan

}


proc flow_sub_place args {

	innovus_2_1_preplace
	innovus_2_2_place
	innovus_2_3_save
}

proc flow_sub_cts args {
	innovus_3_1_setup
	innovus_3_2_CTS
	innovus_3_3_postCTS
}

proc flow_sub_route args {

	innovus_4_set_route_mode
	innovus_4_set_si_extract
	innovus_4_1_route
	innovus_4_2_optDesign
	#step_utils_ecoFixDRC

}

proc flow_sub_streamout args {
	innovus_5_1_addFillers
	innovus_5_2_signoff
	innovus_5_3_streamout

}


proc flow_signoff args {

	flow_sub_plan
	flow_sub_place
	flow_sub_cts
	flow_sub_route
	flow_sub_streamout
	step_utils_verify
}

##############

