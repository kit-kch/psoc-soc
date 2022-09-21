proc innovus_2_1_preplace args {

	createBasicPathGroups -expanded
	setPathGroupOptions reg2out -effortLevel high

	## Set Routing parameters so that the trial route based placement runs with correct parameters
	innovus_4_set_route_mode
	innovus_4_set_mode_bcwc
	innovus_3_1_setup
	setExtractRCMode -engine preroute

	setRouteMode -reset
	setRouteMode -earlyGlobalMinRouteLayer 2
	setRouteMode -earlyGlobalMaxRouteLayer 5

}

proc innovus_2_2_place args {

	## 02/2020 Richard: Updated to newest "place_design" and "place_opt_design" commands
	## This improves results and speed
	## Also the Trial Route mode is not supported anymode, switching to setRouteMode with "early" parameters switches


	# Place the Design with the following command
	# Lots of placement options can be set by means of the setPlaceMode command
	# before executing the placeDesign command
	# the inPlaceOpt switch turns on the optDesign with -preCTS
	#read_activity_file -format TCF -tcf_scope dcd_b_digital_block_full_sim_digital_top/dut_I ./power_intent/dcd_b_digital_block_togglecount.tcf
	#setPlaceMode -powerDriven true -maxRouteLayer 4 -wireLenOptEffort high

	setDesignMode -earlyClockFlow true
	setPlaceMode -reset
	setPlaceMode -timingDriven true -wireLenOptEffort high -congEffort high
	setPlaceMode -place_global_activity_power_driven true
	setPlaceMode -place_global_activity_power_driven_effort high

	setOptMode -reset
	setOptMode -allEndPoints true
	setOptMode -fixFanoutLoad true
	setOptMode -usefulSkew true

	## Place
	place_design

	# #Add ties
	innovus_2_addTieHighLow
	
	## Optimize
	optDesign -preCTS
	optDesign -preCTS -incr

	## Time Design
	######################
	if {[dbGet top.statusRouted]      == 0} {trialRoute}
	if {[dbGet top.statusRCExtracted] == 0} {extractRC}
	exec mkdir -p reports/timing/
	timeDesign -reportOnly -expandedViews -outDir reports/timing/  -numPaths 100 -prefix placed
    timeDesign -reportOnly -expandedViews -outDir reports/timing/  -numPaths 100 -prefix placed -hold
    
	## Report
	checkPlace > reports/checkPlace.rpt

}

proc innovus_2_addTieHighLow args {

	global STD_CELLS

	setTieHiLoMode -cell $STD_CELLS(physical/tie)
	addTieHiLo

}

proc innovus_2_3_save { } {

	#Save the design state after the cell placement
	saveDesign savings/save02_placed.enc

    timeDesign -reportOnly -expandedViews -prefix placed
    timeDesign -reportOnly -expandedViews -prefix placed -hold
}
