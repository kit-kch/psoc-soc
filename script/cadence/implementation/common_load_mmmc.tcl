

## Load Library files using Multi Mode Multi Corner
#########################

#### First: Create Library Sets
create_library_set -name slowHT \
    -timing $STD_CELLS($cell_lib/lib/$cell_corner_slow)  \
    -si     $STD_CELLS($cell_lib/cdb/$cell_corner_slow)

create_library_set -name fastLT \
    -timing  $STD_CELLS($cell_lib/lib/$cell_corner_fast) \
    -si      $STD_CELLS($cell_lib/cdb/$cell_corner_fast)

#### Second: Constraints
create_constraint_mode -name functional_slow -sdc_files $::env(BASE)/script/cadence/implementation/constraints/speed_slow.sdc
#create_constraint_mode -name functional_1n25 -sdc_files $sourcesFolder/constraints/test.sdc 

#### Third: Create a delay corner ??
if {$implStage == "SYN" } {

	#-cap_table $captable_filename
    create_rc_corner -name rcfastLT \
	-qrc_tech  $STD_CELLS(qrc/$selected_metal/min) \
	-pre_route_res          0.5 \
	-pre_route_cap          0.93 \
	-pre_route_clock_res    0.5 \
	-pre_route_clock_cap    0.93 \
	-post_route_res          0.5 \
	-post_route_cap          0.93 \
	-post_route_clock_res    0.5 \
	-post_route_clock_cap    0.93 \
	-temperature -40

    create_rc_corner -name rcslowHT \
	-qrc_tech  $STD_CELLS(qrc/$selected_metal/max) \
	-pre_route_res          1.5 \
	-pre_route_cap          1.07 \
	-pre_route_clock_res        1.5 \
	-pre_route_clock_cap        1.07 \
	-post_route_res             1.5 \
	-post_route_cap             1.07 \
	-post_route_clock_res       1.5 \
	-post_route_clock_cap       1.07 \
	-temperature 125

} else {

    create_rc_corner -name rcfastLT \
	-qx_tech_file  $STD_CELLS(qrc/$selected_metal/min) \
	-preRoute_res 0.5 \
	-preRoute_cap 0.93 \
	-preRoute_clkres 0.5 \
	-preRoute_clkcap 0.93 \
	-postRoute_res 0.5 \
	-postRoute_cap 0.93 \
	-postRoute_clkres 0.5 \
	-postRoute_xcap 0.93 \
	-T 50

    create_rc_corner -name rcslowHT \
    -qx_tech_file  $STD_CELLS(qrc/$selected_metal/max) \
	-preRoute_res 1.5 \
	-preRoute_cap 1.07 \
	-preRoute_clkres 1.5 \
	-preRoute_clkcap 1.07 \
	-postRoute_res 1.5 \
	-postRoute_cap 1.07 \
	-postRoute_clkres 1.5 \
	-postRoute_xcap 1.07 \
	-T 50

}

## The following commands are used during synthesis
## If this script is used from Place and Route, the command set is slightly different
## the implStage variable is used to distinguish where this script is called from
if {$implStage == "SYN" } {

    create_timing_condition -name slowHT -library_sets slowHT
    create_timing_condition -name fastLT -library_sets fastLT

    create_delay_corner -name slowHTrcw -timing_condition slowHT -rc_corner rcslowHT
    create_delay_corner -name fastLTrcb -timing_condition fastLT -rc_corner rcfastLT

} else {

    create_delay_corner -name slowHTrcw -library_set slowHT -rc_corner rcslowHT
    create_delay_corner -name fastLTrcb -library_set fastLT -rc_corner rcfastLT

}

#### Final: Create view
create_analysis_view -name functional_slow_slowHT -constraint_mode functional_slow -delay_corner slowHTrcw
create_analysis_view -name functional_slow_fastLT -constraint_mode functional_slow -delay_corner fastLTrcb

## Set the views used for  synthesis
## This must be done here, not in the main synthesize script
if {$implStage == "SYN" } {

	set_analysis_view -setup {functional_slow_slowHT} -hold {functional_slow_fastLT}

}


