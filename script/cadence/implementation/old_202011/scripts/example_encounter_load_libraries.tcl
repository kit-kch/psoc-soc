

## We only set some variables here, the actual init design call is done in the main script


## Load Library files using Multi Mode Multi Corner
#########################

#### First: Create Library Sets 
create_library_set -name worstHT \
    -timing [list $::env(UMC_HOME)/65nm-stdcells/synopsys/uk65lscllmvbbr_108c125_wc.lib \
     $::env(UMC_HOME)/65nm-pads/synopsys/u065gioll18gpir_wc.lib] \
    -si     [list $::env(UMC_HOME)/65nm-stdcells/synopsys/uk65lscllmvbbr_108c125_wc.db \
     $::env(UMC_HOME)/65nm-pads/synopsys/u065gioll18gpir_wc.db]

create_library_set -name bestLT \
    -timing [list $::env(UMC_HOME)/65nm-stdcells/synopsys/uk65lscllmvbbr_132c0_bc.lib \
      $::env(UMC_HOME)/65nm-pads/synopsys/u065gioll18gpir_bc.lib] \
    -si     [list $::env(UMC_HOME)/65nm-stdcells/synopsys/uk65lscllmvbbr_132c0_bc.db \
      $::env(UMC_HOME)/65nm-pads/synopsys/u065gioll18gpir_bc.db]


#### Second: Constraints
create_constraint_mode -name functional -sdc_files $location/../sources/constraints.sdc


#### Third: Create a delay corner ??
create_rc_corner -name rcworstHT   -T 125
create_rc_corner -name rcbestLT   -T 0

create_delay_corner -name worstHTrcw -library_set worstHT -rc_corner rcworstHT
create_delay_corner -name bestLTrcb -library_set bestLT -rc_corner rcbestLT


#### Final: Create view
create_analysis_view -name functional_worstHT -constraint_mode functional -delay_corner worstHTrcw
create_analysis_view -name functional_bestLT -constraint_mode functional -delay_corner bestLTrcb

## LEF Files 
######################

set init_lef_file [list \
    $::env(UMC_HOME)/65nm-stdcells/lef/tf/uk65lscllmvbbr_9m2t1f.lef \
    $::env(UMC_HOME)/65nm-stdcells/lef/uk65lscllmvbbr.lef \
    $::env(UMC_HOME)/65nm-pads/lef/u065gioll18gpir_9m2t2h.lef]

#    $::env(UMC_HOME)/65nm-pads/lef/u065gioll18gpir_9m2t2h.lef \
$::env(UMC_HOME)/65nm-pads/lef/tf/u065gioll18gpir_9m2t2h.lef
