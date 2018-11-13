source psoc_fpga.tcl
launch_runs -jobs 8 -to_step write_bitstream impl_1
wait_on_run impl_1
