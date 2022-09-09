#Load Project
source ../prj/gen_prj.tcl

#Add VHDL Design Sources to Project
set file_list [glob -directory ../src/hdl/ *.vhd]
read_vhdl $file_list

#Add Verilog Design Sources to Project
set file_list [glob -directory ../src/hdl/ *.v]
read_verliog $file_list

#Add VHDL Sim Sources to Project
set file_list [glob -directory ../src/sim/ *.vhd]
read_vhdl $file_list

#Add Verilog Sim Sources to Project
set file_list [glob -directory ../src/sim/ *.v]
read_verliog $file_list

#Update Riscv Constraints File
set_property constrset constr_riscv [get_runs synth_1]
set_property constrset constr_riscv [get_runs impl_1]
set file_list [glob -directory ../src/constraints/ constr_riscv.xdc]
read_xdc $file_list

#Update Standalone Constraints File
set_property constrset constr_standalone [get_runs synth_1]
set_property constrset constr_standalone [get_runs impl_1]
set file_list [glob -directory ../src/constraints/ constr_standalone.xdc]
read_xdc $file_list

#Automatically set new compile order.
#This is necessary if a previously defined module is not available anymore and has before been the top module.
set_property source_mgmt_mode All [current_project]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

#Write project tcl file. Use -force to overwrite
write_project_tcl -no_copy_sources -use_bd_files -force {./prj/gen_prj.tcl}

#Close project and finish
close_project
