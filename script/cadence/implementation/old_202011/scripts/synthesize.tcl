
## Base from environment
set BASE $::env(BASE)

## Location of this script
set scriptLocation [file normalize [file dirname [info script]]]
puts "Synthesis script is located in: $scriptLocation, base is $BASE"

#source $BASE/implementation/scripts/settings.tcl
#source $scriptLocation/settings_rc.tcl

################################################################################
#
#   The work flow starts here
#
################################################################################


set_attribute information_level 3

set_attribute hdl_track_filename_row_col 1


#Set the path where to search for the HDL files
#set_attribute hdl_search_path $BASE/sources/hdl /

#Set the name of the top module
set top_module encoder_top


#Load the library file

#set_attribute library [list  \
    /adl/design_kits/AMS/c18-h18-hitkit411/liberty/h18_1.8V/h18_CORELIB_HV_WC.lib \
]

set_attribute library [list  \
    /eda/design_kits/AMS/ah18-hitkit414/liberty/ah18_1.8V/ah18_CORELIB_HV_WC.lib \
]

#Load the cap Table
#set_attribute cap_table_file /adl/design_kits/AMS/c18-h18-hitkit411/cds/HK_H18/LEF/h18a6/h18a6.capTable
set_attribute cap_table_file /eda/design_kits/AMS/ah18-hitkit414/cds/HK_AH18/LEF/ah18a6/ah18a6-worst.capTable
#set_attribute cap_table_file /adl/design_kits/AMS/ah18-hitkit414/cds/HK_AH18/LEF/ah18a6/ah18a6-best.capTable
#set_attribute cap_table_file /eda/design_kits/AMS/ah18-hitkit414/cds/HK_AH18/LEF/ah18a6/ah18a6-typical.capTable
set_attribute scale_of_cap_per_unit_length 1.5
set_attribute scale_of_res_per_unit_length 1.07

#check_library

#Load the lef file

#Set the name of the technology and library LEF files
#Caution: This early synthesis is NOT performing physical aware synthesis. These files are necessary only for generating Encounter configuration files later on automatically.
#set techlef_filename /adl/design_kits/AMS/c18-h18-hitkit411/cds/HK_H18/LEF/h18a6/h18a6.lef
#set lef_filename /adl/design_kits/AMS/c18-h18-hitkit411/cds/HK_H18/LEF/h18a6/CORELIB_HV.lef
set techlef_filename /eda/design_kits/AMS/ah18-hitkit414/cds/HK_AH18/LEF/ah18a6/ah18a6.lef
set lef_filename /eda/design_kits/AMS/ah18-hitkit414/cds/HK_AH18/LEF/ah18a6/CORELIB_HV.lef
set_attribute lef_library [list $techlef_filename $lef_filename]

# Allow TieHighLow
dc::set_dont_use {TIE1_HV TIE0_HV} false

#Read the HDL files 

read_hdl -v2001 [list \
                  $BASE/source_code/hdl/binary_counter.v \
                  $BASE/source_code/hdl/thermometer_encoder.v \
                  $BASE/source_code/hdl/encoder_top.v \
                   ]


#Elaborate the design
elaborate $top_module 

# read cpf
#read_cpf $BASE/implementation/power_intent/MuPixDigitalTop_power_intent.cpf

#define modes and read the specific SDC files
create_mode -name {functional}
read_sdc -mode functional $BASE/implementation/constraints/constraints_functionalMode.sdc
create_mode -name {test}
read_sdc -mode test $BASE/implementation/constraints/constraints_testMode.sdc

# Physical Synthesis Mode -> no wire delay
set_attribute interconnect_mode ple /

#Add register to register Cost group to easily see reg to reg timing results
set all_regs [find / -instance instances_seq/*]
#puts "all_regs = $all_regs \n "
define_cost_group -name REG2REG
path_group -mode functional -from $all_regs -to $all_regs -group REG2REG -name REG2REG
path_group -mode test -from $all_regs -to $all_regs -group REG2REG -name REG2REG

## Synthesise to gates
suspend 

if {[file exists $BASE/run/encounter/floorplan/floorplan.def]} {
	
    puts "Using DEF"
    #suspend	
    read_def $BASE/run/encounter/floorplan/floorplan.def

    synthesize -to_placed -effort medium
    synthesize -to_placed -effort high -incr

   # return 0
} else {

    puts "Not using DEF"
    #suspend

    ## To Mapped
    synthesize -to_mapped -effort medium

    ## Incr Optimisation
    synthesize -to_mapped -effort medium -incr
    synthesize -to_mapped -effort medium -incr

}

## Insert TieHighLow cells
insert_tiehilo_cells -hi TIE1_HV -lo TIE0_HV -maxfanout 10


#reload_cpf
#commit_cpf
#print reports to the console and the log file
report gates
report timing -mode test
report timing -mode functional
report qor
report qor > qor.rpt

exec mkdir -p netlist
write_hdl > netlist/$top_module.gtl.v

#Finish
#quit
