#Base from environment
set BASE $::env(BASE)


## Location of the current script
set location [file dirname [file normalize [info script]]]

## First Free the design 
catch {freeDesign}

## 180nm configuration
setDesignMode -process 180
set std_cell_height 5.04
#setDelayCalMode -engine Aae -signoff false -SIAware false
setDelayCalMode -engine default -signoff false -SIAware true

## Tool setup 
setLimitedAccessFeature ediUsePreRouteGigaOpt 1
setDesignMode -highSpeedCore true
setMultiCpuUsage -localCpu 8 -keepLicense false
setDistributeHost -local

#### MMMC Setup
###############################


source  $location/encounter_load_libraries.tcl
puts "Out of load libraries \n"
## Set Design
###############################
set init_verilog "../synthesis/netlist/encoder_top.gtl.v"
set init_top_cell encoder_top

## Init
#########################

suppressMessage ENCLF-122

## Init design by giving corner pairs for hold/setup
init_design -setup [list functional_slowHT ] -hold [list functional_fastLT]
init_design -setup [list test_slowHT ] -hold [list test_fastLT]



#### Opt Mode Setup 
###################
#setOptMode -maxLength    1000
#setOptMode -effort low          
#setOptMode -clkGateAware true
#setOptMode -allEndPoints true
#setOptMode -fixFanoutLoad true
