create_op_cond -name _nominal_ -library_file /home/peric/liberty/h18_1.8V/h18_CORELIB_HV_WC.lib -P 1.0 -T 150.0 -V 1.62

create_library_set -name default_library_set -timing {/home/peric/liberty/h18_1.8V/h18_CORELIB_HV_WC.lib /home/peric/liberty/h18_1.8V/h18_CORELIB_HV_TYP.lib /home/peric/liberty/h18_1.8V/h18_CORELIB_HV_BC.lib}
create_rc_corner -name _default_rc_corner_ -T 150.0
update_rc_corner -name _default_rc_corner_ -cap_table /opt/eda/AMS/v411-H18-OA/cds/HK_H18/LEF/h18a6/h18a6.capTable
update_rc_corner -name _default_rc_corner_ -preRoute_res 1.07
update_rc_corner -name _default_rc_corner_ -preRoute_cap 1.5
create_delay_corner -name _default_delay_corner_ -library_set default_library_set -opcond _nominal_  -opcond_library h18_CORELIB_HV_WC -rc_corner _default_rc_corner_
create_constraint_mode -name PM_worst_functional -sdc_files {./enc_1stOrder/MuPixDigitalTop.PM_worst_functional.sdc}
create_constraint_mode -name PM_typical_functional -sdc_files {./enc_1stOrder/MuPixDigitalTop.PM_typical_functional.sdc}
create_constraint_mode -name PM_best_functional -sdc_files {./enc_1stOrder/MuPixDigitalTop.PM_best_functional.sdc}
create_constraint_mode -name PM_typical_test -sdc_files {./enc_1stOrder/MuPixDigitalTop.PM_typical_test.sdc}
create_constraint_mode -name PM_best_test -sdc_files {./enc_1stOrder/MuPixDigitalTop.PM_best_test.sdc}
create_constraint_mode -name PM_worst_test -sdc_files {./enc_1stOrder/MuPixDigitalTop.PM_worst_test.sdc}
 
create_analysis_view -name view_PM_worst_functional  -constraint_mode PM_worst_functional -delay_corner _default_delay_corner_
create_analysis_view -name view_PM_typical_functional  -constraint_mode PM_typical_functional -delay_corner _default_delay_corner_
create_analysis_view -name view_PM_best_functional  -constraint_mode PM_best_functional -delay_corner _default_delay_corner_
create_analysis_view -name view_PM_typical_test  -constraint_mode PM_typical_test -delay_corner _default_delay_corner_
create_analysis_view -name view_PM_best_test  -constraint_mode PM_best_test -delay_corner _default_delay_corner_
create_analysis_view -name view_PM_worst_test  -constraint_mode PM_worst_test -delay_corner _default_delay_corner_
 
set_analysis_view -setup {view_PM_worst_functional view_PM_typical_functional view_PM_best_functional view_PM_typical_test view_PM_best_test view_PM_worst_test}  -hold {view_PM_worst_functional view_PM_typical_functional view_PM_best_functional view_PM_typical_test view_PM_best_test view_PM_worst_test}
 
