# ####################################################################

#  Created by Encounter(R) RTL Compiler RC12.22 - v12.20-s014_1 on Thu Aug 21 17:14:08 +0200 2014

# ####################################################################

set sdc_version 1.7

set_units -capacitance 1000.0fF
set_units -time 1000.0ps

# Set the current design
current_design MuPixDigitalTop

create_clock -name "clk_800p" -add -period 1.25 -waveform {0.0 0.625} [get_ports clk_800p]
create_clock -name "clkIn_4n" -add -period 6.25 -waveform {0.0 3.125} [get_ports clkIn_4n]
create_generated_clock -name "clk_8n" -divide_by 2     -source [get_ports clkIn_4n]   [get_pins {SerializerTop_I_SerializerMain_I_Cnt4_reg[0]/Q}] 
create_generated_clock -name "clk_16n" -divide_by 4     -source [get_ports clkIn_4n]   [get_pins {SerializerTop_I_SerializerMain_I_Cnt4_reg[1]/Q}] 
create_generated_clock -name "clk_3n2" -divide_by 4     -source [get_ports clk_800p]   [get_pins {SerializerTop_I_ClockGen_I_FastCnt4_reg[1]/Q}] 
create_generated_clock -name "clk_1n6" -divide_by 2     -source [get_ports clk_800p]   [get_pins SerializerTop_I_ClockGen_I_clkOut_1n6_reg/Q] 
set_load -pin_load 0.1 [get_ports {TSToDet[7]}]
set_load -pin_load 0.1 [get_ports {TSToDet[6]}]
set_load -pin_load 0.1 [get_ports {TSToDet[5]}]
set_load -pin_load 0.1 [get_ports {TSToDet[4]}]
set_load -pin_load 0.1 [get_ports {TSToDet[3]}]
set_load -pin_load 0.1 [get_ports {TSToDet[2]}]
set_load -pin_load 0.1 [get_ports {TSToDet[1]}]
set_load -pin_load 0.1 [get_ports {TSToDet[0]}]
set_load -pin_load 0.1 [get_ports LdCol]
set_load -pin_load 0.1 [get_ports RdCol]
set_load -pin_load 0.1 [get_ports LdPix]
set_load -pin_load 0.1 [get_ports PullDN]
set_load -pin_load 0.1 [get_ports {d_out[1]}]
set_load -pin_load 0.1 [get_ports {d_out[0]}]
set_load -pin_load 0.1 [get_ports clk_8n]
set_load -pin_load 0.1 [get_ports data_stop]
set_load -pin_load 0.1 [get_ports {Cnt4[1]}]
set_load -pin_load 0.1 [get_ports {Cnt4[0]}]
set_load -pin_load 0.1 [get_ports {Cnt5[2]}]
set_load -pin_load 0.1 [get_ports {Cnt5[1]}]
set_load -pin_load 0.1 [get_ports {Cnt5[0]}]
set_load -pin_load 0.1 [get_ports clkOut_4n]
set_false_path -from [get_clocks clk_16n] -to [get_clocks clkIn_4n]
set_false_path -from [list \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[0]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[10]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[11]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[12]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[13]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[14]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[15]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[16]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[17]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[18]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[19]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[1]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[20]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[21]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[22]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[23]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[24]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[25]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[26]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[27]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[28]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[29]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[2]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[30]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[31]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[32]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[33]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[34]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[35]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[36]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[37]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[38]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[39]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[3]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[4]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[5]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[6]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[7]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[8]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_TenToEight_reg[9]}] ] -to [list \
  [get_cells {SerializerTop_I_SerializerMain_I_Tree1L_reg[0]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_Tree1L_reg[1]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_Tree1L_reg[2]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_Tree1L_reg[3]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_Tree1L_reg[4]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_Tree1L_reg[5]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_Tree1L_reg[6]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_Tree1L_reg[7]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_Tree1R_reg[0]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_Tree1R_reg[1]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_Tree1R_reg[2]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_Tree1R_reg[3]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_Tree1R_reg[4]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_Tree1R_reg[5]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_Tree1R_reg[6]}]  \
  [get_cells {SerializerTop_I_SerializerMain_I_Tree1R_reg[7]}] ]
set_false_path -from [get_clocks clkIn_4n] -to [list \
  [get_clocks clk_800p]  \
  [get_clocks clk_3n2]  \
  [get_clocks clk_16n] ]
