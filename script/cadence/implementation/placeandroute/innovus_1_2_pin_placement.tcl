# List of pins
proc innovus_1_2_placepins args {

	global core_width
	global core_height
	global ring_size

	set die_size_x [expr $core_width + 2*$ring_size]
	set die_size_y [expr $core_height + 2*$ring_size]

	set pinWidth 0.3136

	setPinAssignMode -pinEditInBatch true


	#########################################################################################
	#
	#   Place Top Pins on metal 3
	#
	#########################################################################################

	#Place column2adc0 pins
	set x_pos 20

	for {set x 0} {$x<=255} {incr x} {
		editPin -side Top -pin thermometer_code[$x] -layer 2 -use SIGNAL -pinWidth 0.28 -pinDepth 1 -fixedPin 1 -fixOverlap 0 -honorConstraint 0 -assign [expr $x_pos] $die_size_y -snap USERGRID
		set x_pos [expr $x_pos + 1]
	}

	#########################################################################################
	#
	#   Place Bottom Pins on metal 3
	#
	#########################################################################################
	set x_pos 10

	editPin -side Bottom -pin clk -layer 2 -use SIGNAL -pinWidth 0.28 -pinDepth 1 -fixedPin 1 -fixOverlap 0 -honorConstraint 0 -assign [expr $x_pos] $die_size_y -snap USERGRID
	set x_pos [expr $x_pos + 1]

	editPin -side Bottom -pin reset -layer 2 -use SIGNAL -pinWidth 0.28 -pinDepth 1 -fixedPin 1 -fixOverlap 0 -honorConstraint 0 -assign [expr $x_pos] $die_size_y -snap USERGRID
	set x_pos [expr $x_pos + 1]

	setPinAssignMode -pinEditInBatch false

	fit
}
