#################################################################################
#
#   Set some parameters in order to customize the script
#
################################################################################



set ring_size 		30
set std_cell_height 5.04

set row_number 20
set total_width 350 

set total_height 	[expr $row_number * $std_cell_height]
set core_height     [expr $row_number * $std_cell_height]
set core_width 		[expr $total_width]



# Set the size of the die. The last four parameters specify the spacing between
# the die edge and the core edge -> currently, statically 0
proc innovus_1_1_floorplan args {
	global core_width
	global core_height
    global ring_size
	

	floorPlan  -s [list $core_width $core_height $ring_size $ring_size $ring_size $ring_size] -coreMarginsBy die

}
