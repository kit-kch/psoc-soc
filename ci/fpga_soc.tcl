source psoc_fpga.tcl
set_property top fpga_riscv_top [current_fileset]
launch_runs -jobs 8 -to_step write_bitstream impl_1
wait_on_run impl_1
