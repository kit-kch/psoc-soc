#Base from environment
set BASE $::env(BASE)
#Source the floorplan script in order to make the variables available, which are defined there
source $BASE/implementation/scripts/enc_step1_floorplan.tcl

proc step5_power_planning { } {

    global total_height 
    global total_width

    global ring_width_left 30
    global ring_width_right 30

    set horizontal_offset_margin 0
    
    #Set the number of power/ground nets. It is used for wire distribution calculations
    set number_of_power_nets 2
    
    #Set the number of vertical stripes
    set number_of_vertical_stripes 9
    
    #Set the number of horizontal stripes
    set number_of_horizontal_stripes 3
    
    #Set the width of horizontal stripes
    set width_of_horizontal_stripes 5
    
    #Set the width of vertical stripes
    set width_of_vertical_stripes 10
    
    #Set the spacing of horizontal stripes
    set spacing_of_horizontal_stripes 5
    
    #Set the spacing of vertical stripes
    set spacing_of_vertical_stripes 5
    

    globalNetConnect vdd! -type pgpin -pin vdd! -all -verbose
    globalNetConnect gnd! -type pgpin -pin gnd! -all -verbose
    globalNetConnect vdd! -type net -net vdd! -all -verbose
    globalNetConnect gnd! -type net -net gnd! -all -verbose

# Florian
    #globalNetConnect vdd! -type tiehi -inst *
    #globalNetConnect gnd! -type tielo -inst *
     
    addRing -nets {vdd! gnd!} -type core_rings -follow core -layer_top AM -layer_bottom AM -layer_right MT -layer_left MT -width_top 5 -width_bottom 5 -width_left 10 -width_right 10 -spacing_top 5 -spacing_bottom 5 -spacing_right 5 -spacing_left 5 -offset_top 1 -offset_bottom 1 -offset_left 1 -offset_right 1
    
    # Vias on ME6 have a minimum width of 1.2 um. The stripes should have also this minimal width
    set horizontal_xy_offset [expr [expr $total_height - $number_of_power_nets * [expr $width_of_horizontal_stripes + $spacing_of_horizontal_stripes]] / [expr $number_of_horizontal_stripes + 1]]
    addStripe -nets {vdd! gnd!} -layer AM -direction horizontal -width $width_of_horizontal_stripes -spacing $spacing_of_horizontal_stripes -number_of_sets $number_of_horizontal_stripes -extend_to all_domains -ytop_offset $horizontal_xy_offset -ybottom_offset $horizontal_xy_offset -merge_stripes_value 0.3 -use_wire_group 1
    
    set vertical_leftright_offset [expr [expr [expr $total_width -$ring_width_left -$ring_width_right - $number_of_vertical_stripes * $number_of_power_nets * $width_of_vertical_stripes - [expr [expr $number_of_vertical_stripes * $number_of_power_nets] -1] * $spacing_of_vertical_stripes] / [expr $number_of_vertical_stripes + 1]] - $horizontal_offset_margin]
    
    addStripe -nets {vdd! gnd!} -layer MT -direction vertical -width $width_of_vertical_stripes -spacing $spacing_of_vertical_stripes -number_of_sets $number_of_vertical_stripes -extend_to all_domains -start_x [expr $ring_width_left + $vertical_leftright_offset] -stop_x [expr $total_width - $ring_width_right - $vertical_leftright_offset] -merge_stripes_value 0.3 -use_wire_group 1
    #addStripe -nets {VDD VSS} -layer AM -direction vertical -width $width_of_vertical_stripes -spacing $spacing_of_vertical_stripes -number_of_sets $number_of_vertical_stripes -extend_to all_domains -xleft_offset $vertical_leftright_offset -xright_offset $vertical_leftright_offset -merge_stripes_value 0.3 -use_wire_group 1
    
    #These parameters are obsolete since SOC8.10 and are replaced by -connect (with having their meaning inverted)
    #sroute -nets {vddd! gndd! vddb! gnd!} -noBlockPins -noPadPins -noPadRings -noStripes
    sroute -nets {vdd! gnd!} -connect corePin


   #It is a very much better choice to have ME6 in horizontal direction and ME5 in vertical direction than the opposite assignment!!!
    #When having ME6 in vertical direction, every ME1 power rail has to connect up to ME6, producing very much very lage vias between
    #ME6 and ME5. This has impact to the via array sinze down to ME1! This results in the inconectability of vddb! and gndb! to the
    #vertical power rails. If aditional horizontal power stripes are used, this may end up in completely unconnected gndb! and vddb! rails!!! 
#    addRing -nets {vddd gndd vddb gndb} -type core_rings -follow core -layer_top ME6 -layer_bottom ME6 -layer_right ME5 -layer_left ME5 -width_top 20 -width_bottom 20 -width_left 20 -width_right 20 -spacing_top 2 -spacing_bottom 2 -spacing_right 2 -spacing_left 2 -offset_top 1 -offset_bottom 1 -offset_left 1 -offset_right 1 -use_wire_group 1
    
    # Vias on ME6 have a minimum width of 1.2 um. The stripes should have also this minimal width
 #   set horizontal_xy_offset [expr [expr $total_height - $number_of_power_nets * [expr $width_of_horizontal_stripes + $spacing_of_horizontal_stripes]] / [expr $number_of_horizontal_stripes + 1]]
 #   addStripe -nets {vddd gndd vddb gndb} -layer ME6 -direction horizontal -width $width_of_horizontal_stripes -spacing $spacing_of_horizontal_stripes -number_of_sets $number_of_horizontal_stripes -extend_to all_domains -ytop_offset $horizontal_xy_offset -ybottom_offset $horizontal_xy_offset -merge_stripes_value 0.3 -use_wire_group 1
    
 #   set vertical_leftright_offset [expr [expr $total_width - $number_of_power_nets * [expr $width_of_vertical_stripes + $spacing_of_vertical_stripes]] / [expr $number_of_vertical_stripes + 1]]
 #   addStripe -nets {vddd gndd vddb gndb} -layer ME5 -direction vertical -width $width_of_vertical_stripes -spacing $spacing_of_vertical_stripes -number_of_sets $number_of_vertical_stripes -extend_to all_domains -xleft_offset $vertical_leftright_offset -xright_offset $vertical_leftright_offset -merge_stripes_value 0.3 -use_wire_group 1    

 #   sroute -nets {vddd gndd vddb gndb} -connect corePin





    
    #Save the design state after the power planning
    saveDesign savings/save03_postPowerPlanning.enc


}
