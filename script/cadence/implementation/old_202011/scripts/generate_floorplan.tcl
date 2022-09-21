#Base from environment
set BASE $::env(BASE)
#source scripts/settings.tcl

#Load the first order synthesis result
#source enc_1stOrder/${design_name}.enc_setup.tcl
source $BASE/implementation/scripts/encounter_load_design.tcl

#Load scripts for floorplanning and pin placement
set def_filename floorplan.def
source $BASE/implementation/scripts/enc_step1_floorplan.tcl
source $BASE/implementation/scripts/enc_step2_pin_placement.tcl
source $BASE/implementation/scripts/enc_step5_power_planning.tcl
loadCPF $BASE/implementation/power_intent/MuPixDigitalTop_power_intent.cpf
commitCPF -keepRows -powerDomain -power_switch

#Execute these scripts
step1_floorplan
step2_place_pins
step5_power_planning

exec mkdir -p floorplan
defOut -floorplan ./floorplan/floorplan.def



