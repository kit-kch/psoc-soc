	## Base from environment
set BASE $::env(BASE)

## We only set some variables here, the actual init design call is done in the main script

#set captable_filename /adl/design_kits/AMS/c18-h18-hitkit411/cds/HK_H18/LEF/h18a6/h18a6.capTable
set captable_filename /eda/design_kits/AMS/ah18-hitkit414/cds/HK_AH18/LEF/ah18a6/ah18a6-worst.capTable
#set captable_filename /eda/design_kits/AMS/ah18-hitkit414/cds/HK_AH18/LEF/ah18a6/ah18a6-typical.capTable
## Load Library files using Multi Mode Multi Corner
#########################

#### First: Create Library Sets 
#create_library_set -name slowHT \
    -timing [list /eda/design_kits/AMS/c18-h18-hitkit411/liberty/h18_1.8V/h18_CORELIB_HV_WC.lib \
     ] \
    -si     [list /eda/design_kits/AMS/c18-h18-hitkit411/synopsys/h18_1.8V/h18_CORELIB_HV_WC.db \
     ]

#create_library_set -name fastLT \
    -timing [list /eda/design_kits/AMS/c18-h18-hitkit411/liberty/h18_1.8V/h18_CORELIB_HV_BC.lib \
     ] \
    -si     [list /eda/design_kits/AMS/c18-h18-hitkit411/synopsys/h18_1.8V/h18_CORELIB_HV_BC.db \
     ]

create_library_set -name slowHT \
    -timing [list /eda/design_kits/AMS/ah18-hitkit414/liberty/ah18_1.8V/ah18_CORELIB_HV_WC.lib \
     ] \
    -si     [list /eda/design_kits/AMS/ah18-hitkit414/synopsys/ah18_1.8V/ah18_CORELIB_HV_WC.db \
     ]

create_library_set -name fastLT \
    -timing [list /eda/design_kits/AMS/ah18-hitkit414/liberty/ah18_1.8V/ah18_CORELIB_HV_BC.lib \
     ] \
    -si     [list  /eda/design_kits/AMS/ah18-hitkit414/synopsys/ah18_1.8V/ah18_CORELIB_HV_BC.db \
     ]

create_library_set -name typ \
     -timing [list /eda/design_kits/AMS/ah18-hitkit414/liberty/ah18_1.8V/ah18_CORELIB_HV_TYP.lib \
      ] \
     -si     [list  /eda/design_kits/AMS/ah18-hitkit414/synopsys/ah18_1.8V/ah18_CORELIB_HV_TYP.db \
      ]



#### Second: Constraints
create_constraint_mode -name functional -sdc_files $BASE/implementation/constraints/constraints_functionalMode.sdc
create_constraint_mode -name test -sdc_files $BASE/implementation/constraints/constraints_testMode.sdc 

#### Third: Create a delay corner ??
create_rc_corner -name rcfastLT \
   -cap_table $captable_filename \
   -preRoute_res 0.5 \
   -preRoute_cap 0.93 \
   -preRoute_clkres 0.5 \
   -preRoute_clkcap 0.93 \
   -postRoute_res 0.5 \
   -postRoute_cap 0.93 \
   -postRoute_clkres 0.5 \
   -postRoute_xcap 0.93 \
   -T 50

create_rc_corner -name rcslowHT \
   -cap_table $captable_filename \
   -preRoute_res 1.5 \
   -preRoute_cap 1.07 \
   -preRoute_clkres 1.5 \
   -preRoute_clkcap 1.07 \
   -postRoute_res 1.5 \
   -postRoute_cap 1.07 \
   -postRoute_clkres 1.5 \
   -postRoute_xcap 1.07 \
   -T 50



create_delay_corner -name slowHTrcw -library_set slowHT -rc_corner rcslowHT
create_delay_corner -name fastLTrcb -library_set fastLT -rc_corner rcfastLT


#### Final: Create view
create_analysis_view -name functional_slowHT -constraint_mode functional -delay_corner slowHTrcw
create_analysis_view -name functional_fastLT -constraint_mode functional -delay_corner fastLTrcb
create_analysis_view -name test_slowHT -constraint_mode test -delay_corner slowHTrcw
create_analysis_view -name test_fastLT -constraint_mode test -delay_corner fastLTrcb

## LEF Files 
######################

#set init_lef_file [list \
    /adl/design_kits/AMS/c18-h18-hitkit411/cds/HK_H18/LEF/h18a6/h18a6.lef \
    /adl/design_kits/AMS/c18-h18-hitkit411/cds/HK_H18/LEF/h18a6/CORELIB_HV.lef ]

set init_lef_file [list \
    /eda/design_kits/AMS/ah18-hitkit414/cds/HK_AH18/LEF/ah18a6/ah18a6.lef \
    /eda/design_kits/AMS/ah18-hitkit414/cds/HK_AH18/LEF/ah18a6/CORELIB_HV.lef ]
