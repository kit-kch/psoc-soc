global BASE
global clockbuffer_cell
global filler_cell
global antenna_cell
global tiehi_cell
global tielo_cell
global vdd
global vss

set vdd {vdd!}
set vss {gnd!}
set BASE $::env(BASE)
set clockbuffer_cell {CLKBUFX4_HV CLKBUFX6_HV CLKBUFX8_HV CLKBUFX10_HV CLKBUFX3_HV CLKINVX32_HV CLKINVX24_HV CLKINVX16_HV CLKINVX2_HV CLKINVX4_HV}
set filler_cell {FILLCELLX1_HV FILLCELLX2_HV FILLCAPX16_HV FILLCAPX32_HV FILLCAPX4_HV FILLCAPX8_HV}
set antenna_cell {}
set tiehi_cell {TIE1_HV}
set tielo_cell {TIE0_HV}
set design_name encoder_top 

#source $BASE/implementation/scripts/encounter_load_design.tcl
#source $BASE/implementation/scripts/source_all.tcl

# Design Import
###########################################################
#defIn $BASE/run/encounter/floorplan/floorplan.def

# MSV Setup
###########################################################
#loadCPF $BASE/implementation/scripts/MuPixDigitalTop.cpf
#commitCPF -keepRows -powerDomain -power_switch

#source $BASE/implementation/scripts/settings.tcl
#source $BASE/implementation/old/enc_2ndOrder/${design_name}.enc_setup.tcl
source $BASE/implementation/scripts/source_all.tcl
run_all

