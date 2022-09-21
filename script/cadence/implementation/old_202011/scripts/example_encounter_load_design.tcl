

## Location of the current script
set location [file dirname [file normalize [info script]]]

## First Free the design 
catch {freeDesign}

## 65nm configuration
setDesignMode -process 65
setDelayCalMode -engine Aae -signoff false -SIAware false


## Tool setup 
setLimitedAccessFeature ediUsePreRouteGigaOpt 1
setDesignMode -highSpeedCore true
setMultiCpuUsage -localCpu 8 -keepLicense false
setDistributeHost -local

#### MMMC Setup
###############################


source  $location/load_libraries.tcl

## Set Design
###############################
set init_verilog "../run_synth/netlist/counter_top.gtl.v"
set init_top_cell counter_top

## Init
#########################

suppressMessage ENCLF-122

## Init design by giving corner pairs for hold/setup
init_design -setup [list functional_worstHT ] -hold [list functional_bestLT]



#### Opt Mode Setup 
###################
setOptMode -maxLength    1000
setOptMode -effort low          
setOptMode -clkGateAware true
setOptMode -allEndPoints true
setOptMode -fixFanoutLoad true
