# List of pins
proc step2_place_pins { } {

    global die_size_y
    global die_size_x

    
    
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



#########################################################################################    
#    
#   Create Labels for all Pins
#
#########################################################################################
     
    #Create Text label for eech pin
    foreach_in_collection port [get_ports *] { addCustomText ME2 [get_property $port net_name] [get_property $port x_coordinate] [get_property $port y_coordinate] 0.1 }




    
    
#########################################################################################    
#    
#   Save
#
#########################################################################################
         
    #Save the design state after the pin placement
#saveDesign savings/save01_postPinPlacement.enc
}
