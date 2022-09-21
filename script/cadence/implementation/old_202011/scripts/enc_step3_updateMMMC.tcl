proc step3_update_MMC { } {
global captable_filename
###############################################################################
##
##        MMMC Update file
##
###############################################################################

#create_library_set -name UCL_typical -timing /adl/design_kits/AMS/c18-h18-hitkit411/liberty/h18_1.8V/h18_CORELIB_HV_TYP.lib

#create_library_set -name UCL_fast -timing /adl/design_kits/AMS/c18-h18-hitkit411/liberty/h18_1.8V/h18_CORELIB_HV_BC.lib

#create_library_set -name UCL_slow -timing /adl/design_kits/AMS/c18-h18-hitkit411/liberty/h18_1.8V/h18_CORELIB_HV_WC.lib



#create_rc_corner -name rc_tt \
   -cap_table $captable_filename \
   -preRoute_res 1.0 \
   -preRoute_cap 1.0 \
   -preRoute_clkres 1.0 \
   -preRoute_clkcap 1.0 \
   -postRoute_res 1.0 \
   -postRoute_cap 1.0 \
   -postRoute_clkres 1.0 \
   -postRoute_xcap 1.0 \
   -T 50
#create_rc_corner -name rc_ff \
   -cap_table $captable_filename \
   -preRoute_res 0.5 \
   -preRoute_cap 0.93 \
   -preRoute_clkres 0.5 \
   -preRoute_clkcap 0.93 \
   -postRoute_res 0.5 \
   -postRoute_cap 0.93 \
   -postRoute_clkres 0.5 \
   -postRoute_xcap 0.93 \
   -T 50
#create_rc_corner -name rc_ss \
   -cap_table $captable_filename \
   -preRoute_res 1.5 \
   -preRoute_cap 1.07 \
   -preRoute_clkres 1.5 \
   -preRoute_clkcap 1.07 \
   -postRoute_res 1.5 \
   -postRoute_cap 1.07 \
   -postRoute_clkres 1.5 \
   -postRoute_xcap 1.07 \
   -T 50

#Create the corresponding delay corners
#Note: RTL Compiler already instructed Encounter to generate a _default_rc_corner_ using the single
#available captable. 
#create_delay_corner -name typical_corner -library_set UCL_typical -rc_corner rc_tt
#create_delay_corner -name best_corner -library_set UCL_fast -rc_corner rc_ff
#create_delay_corner -name worst_corner -library_set UCL_slow -rc_corner rc_ss

#Associate the delay corners with the single already existing power domain
#update_delay_corner -name typical_corner -power_domain main_power_domain
#update_delay_corner -name best_corner -power_domain main_power_domain
#update_delay_corner -name worst_corner -power_domain main_power_domain

#Update the analysis views that are already created by the RTL compiler output script
#update_analysis_view -name view_PM_typical_functional -delay_corner typical_corner
update_analysis_view -name functional_fastLT -delay_corner fastLTrcb
update_analysis_view -name functional_slowHT -delay_corner slowHTrcw
#update_analysis_view -name view_PM_typical_test -delay_corner typical_corner
update_analysis_view -name test_fastLT -delay_corner fastLTrcb
update_analysis_view -name test_slowHT -delay_corner slowHTrcw

set_analysis_view -setup {functional_slowHT test_slowHT} -hold {functional_fastLT test_fastLT}
}

