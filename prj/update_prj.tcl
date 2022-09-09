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

#Update Riscv Constraints File
set_property constrset constrs_riscv [get_runs synth_1]
set_property constrset constrs_riscv [get_runs impl_1]
set file_list [glob -directory ../src/constraints/ constr_riscv.xdc]
read_xdc $file_list

#Update Standalone Constraints File
set_property constrset constrs_standalone [get_runs synth_1]
set_property constrset constrs_standalone [get_runs impl_1]
set file_list [glob -directory ../src/constraints/ constr_standalone.xdc]
read_xdc $file_list

#Automatically set new compile order.
#This is necessary if a previously defined module is not available anymore and has before been the top module.
set_property source_mgmt_mode All [current_project]
update_compile_order -fileset sources_1

#Write project tcl file. Use -force to overwrite
write_project_tcl -no_copy_sources -use_bd_files -force {../prj/gen_prj.tcl}
