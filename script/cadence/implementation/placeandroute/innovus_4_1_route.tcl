proc innovus_4_set_route_mode args {

	global ANTENNA_CELL

	## Route from 2 to 4
	setExtractRCMode -engine preroute
	setNanoRouteMode -routeBottomRoutingLayer 1 \
		-routeTopRoutingLayer 4 \
		-routeWithTimingDriven true \
		-routeWithSiDriven true  \
		-routeWithViaInPin true \
		-routeWithViaOnlyForStandardCellPin 1:1 \
		-drouteUseMultiCutViaEffort high
		
	setNanoRouteMode -routeEnforceNdrOnSpecialNetWire true
	setNanoRouteMode -droutePostRouteSwapVia multiCut
	#setNanoRouteMode -droutePostRouteLithoRepair true

	## Antenna Fix
	setNanoRouteMode -drouteFixAntenna true
	setNanoRouteMode -routeAntennaCellName $ANTENNA_CELL
	setNanoRouteMode -routeInsertAntennaDiode true
	setNanoRouteMode -routeInsertDiodeForClockNets true
	#setDesignEffort high

	setOptMode -reset
	setOptMode -fixDrc true
	setOptMode -powerEffort high
	setOptMode -usefulSkewCCOpt standard
	setOptMode -usefulSkewPostRoute true
	setOptMode -enableDataToDataChecks true
	setOptMode -fixHoldAllowResizing true
	setOptMode -fixClockDrv true

}

proc innovus_4_set_mode_bcwc args {
	
	## No SI Aware to optimise without OCV
	setDelayCalMode -reset
	setDelayCalMode -SIAware false
	
	setAnalysisMode -reset

	setExtractRCMode -reset
	setExtractRCMode -engine postRoute -coupled true


	#setAnalysisMode -analysisType onChipVariation -skew true  -clockPropagation sdcControl -cppr both  -timingSelfLoopsNoSkew false
	#-usefulSkew true  -timingSelfLoopsNoSkew true
	## Makes paths pessimistic by accelerating early paths...removes clock quicker so setup is worst and hold too
	#set_timing_derate -delay_corner slowHTrcw -late 1 -early 0.9 -clock 
	
	
	setAnalysisMode -analysisType bcwc -skew true  -clockPropagation sdcControl -cppr both 
	set_timing_derate -delay_corner slowHTrcw -late 1 -early 0.8 -clock 
	
	setOptMode -reset
	setOptMode -fixFanoutLoad true
	setOptMode -fixDrc true
	setOptMode -powerEffort high
	setOptMode -fixHoldAllowSetupTnsDegrade true
	setOptMode -fixClockDrv true
	
	## Submission last fix
	setOptMode -fixHoldAllowResizing true
	
	setOptMode -enableDataToDataChecks true

	setOptMode -postRouteAreaReclaim  holdAndSetupAware
	
	## Changed to standard
	setOptMode -usefulSkewCCOpt standard
	
	setOptMode -usefulSkewPostRoute true
}


