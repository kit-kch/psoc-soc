## Base Parameters and variables
##########################

## Base from environment
set BASE   $::env(BASE)
## Name of Server folder (eda/adl):
set AMS_HOME   $::env(AMS_HOME)


## Load the AMSH18 helper script
## This script produces a TCL array with required technology files sorted by type so they can be used later on
source $::env(BASE)/script/cadence/common/ams_h18/std_cells.tcl

## we are saving the Standard Cells library and corner names in variables to make the script easier to read
set cell_lib            CORELIB_HV
set cell_corner_slow    ah18_1.8V/WC
set cell_corner_fast    ah18_1.8V/BC
set selected_metal      a6


# Set the name of the top module
set top_module encoder_top


## Design implementation Stage
##  - SYN -> Synthesis
##  - PR0 -> Place and route relaxed
##  - SOFF -> Place and route signoff
set implStage SYN
set forceNonPhysical false

if {[catch {set ::env(NOPHYSICAL)}]==0} {
	puts "Forcing Not physical"
	set forceNonPhysical true
}

## Location of this script
#################
set scriptLocation [file normalize [file dirname [info script]]]
puts "Synthesis script is located in: $scriptLocation, base is $BASE"

## Utils
#################


proc logStep {name script} {
	puts "######################## BEG: $name ########################"
	uplevel $script
	puts "######################## EOF: $name ########################"
}


## Summary
#########################
logStep "Summary" {

	#puts "(I) Sources Folder: $sourcesFolder"

}

################################################################################
#
#   The work flow starts here
#
################################################################################

set_db information_level 3

## Suppress messages that are not really useful and annoying
## Warning that cells are not aligned to origin in LEF
suppress_messages PHYS-127

## Enable clock gating here
set_db lp_insert_clock_gating true

## Load MMMC
## This sets up the tool by loading constraints and libraries for the selected corners
#####################
logStep "MMMC" {
	
	## Load the MMC Settings
	read_mmmc $scriptLocation/../common_load_mmmc.tcl
	
	
}

## Load Physical files
## These parameters are for the 
###############

#To prevent the library cell from being set to 'avoid', set attribute 'lib_lef_consistency_check_enable' to 'false'.
set_db lib_lef_consistency_check_enable true

read_physical -lefs [list  $STD_CELLS($cell_lib/lef/common)  $STD_CELLS($cell_lib/lef/$selected_metal) ]

set_db qrc_tech_file $STD_CELLS(qrc/$selected_metal/max)

set_db design_process_node 180

set_db scale_of_cap_per_unit_length 1.5
set_db scale_of_res_per_unit_length 1.07

# Elaborate the design
#############
logStep "Read HDL" {

	# Read the HDL files by using the .f format similar to simulation
	read_hdl -sv -f $BASE/src/hdl/encoder_top.f

	set_db hdl_error_on_blackbox true
	set_db hdl_track_filename_row_col 1
	set_db hdl_sv_module_wrapper 1


	elaborate $top_module
}

## Init Design
## This step will load the elaobated design with the constrainst set in MMMC block
###############
logStep "Init Design" {
	init_design
}

## Check Design
## This command generates general checks on the design, so we can detect setup errors easily
##########
check_design -all > check_design.rpt


puts "Please Check Design warnings before continuing"
report_messages -all
suspend



## Retiming and Clock Gating enabling
##############


## Don't touchs if needed
## Preserve BUF Cells to avoid optimisations changing what we really want
set_db [get_db insts *BUF*] .dont_touch true
#set_db [get_db insts *shift_register_I*] .dont_touch true



## First Report, see if all is fine
############
report ple > ple.rpt

## Define cost groups (clock-clock, clock-output, input-clock, input-output)
## This is Taken from Genus Reference example template
###################################################################################

source $::env(BASE)/script/cadence/common/genus/create_default_cost_groups.tcl

## Physical Synthesis
##  - First Synthesis pass won't be placing, once a floorplan has been defined and saved, then we can run physical synthesis
####################


# Don't use TieHighLow, will be set by innovus
dc::set_dont_use {TIE0_HV TIE1_HV} true


## Synthesise to gates
if {!$forceNonPhysical && [file exists ../par/floorplan/floorplan.def]} {

	puts "Using DEF"

	set effort high

	# Physical Synthesis Mode -> no wire delay
	set_db interconnect_mode ple

	## Init values for innovus
	set_db design_process_node 180

	## Effort
	set_db phys_flow_effort $effort

	## Read Floorplan from neighbour place and route 'par' folder
	read_def ../par/floorplan/floorplan.def

	## To Mapped
	logStep "SYN GENERIC" {
		set_db / .syn_generic_effort $effort
		syn_generic -physical


	}

	logStep "SYN MAP" {
		set_db / .syn_map_effort $effort
		syn_map	-physical
	}

	logStep "SYN OPT" {
		syn_opt -physical
	}

} else {

	puts "Not using DEF (non physical synthesis)"
	#suspend
	set effort low

	## To Generic
	set_db / .syn_generic_effort $effort
	syn_generic

	## If CHECK_DESIGN environment variable is set, pause here so we can look at warnings
	if {[catch {set ::env(CHECK_DESIGN)}]==0} {
		puts "Please Check Design warnings before continuing"
		report_messages -all
		suspend
	}

	## Map
	set_db / .syn_map_effort $effort
	syn_map

	syn_opt
	syn_opt -incremental

}

## Write Timing out
exec mkdir -p timing
foreach cg [vfind / -cost_group *] {
	foreach mode [vfind / -mode *] {
		report_timing -group [list $cg] -mode $mode > timing/${top_module}_[vbasename $cg]_[vbasename $mode]_post_map.rpt
	}
}


## Reports
report gates

report qor
report qor > qor.rpt
report_clock_gating > cgate.rpt
report power > power.rpt

## Timing Lint Output, very important to check for wrong things leading to massive logic optimisation
report timing -lint > timing_lint.rpt
report timing -lint -verbose > timing_lint.verbose.rpt

## Write Backend Files
###############################
exec mkdir -p netlist
write_snapshot -outdir netlist -tag final
report_summary -directory netlist

## This line saves our gate netlist back to a verilog file
## see the 'gtl' marker in the file name, this allows us to quickly identify that this file was generated by Genus
write_hdl  		> netlist/${top_module}.gtl.v