##############################
## !! This file is ported to use newest CCOpt clock tree synthesis
## File ported in 02/2020 by Richard.
#################################
proc innovus_3_set_mode args {
	global clockbuffer_cells
	global clockinverter_cells
	global clockgating_cells
	global ANTENNA_CELL

	setExtractRCMode -engine preroute
	setNanoRouteMode -reset
	setNanoRouteMode -routeBottomRoutingLayer 1 \
		-routeTopRoutingLayer 5 \
		-routeWithTimingDriven true

	## Antenna Fix
	setNanoRouteMode -drouteFixAntenna true
	setNanoRouteMode -routeAntennaCellName $ANTENNA_CELL
	setNanoRouteMode  -routeInsertAntennaDiode true

	## Allowed Cells
	#set_ccopt_property buffer_cells 	$clockbuffer_cells
	## Leave empty to force non inverters to be not used
	set_ccopt_property buffer_cells 	$clockbuffer_cells
	set_ccopt_property inverter_cells	$clockinverter_cells
	set_ccopt_property clock_gating_cells $clockgating_cells

	set_ccopt_property use_inverters true

	## Create Non default Route for double spacing double width -non_default_rule $non_default_rule
	set non_default_rule width2x_space2x

	## Create Route Types
	catch {delete_route_type -name leaf_rule}
	create_route_type -name leaf_rule -non_default_rule $non_default_rule    -top_preferred_layer M3 -bottom_preferred_layer M2

	catch {delete_route_type -name trunk_rule}
	create_route_type -name trunk_rule -non_default_rule $non_default_rule 	-top_preferred_layer M4 -bottom_preferred_layer M3 -shield_net GND

	catch {delete_route_type -name top_rule}
	create_route_type -name top_rule  	-top_preferred_layer M4 -bottom_preferred_layer M4 -shield_net GND

	set_ccopt_property -net_type leaf 	route_type leaf_rule
	set_ccopt_property -net_type trunk 	route_type trunk_rule

	# Top Tree routing will be done for large trees only
	set_ccopt_property -net_type top route_type top_rule
	set_ccopt_property  routing_top_min_fanout 10000

}

proc innovus_3_1_setup args {

	#modify_ccopt_skew_group -remove_sinks {SerializerTop_I_ClockGen_I_retime_s1_1_reg/CP} -skew_group {_clock_gen_clk_800p_SerializerTop_I_ClockGen_I_FastCnt4_reg[1]/functional_1n25}

	## First remove clock trees to ease reusing this step when debugging
	#############
	reset_ccopt_config
	delete_ccopt_clock_trees *

	## Set Properties
	##################
	innovus_3_set_mode

	## Create Clock Spec
	####################
	exec mkdir -p cts
	create_ccopt_clock_tree_spec -file cts/ccopt_spec.tcl

	####### New CCOPT ####################
	source cts/ccopt_spec.tcl

}

proc innovus_3_2_CTS args {

	ccopt_design -check_prerequisites

	ccopt_design

	cts_refine_clock_tree_placement

}

proc innovus_3_3_postCTS args {

	setOptMode -reset
	setOptMode -powerEffort low
	setOptMode -usefulSkew true
	setOptMode -usefulSkewCCOpt standard
	setOptMode -fixHoldAllowSetupTnsDegrade true
	setOptMode -enableDataToDataChecks true

	setExtractRCMode -engine preroute

	optDesign -postCTS
	optDesign -postCTS -incr

	optDesign -postCTS -hold
	optDesign -postCTS -hold -incr

	#optDesign -postCTS -incr
	#optDesign -postCTS -hold -incr

	## Time Design
	###############
	exec mkdir -p reports/timing/
	timeDesign 	-postCTS -reportOnly -expandedViews -outDir reports/timing/  -numPaths 100 -prefix cts
	timeDesign 	-postCTS -hold -reportOnly -expandedViews -outDir reports/timing/  -numPaths 100 -prefix cts_hold

	#Save the design state after the CTS
	saveDesign savings/save04_postCTS.enc

}