proc innovus_4_set_si_extract args {
	
	## No SI Aware to optimise without OCV
	setDelayCalMode -reset
	setDelayCalMode -SIAware true
	
	setAnalysisMode -reset

	setExtractRCMode -reset
	setExtractRCMode -engine postRoute -coupled true


	setAnalysisMode -analysisType onChipVariation -skew true  -clockPropagation sdcControl -cppr both
	set_timing_derate -delay_corner slowHTrcw -late 1 -early 0.8 -clock 
	#-usefulSkew true  -timingSelfLoopsNoSkew true
	## Makes paths pessimistic by accelerating early paths...removes clock quicker so setup is worst and hold too
	#set_timing_derate -delay_corner slowHTrcw -late 1 -early 0.9 -clock 
	
	
	
	
	
	setOptMode -reset
	setOptMode -fixFanoutLoad true
	setOptMode -fixDrc true
	setOptMode -powerEffort high
	setOptMode -fixHoldAllowSetupTnsDegrade true
	
	## Submission last fix
	setOptMode -fixHoldAllowResizing false
	
	setOptMode -enableDataToDataChecks true

	setOptMode -postRouteAreaReclaim  holdAndSetupAware
	
	## Changed to standard
	setOptMode -usefulSkewCCOpt standard
	
	setOptMode -usefulSkewPostRoute false
}
proc innovus_4_1_route args {

	global ANTENNA_CELL

	innovus_4_set_route_mode

	# we get no multi-cuts without this command, but a SEGV with it...
	generateVias

	#The new preferred routing command is routeDesign
	routeDesign
	
	innovus_4_1_2_viaOpt
	

	## Don't do opt Design here, do this separately to keep control over things

	## Time Design
	###############
	if {[dbGet top.statusRCExtracted] == 0} {extractRC}
	exec mkdir -p reports/timing/
	timeDesign 	-postRoute -reportOnly -expandedViews -outDir reports/timing/  -numPaths 100 -prefix route
	timeDesign 	-postRoute -hold -reportOnly -expandedViews -outDir reports/timing/  -numPaths 100 -prefix route_hold

}

proc innovus_4_1_2_viaOpt args {
	

	setNanoRouteMode -drouteMinSlackForWireOptimization 0.1
	setNanoRouteMode -droutePostRouteSwapVia multiCut
	setNanoRouteMode -drouteUseMultiCutViaEffort high
	setNanoRouteMode -droutePostRouteLithoRepair false
	routeDesign -viaOpt
}

proc innovus_4_2_optDesign args {

	innovus_4_set_route_mode
	
	innovus_4_set_si_extract
	
	
	#setAnalysisMode -cppr none

	#  optDesign -postRoute -si -hold -outDir reports -prefix postroute_si_hold
	#The 'optDesign -postRoute -si [-hold]' command is obsolete. To avoid this message and ensure compatibility with future releases use the latest SI Optimization technology by ensuring 'setDelayCalMode -engine default -siAware true' is set & calling 'optDesign -postRoute [-hold]'
	optDesign -postRoute -expandedViews
	optDesign -postRoute -hold -expandedViews
	
	## Fix DRV now and then incremental again
	optDesign -drv -postRoute -expandedViews
	

	optDesign -postRoute -hold -incr -expandedViews
	optDesign -postRoute -incr -expandedViews

	if {[dbGet top.statusRCExtracted] == 0} {extractRC}
	exec mkdir -p reports/timing/
	timeDesign 	-reportOnly -expandedViews -outDir reports/timing/  -numPaths 100 -prefix postroute_si -slackReports
	timeDesign 	-reportOnly -expandedViews -outDir reports/timing/  -numPaths 100 -prefix postroute_si -timingDebugReport
	timeDesign 	-reportOnly -expandedViews -outDir reports/timing/  -numPaths 100 -prefix postroute_si
	
	timeDesign 	-hold -reportOnly -expandedViews -outDir reports/timing/  -numPaths 100 -prefix postroute_si -slackReports
	timeDesign 	-hold -reportOnly -expandedViews -outDir reports/timing/  -numPaths 100 -prefix postroute_si -timingDebugReport
	timeDesign 	-hold -reportOnly -expandedViews -outDir reports/timing/  -numPaths 100 -prefix postroute_si
	
	timeDesign 	-drv -reportOnly -expandedViews -outDir reports/timing/  -numPaths 100 -prefix postroute_drv
	#timeDesign -hold -reportOnly -expandedViews -outDir reports/timing/  -numPaths 100 -prefix postroute_si_hold -slackReports -timingDebugReport

	#Save the design state after the power planning
	saveDesign savings/save05_postRoute.enc
	
	#report_timing -check_type data_setup
}


proc innovus_4_4_repairViolations args {

	global ANTENNA_CELL

	innovus_4_set_route_mode
	setOptMode -reset
	setOptMode -fixDrc true

	detailRoute

	step_utils_verify

}
