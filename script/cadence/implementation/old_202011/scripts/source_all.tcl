#Base from environment
set BASE $::env(BASE)

#source $BASE/implementation/scripts/settings.tcl
#source $BASE/implementation/scripts/settings_edi.tcl

#setDelayCalMode -reportOutBound true
#set rda_Input(ui_oa_reflib) "SUSLIB_UCL"
# setOaxMode -updateMode true

source $BASE/implementation/scripts/encounter_load_design.tcl
defIn $BASE/run/encounter/floorplan/floorplan.def
source $BASE/implementation/scripts/enc_step1_floorplan.tcl
source $BASE/implementation/scripts/enc_step2_pin_placement.tcl
source $BASE/implementation/scripts/enc_step3_updateMMMC.tcl
source $BASE/implementation/scripts/enc_step5_power_planning.tcl
source $BASE/implementation/scripts/enc_step4_placement.tcl
source $BASE/implementation/scripts/enc_step6_CTS.tcl
source $BASE/implementation/scripts/enc_step7_route.tcl
source $BASE/implementation/scripts/enc_step8_addfiller.tcl
source $BASE/implementation/scripts/enc_step8b_verify.tcl
source $BASE/implementation/scripts/enc_step9_stream_out.tcl

proc run_floorplan {} {
   step1_floorplan
   step2_place_pins
   step5_power_planning
}

proc run_all {} {
   step5_power_planning
   step4_place_cells
   step4a_save_placed_design
   step6_cts_prep
   step6a_onlySetCTSMode
   step6b_cts
   step7_route
   step7a_viaOpt
   step7b_si
   step8_add_filler_cells
   step8b_verify
   step9_stream_out
}
