open_project psoc/psoc.xpr
foreach fileset [get_filesets -filter {FILESET_TYPE==SimulationSrcs}] {
    launch_simulation -simset $fileset -scripts_only
}