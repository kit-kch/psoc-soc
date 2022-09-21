#################################################################################
#
#   Set some parameters in order to customize the script
#
################################################################################

set ring_width_top 20
set ring_width_bottom 20
set ring_width_left 30
set ring_width_right 30

set row_number 20
set total_width 350 



set std_cell_height 5.04


################################################################################
#
#   execute the workflow
#
################################################################################


set die_size_y [expr $ring_width_bottom + $ring_width_top + [expr $row_number * $std_cell_height]]
# The die is going to be a square
set die_size_x $total_width

set total_height [expr $row_number * $std_cell_height]

# Set the size of the die. The last four parameters specify the spacing between
# the die edge and the core edge -> currently, statically 0
proc step1_floorplan { } {
    global die_size_x
    global die_size_y
    global ring_width_left
    global ring_width_bottom
    global ring_width_right
    global ring_width_top
    floorPlan -d $die_size_x $die_size_y $ring_width_left $ring_width_bottom $ring_width_right $ring_width_top 
}
