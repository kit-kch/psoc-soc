################################################################################
#
#   Set some variables in order to customize the script
#
################################################################################

set design_name MuPixDigitalTop

#Set the path to the root directory of the project
set workpath .

#Set the name of the top module
set top_module ${design_name}

#Set the list of HDL files Pipe
set hdl_file_list {aurora_trans_simple.v 8b10bwrapper.v CW_8b10b_enc.v SerializerTop.v SerializerTree.v MuPixReadout.v SerializerMain.v ClockGen.v MuPixDigitalTop.v}

#set hdl_file_list {aurora_trans.v aurora_control_fsm.v aurctr42.v even_ind.v idle_cnt.v ln_cnt.v reset_cnt.v val_cnt.v fsm_counter.v res_cnt.v 8b10bwrapper.v CW_8b10b_enc.v SerializerTop.v SerializerTree.v MuPixReadout.v SerializerMain.v ClockGen.v MuPixDigitalTop.v}
#set hdl_file_list {column.v column_data_path.v serial_rb2b.v adc_main_fsm.v row2sync_sync_clock_gen.v column_pair.v shift_reg_chain.v pipelined_counter.v test_injection.v dcd_b_digital_block.v jtag_id.v jtag_InputCell.v jtag_ir.v jtag_OutputCell.v jtag_output_mux.v jtag_tap_ctrl.v jtag.v tap_defines.v}

#Set the designe CPF file name
#set cpf_filename ${design_name}_power_intent.cpf

#Set the SDC files for the various modes
set functional_constraint_file constraints_functionalMode.sdc
set test_constraint_file constraints_testMode.sdc

#Set the DEF floorplan file name
set def_filename floorplan.def

#source scripts/technology.tcl



