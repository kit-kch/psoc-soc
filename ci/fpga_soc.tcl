open_project psoc_fpga.xpr
set_property top fpga_riscv_top [current_fileset]
reset_run -quiet synth_1
reset_run -quiet impl_1
launch_runs -jobs 8 -to_step write_bitstream impl_1
wait_on_run impl_1