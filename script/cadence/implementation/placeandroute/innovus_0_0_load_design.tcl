proc innovus_0_0_load_design args {

	global cell_lib
	global selected_metal
	global top_module
	global location
	global STD_CELLS
	
	## First Free the design
	################
	catch {freeDesign}

	## 180nm configuration
	####################

	setDesignMode -process 180
	set ::std_cell_height 5.04
	#setDelayCalMode -engine Aae -signoff false -SIAware false
	setDelayCalMode -engine default -signoff false -SIAware true

	set ::init_lef_file {}
	foreach lef $STD_CELLS($cell_lib/lef/common) {
		puts "Adding: $lef"
		lappend ::init_lef_file  $lef
	}
	lappend ::init_lef_file $STD_CELLS($cell_lib/lef/$selected_metal)
	#set ::init_lef_file [lreverse ${::init_lef_file}]
	
	puts "LEF: ${::init_lef_file}"
	

	## Tool setup
	#######################
	setLimitedAccessFeature ediUsePreRouteGigaOpt 1
	setDesignMode -highSpeedCore true
	setMultiCpuUsage -localCpu 8 -keepLicense false
	setDistributeHost -local

	## Set Design
	## Synthesis GTL is read from the neighbor "synthesis" folder under run/
	###############################
	set ::init_verilog "../synthesis/netlist/${top_module}.gtl.v"
	set ::init_top_cell $top_module

	#### MMMC Setup
	#### Use the script common to P&R and Synthesis
	###############################

	puts "Will Load MMMC mode"
	uplevel source  $location/../common_load_mmmc.tcl
	puts "Out of load libraries \n"

	## Init
	#########################

	suppressMessage ENCLF-122

	## Init design by giving corner pairs for hold/setup
	puts "########################## INIT DESIGN #####################################"
	if {${::implStage}=="PRQ"} {
		init_design  -setup {functional_slow_slowHT} -hold {functional_slow_fastLT}
	} else {
		init_design  -setup {functional_slow_slowHT } -hold {functional_slow_fastLT}
	}
	#init_design  -setup {functional_800p_slowHT functional_1n25_slowHT} -hold {functional_800p_fastLT functional_1n25_fastLT}
	#init_design  -setup { functional_1n25_slowHT} -hold { functional_1n25_fastLT}
	#init_design  -setup {functional_800p_slowHT} -hold {functional_800p_fastLT}
	puts "########################## INIT DESIGN #####################################"

}



