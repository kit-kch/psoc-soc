#Open project
open_project psoc/psoc.xpr

#Add VHDL Design Sources to Project
set file_list [glob -nocomplain -directory ../src/hdl/ *.vhd]
if {[llength $file_list] != 0} {
    read_vhdl $file_list
} else {
    puts "No VHDL Design Sources found."
}

#Add Verilog Design Sources to Project
set file_list [glob -nocomplain -directory ../src/hdl/ *.v]
if {[llength $file_list] != 0} {
    read_verilog $file_list
} else {
    puts "No Verilog Design Sources found."
}

#Reset runs, so Vivado does not reference design checkpoint files
reset_run -quiet synth_1
reset_run -quiet impl_1

#Update Riscv Constraints File
set_property constrset constrs_soc [get_runs synth_1]
set_property constrset constrs_soc [get_runs impl_1]
set file_list [glob -directory ../script/vivado/ constr_soc.xdc]
read_xdc $file_list

#Update Standalone Constraints File
set_property constrset constrs_standalone [get_runs synth_1]
set_property constrset constrs_standalone [get_runs impl_1]
set file_list [glob -directory ../script/vivado/ constr_standalone.xdc]
read_xdc $file_list

#Automatically set new compile order.
#This is necessary if a previously defined module is not available anymore and has before been the top module.
set_property source_mgmt_mode All [current_project]
update_compile_order -fileset sources_1

#Reset Project to avoid dcp dependency
reset_project

#Write project tcl file. Use -force to overwrite
write_project_tcl -no_copy_sources -use_bd_files -force {../script/vivado/gen_prj.tcl}
