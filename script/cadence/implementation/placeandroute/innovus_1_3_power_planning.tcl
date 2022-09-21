#Base from environment
#set BASE $::env(BASE)
#Source the floorplan script in order to make the variables available, which are defined there
#source $BASE/implementation/scripts/enc_step1_floorplan.tcl

proc innovus_1_3_power_plan args {

	global total_height
	global total_width
	global ring_size
	# global ring_width_left 30
	# global ring_width_right 30

	## Clear All Power Nets
	#############
	clearGlobalNets
	deleteAllPowerPreroutes

	set VDDNAME VDD
	set GNDNAME GND

	#try to create power nets
	# Errors can be ignored here
	#########################
	catch {
		addNet -physical $VDDNAME
		setNet -net $VDDNAME -type special
		dbSetIsNetPwr $VDDNAME

		addNet -physical $GNDNAME
		setNet -net $GNDNAME -type special
		dbSetIsNetGnd $GNDNAME
	}

	globalNetConnect $VDDNAME -type pgpin 	-pin vdd! -all -verbose
	globalNetConnect $GNDNAME -type pgpin 	-pin gnd! -all -verbose
	globalNetConnect $VDDNAME -type net 	-net vdd! -all -verbose
	globalNetConnect $GNDNAME -type net 	-net gnd! -all -verbose

	## 0/1 constants in design are tiehi/low
	globalNetConnect $VDDNAME    -type tiehi
	globalNetConnect $GNDNAME    -type tielo

	#return  #-offset {top 1.5 bottom 1.5 left 1 right 1  } \  -snap_wire_center_to_grid Grid

	## Add Core Ring
	##################
	set stripe_spacing 5
	set ring_stripe_width [expr ($ring_size - 2 * $stripe_spacing) / 2 ]
	puts "Width: $ring_stripe_width"

	setAddRingMode -reset
	setAddRingMode -ring_target core_ring -wire_center_offset false
	addRing -nets [list $VDDNAME $GNDNAME] \
		-type core_rings  \
		-follow core  \
		-layer {top AM bottom AM left MT right MT}  \
		-width  [list top $ring_stripe_width bottom $ring_stripe_width left $ring_stripe_width right $ring_stripe_width ] \
		-spacing [list top $stripe_spacing bottom $stripe_spacing left $stripe_spacing right $stripe_spacing ] \
		-use_wire_group 1 \
		-center 1 -offset_adjustment automatic

	## Add Stripes
	#############
	set stripe_coverage_percent 50
	set stripe_width 8

	set horizontal_core_covered_width [expr ${::core_width} * $stripe_coverage_percent / 100]
	set vertical_stripes_count [expr $horizontal_core_covered_width / (2*$ring_stripe_width + $stripe_spacing)]
	set horizontal_offset 			[expr (${::core_height} - ($vertical_stripes_count * (2*$ring_stripe_width + 2*$stripe_spacing) ) ) /2 ]
	
	set vertical_core_covered_height [expr ${::core_height} * $stripe_coverage_percent / 100]
	set horizontal_stripes_count 	[expr int($vertical_core_covered_height / (2*$ring_stripe_width + $stripe_spacing))]
	set vertical_offset 			[expr (${::core_height} - ($horizontal_stripes_count * (2*$ring_stripe_width + 2*$stripe_spacing) ) ) /2 ]
	
	#[expr 2*$stripe_width + $stripe_spacing]
	addStripe -nets [list $VDDNAME $GNDNAME]  \
	-layer AM   \
	-direction horizontal   \
	-width $stripe_width   \
	-spacing  $stripe_spacing  \
	-number_of_sets $horizontal_stripes_count   \
	-extend_to all_domains   \
	-ytop_offset $vertical_offset   \
	-ybottom_offset $vertical_offset   \
	-merge_stripes_value auto   \
	-use_wire_group 1
	
	addStripe -nets [list $VDDNAME $GNDNAME]  \
	-layer MT   \
	-direction vertical   \
	-width $stripe_width   \
	-spacing $stripe_spacing   \
	-number_of_sets $vertical_stripes_count   \
	-extend_to all_domains   \
	-ytop_offset $horizontal_offset   \
	-ybottom_offset $horizontal_offset   \
	-merge_stripes_value auto   \
	-use_wire_group 1
	
	puts "H Count: $horizontal_stripes_count "
	
	#These parameters are obsolete since SOC8.10 and are replaced by -connect (with having their meaning inverted)
	setSrouteMode -reset
	setSrouteMode -extendNearestTarget true -viaConnectToShape {stripe ring} -targetSearchDistance 150 -corePinJoinLimit 10
	sroute -deleteExistingRoutes -nets [list $VDDNAME $GNDNAME] -connect corePin -layerChangeRange {M1 AM} -allowLayerChange 0 -targetViaLayerRange {M1 AM}


	#Save the design state after the power planning
	saveDesign savings/save01_postPowerPlanning.enc

	## Save Plan
	exec mkdir -p floorplan
	defOut -floorplan ./floorplan/floorplan.def

}