set_clock_groups -name asynch_clock      -asynchronous   -group [get_clocks clkIn_4n] -group [get_clocks clk_800p]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {RowAddFromDet[7]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {RowAddFromDet[6]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {RowAddFromDet[5]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {RowAddFromDet[4]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {RowAddFromDet[3]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {RowAddFromDet[2]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {RowAddFromDet[1]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {RowAddFromDet[0]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {ColAddFromDet[7]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {ColAddFromDet[6]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {ColAddFromDet[5]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {ColAddFromDet[4]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {ColAddFromDet[3]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {ColAddFromDet[2]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {ColAddFromDet[1]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {ColAddFromDet[0]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {TSFromDet[7]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {TSFromDet[6]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {TSFromDet[5]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {TSFromDet[4]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {TSFromDet[3]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {TSFromDet[2]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {TSFromDet[1]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {TSFromDet[0]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports PriFromDet]
set_input_delay -clock [get_clocks clk_8n] -network_latency_included -add_delay 2.0 [get_ports syncRes]
set_input_delay -clock [get_clocks clk_800p] -add_delay 0.1 [get_ports data_valid]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {ckdivend[3]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {ckdivend[2]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {ckdivend[1]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {ckdivend[0]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {timerend[3]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {timerend[2]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {timerend[1]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {timerend[0]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {slowdownend[3]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {slowdownend[2]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {slowdownend[1]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {slowdownend[0]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {maxcycend[5]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {maxcycend[4]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {maxcycend[3]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {maxcycend[2]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {maxcycend[1]}]
set_input_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {maxcycend[0]}]
set_output_delay -clock [get_clocks clk_800p] -add_delay 0.0 [get_ports clkOut_4n]
set_output_delay -clock [get_clocks clk_800p] -add_delay 0.0 [get_ports clk_8n]
set_output_delay -clock [get_clocks clk_800p] -add_delay 0.0 [get_ports {d_out[1]}]
set_output_delay -clock [get_clocks clk_800p] -add_delay 0.0 [get_ports {d_out[0]}]
set_output_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {TSToDet[7]}]
set_output_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {TSToDet[6]}]
set_output_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {TSToDet[5]}]
set_output_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {TSToDet[4]}]
set_output_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {TSToDet[3]}]
set_output_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {TSToDet[2]}]
set_output_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {TSToDet[1]}]
set_output_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports {TSToDet[0]}]
set_output_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports LdCol]
set_output_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports RdCol]
set_output_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports LdPix]
set_output_delay -clock [get_clocks clk_8n] -add_delay 2.0 [get_ports PullDN]
set_max_transition 0.5 [get_ports {TSToDetExt[7]}]
set_max_transition 0.5 [get_ports {TSToDetExt[6]}]
set_max_transition 0.5 [get_ports {TSToDetExt[5]}]
set_max_transition 0.5 [get_ports {TSToDetExt[4]}]
set_max_transition 0.5 [get_ports {TSToDetExt[3]}]
set_max_transition 0.5 [get_ports {TSToDetExt[2]}]
set_max_transition 0.5 [get_ports {TSToDetExt[1]}]
set_max_transition 0.5 [get_ports {TSToDetExt[0]}]
set_max_transition 0.5 [get_ports {TSToDet[7]}]
set_max_transition 0.5 [get_ports {TSToDet[6]}]
set_max_transition 0.5 [get_ports {TSToDet[5]}]
set_max_transition 0.5 [get_ports {TSToDet[4]}]
set_max_transition 0.5 [get_ports {TSToDet[3]}]
set_max_transition 0.5 [get_ports {TSToDet[2]}]
set_max_transition 0.5 [get_ports {TSToDet[1]}]
set_max_transition 0.5 [get_ports {TSToDet[0]}]
set_max_transition 0.5 [get_ports LdCol]
set_max_transition 0.5 [get_ports RdCol]
set_max_transition 0.5 [get_ports LdPix]
set_max_transition 0.5 [get_ports PullDN]
set_max_transition 0.5 [get_ports {d_out[1]}]
set_max_transition 0.5 [get_ports {d_out[0]}]
set_max_transition 0.5 [get_ports clk_8n]
set_max_transition 0.5 [get_ports clkOut_4n]
set_max_leakage_power 1000.0
set_max_dynamic_power 100000.0
set_input_transition 0.2 [get_ports PriFromDet]
set_input_transition 0.2 [get_ports {RowAddFromDet[7]}]
set_input_transition 0.2 [get_ports {RowAddFromDet[6]}]
set_input_transition 0.2 [get_ports {RowAddFromDet[5]}]
set_input_transition 0.2 [get_ports {RowAddFromDet[4]}]
set_input_transition 0.2 [get_ports {RowAddFromDet[3]}]
set_input_transition 0.2 [get_ports {RowAddFromDet[2]}]
set_input_transition 0.2 [get_ports {RowAddFromDet[1]}]
set_input_transition 0.2 [get_ports {RowAddFromDet[0]}]
set_input_transition 0.2 [get_ports {ColAddFromDet[7]}]
set_input_transition 0.2 [get_ports {ColAddFromDet[6]}]
set_input_transition 0.2 [get_ports {ColAddFromDet[5]}]
set_input_transition 0.2 [get_ports {ColAddFromDet[4]}]
set_input_transition 0.2 [get_ports {ColAddFromDet[3]}]
set_input_transition 0.2 [get_ports {ColAddFromDet[2]}]
set_input_transition 0.2 [get_ports {ColAddFromDet[1]}]
set_input_transition 0.2 [get_ports {ColAddFromDet[0]}]
set_input_transition 0.2 [get_ports {TSFromDet[7]}]
set_input_transition 0.2 [get_ports {TSFromDet[6]}]
set_input_transition 0.2 [get_ports {TSFromDet[5]}]
set_input_transition 0.2 [get_ports {TSFromDet[4]}]
set_input_transition 0.2 [get_ports {TSFromDet[3]}]
set_input_transition 0.2 [get_ports {TSFromDet[2]}]
set_input_transition 0.2 [get_ports {TSFromDet[1]}]
set_input_transition 0.2 [get_ports {TSFromDet[0]}]
set_input_transition 0.2 [get_ports {TSToDetExt[7]}]
set_input_transition 0.2 [get_ports {TSToDetExt[6]}]
set_input_transition 0.2 [get_ports {TSToDetExt[5]}]
set_input_transition 0.2 [get_ports {TSToDetExt[4]}]
set_input_transition 0.2 [get_ports {TSToDetExt[3]}]
set_input_transition 0.2 [get_ports {TSToDetExt[2]}]
set_input_transition 0.2 [get_ports {TSToDetExt[1]}]
set_input_transition 0.2 [get_ports {TSToDetExt[0]}]
set_input_transition 0.2 [get_ports LdColExt]
set_input_transition 0.2 [get_ports RdColExt]
set_input_transition 0.2 [get_ports LdPixExt]
set_input_transition 0.2 [get_ports PullDNExt]
set_input_transition 0.2 [get_ports ExternalSignalsEn]
set_input_transition 0.2 [get_ports {ckdivend[3]}]
set_input_transition 0.2 [get_ports {ckdivend[2]}]
set_input_transition 0.2 [get_ports {ckdivend[1]}]
set_input_transition 0.2 [get_ports {ckdivend[0]}]
set_input_transition 0.2 [get_ports {timerend[3]}]
set_input_transition 0.2 [get_ports {timerend[2]}]
set_input_transition 0.2 [get_ports {timerend[1]}]
set_input_transition 0.2 [get_ports {timerend[0]}]
set_input_transition 0.2 [get_ports {slowdownend[3]}]
set_input_transition 0.2 [get_ports {slowdownend[2]}]
set_input_transition 0.2 [get_ports {slowdownend[1]}]
set_input_transition 0.2 [get_ports {slowdownend[0]}]
set_input_transition 0.2 [get_ports {maxcycend[5]}]
set_input_transition 0.2 [get_ports {maxcycend[4]}]
set_input_transition 0.2 [get_ports {maxcycend[3]}]
set_input_transition 0.2 [get_ports {maxcycend[2]}]
set_input_transition 0.2 [get_ports {maxcycend[1]}]
set_input_transition 0.2 [get_ports {maxcycend[0]}]
set_input_transition 0.2 [get_ports {resetckdivend[3]}]
set_input_transition 0.2 [get_ports {resetckdivend[2]}]
set_input_transition 0.2 [get_ports {resetckdivend[1]}]
set_input_transition 0.2 [get_ports {resetckdivend[0]}]
set_input_transition 0.2 [get_ports sendcounter]
set_input_transition 0.2 [get_ports Aur_res_n]
set_input_transition 0.2 [get_ports Ser_res_n]
set_input_transition 0.2 [get_ports RO_res_n]
set_input_transition 0.2 [get_ports syncRes]
set_input_transition 0.2 [get_ports clk_800p]
set_input_transition 0.2 [get_ports data_valid]
set_input_transition 0.2 [get_ports clkIn_4n]
set_wire_load_selection_group "sub_micron" -library "h18_CORELIB_HV_WC"
set_dont_use [get_lib_cells h18_CORELIB_HV_WC/BUSHDX1_HV]
set_dont_use [get_lib_cells h18_CORELIB_HV_WC/FILLCELLX1_HV]
set_dont_use [get_lib_cells h18_CORELIB_HV_WC/FILLCELLX2_HV]
set_dont_use [get_lib_cells h18_CORELIB_HV_WC/FILLCELLX4_HV]
set_dont_use [get_lib_cells h18_CORELIB_HV_WC/FILLCELLX8_HV]
set_dont_use [get_lib_cells h18_CORELIB_HV_WC/FILLCELLX16_HV]
set_dont_use [get_lib_cells h18_CORELIB_HV_WC/FILLCELLX32_HV]
set_dont_use false [get_lib_cells h18_CORELIB_HV_WC/TIE0_HV]
set_dont_use false [get_lib_cells h18_CORELIB_HV_WC/TIE1_HV]
set_clock_uncertainty -setup 0.01 [get_clocks clk_800p]
set_clock_uncertainty -hold 0.05 [get_clocks clk_800p]
set_clock_uncertainty -setup 0.08 [get_clocks clkIn_4n]
set_clock_uncertainty -hold 0.08 [get_clocks clkIn_4n]
set_clock_uncertainty -setup 0.08 [get_clocks clk_8n]
set_clock_uncertainty -hold 0.08 [get_clocks clk_8n]
set_clock_uncertainty -setup 0.08 [get_clocks clk_3n2]
set_clock_uncertainty -hold 0.08 [get_clocks clk_3n2]
set_clock_uncertainty -setup 0.01 [get_clocks clk_1n6]
set_clock_uncertainty -hold 0.05 [get_clocks clk_1n6]
## List of unsupported SDC commands ##
set_propagated_clock [all_clocks]  
