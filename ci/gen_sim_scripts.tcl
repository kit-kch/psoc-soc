open_project psoc_fpga.xpr
foreach fileset [get_filesets -filter {FILESET_TYPE==SimulationSrcs}] {
    launch_simulation -simset $fileset -scripts_only
}
