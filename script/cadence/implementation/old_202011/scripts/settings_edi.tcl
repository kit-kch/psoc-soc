setMultiCpuUsage -localCpu 16
setDesignMode -process $design_mode

suppressMessage TECHLIB-436
# **WARN: (TCLCMD-513):.  No matching object found for 'SUSLIB_UCL_TT/UCL_CAP6'
suppressMessage TCLCMD-513
# **ERROR: (TCLCMD-917):. Cannot find 'library cells' that match 'SUSLIB_UCL_TT/UCL_CAP5'
suppressMessage TCLCMD-917
# WARNING (CTE-25): Line: x of File enc_2ndOrder/x.sdc : Skipped unsupported command: set_max_dynamic_power
suppressMessage CTE-25
# **WARN: (TECHLIB-436):. Attribute 'max_fanout' on 'output/inout' pin 'O' of cell 'INVXL' is not defined in the library.
suppressMessage TECHLIB-436
# **WARN: (ENCOPT-3058):	Cell L035dc/AND2 has already a dont_use attribute false.
suppressMessage ENCOPT-3058
# WARNING (POWER-1500): 2 cell(s) in the design have timing library models but do not have internal power data. (*TIE)
suppressMessage POWER-1500
# WARNING (POWER-1501): 2 cell(s) in the design have timing library models but do not have leakage power data. (*TIE)
suppressMessage POWER-1501
# WARNING (POWER-2152): Instance tie_0_cell1 (GNDTIE) has no static power..
suppressMessage POWER-2152

