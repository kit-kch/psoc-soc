source psoc_fpga.tcl
foreach fileset [get_filesets -filter {FILESET_TYPE==SimulationSrcs}] {
	set_property RUNTIME all $fileset
	launch_simulation -simset $fileset -scripts_only
}

