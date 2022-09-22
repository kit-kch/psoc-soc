
proc flow_sub_streamout args {

	innovus_5_1_addFillers

	step_utils_verify
	step_utils_ecoFixDRC

	innovus_5_2_signoff
	innovus_5_3_streamout

	step_utils_verify

}
proc step_utils_verify args {
	
	
	verifyConnectivity -noAntenna
	#verify_drc -ignore_trial_route -report verifyDRC.rpt 
	verifyProcessAntenna
	verifyTieCell
	
}

proc step_utils_ecoFixDRC args {
	
	global ANTENNA_CELL
	
	innovus_4_set_route_mode
	
	ecoRoute -fix_drc
	
	step_utils_verify
	
}

proc innovus_5_signoffOpt_setMode args {
	
	setSignoffOptMode -reset
	setSignoffOptMode -powerAware true
	setSignoffOptMode -powerOptFocus total
	setSignoffOptMode -fixHoldAllowSetupOptimization true
	setSignoffOptMode -fixHoldAllowSetupTnsDegrade true

	
}

proc innovus_5_signoffOpt_opt args {
	
	signoffOptDesign -setup -noEcoRoute
	#signoffOptDesign -hold
	
}

proc innovus_5_1_addFillers args {
	global STD_CELLS
	
	#add filler cells to the design
	addFiller -cell $STD_CELLS(physical/fillers) -prefix FILLER
	
	## Fix DRC
	ecoRoute -target
}

proc innovus_5_2_signoff args {
	
	## Set Mode parameters for Extraction
	setExtractRCMode -reset
	setExtractRCMode -engine postRoute -effortLevel signoff -coupled true
	
	setDelayCalMode -reset
	setDelayCalMode -engine default -SIaware true 
	
	setAnalysisMode -reset
	setAnalysisMode -analysisType onChipVariation -cppr both 
	
	
	## Save Timing
	if {[dbGet top.statusRCExtracted] == 0} {extractRC}
	
	exec mkdir -p reports/timing/
	exec mkdir -p reports/summary/
	timeDesign -signoff -expandedViews
	timeDesign -signoff -hold -expandedViews
	
	timeDesign 	-reportOnly -expandedViews -outDir reports/timing/  -numPaths 100 -prefix signoff -slackReports
	timeDesign -hold -reportOnly -expandedViews -outDir reports/timing/  -numPaths 100 -prefix signoff_hold -slackReports
	
	summaryReport -outDir reports/summary
	
	
	saveDesign savings/save05b_signoffTiming.enc
	
}

proc innovus_5_3_streamout args {
	
	global STD_CELLS 
	global top_module
	global cell_lib
	
	exec mkdir -p stream_out
	
	## SDFfunctional_slow_slowHT
	############
	#write_sdf -recompute_delay_calc -min_view functional_800p_slowHT -max_view functional_800p_fastLT -edges noedge ./stream_out/${top_module}.functional_800p.sdf
	#write_sdf -recompute_delay_calc -min_view functional_1n25_slowHT -max_view functional_1n25_fastLT -edges noedge ./stream_out/${top_module}.functional_1n25.sdf
	#write_sdf  -view functional_800p_slowHT -edges noedge   ./stream_out/${top_module}.functional_800p.slow.sdf
	write_sdf  -view functional_slow_slowHT -edges noedge ./stream_out/${top_module}.functional_slow_slowHT.slow.sdf
	
	 
	##write_sdf -view functional_fastLT -edges noedge ./stream_out/${top_module}.fast.sdf
	
	## Save Netlist for LVS
	saveNetlist -flat -includePhysicalCell [join $STD_CELLS(physical/fillcaps)] -excludeLeafCell ./stream_out/netlist.lvs.v
	
	## Save Netlist for Simulation
	saveNetlist ./stream_out/netlist.simulation.nonFlat.v
	
	
	## GDS  -mapFile $STD_CELLS(physical/gdsmap)
	###################
	setStreamOutMode -reset 
	setStreamOutMode -textSize .2
	setStreamOutMode -labelAllPinShape true
	
	
        puts "Streamout Map: $STD_CELLS(physical/gdsmap)"
        streamOut -outputMacros -mapFile $STD_CELLS(physical/gdsmap) ./stream_out/map.gds
	

	saveDesign savings/save06_postStreamout.enc

}
