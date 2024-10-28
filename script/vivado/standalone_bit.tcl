open_project psoc/psoc.xpr
set_property top fpga_standalone_top [current_fileset]
set_property constrset constrs_standalone [get_runs synth_1]
set_property constrset constrs_standalone [get_runs impl_1]
reset_run -quiet synth_1
reset_run -quiet impl_1
launch_runs -to_step write_bitstream impl_1
wait_on_run impl_1