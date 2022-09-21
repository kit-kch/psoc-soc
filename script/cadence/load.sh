#!/bin/bash 

## This script will load the AMS H18 Technology design kit as well as the required software tools from Cadence:
## - XCELIUM for digital simulation
## - Genus/Innovus for Synthesis and Place and Route
## - Virtuoso/Spectre for analog simulation and layout if necessary
source /tools/psoc/psoc.sh amsah18

## This Environment variable saves the current folder path
##  Subsequent scripts and configuration files can reference file paths using $BASE so that scripts are independent from the current user
export BASE="$(dirname "$(readlink -f ${BASH_SOURCE[0]})")"

## Create Some Aliases to quickly call the tools
##########
alias psoc_synthesis="reset && genus -overwrite -files $BASE/implementation/synthesis/synthesize.tcl"
alias psoc_par="reset && innovus -files $BASE/implementation/placeandroute/innovus_parameters.tcl"

alias psoc_sim_rtl="reset && xrun -f $BASE/verification/sim_rtl.f"
alias psoc_sim_gtl="reset && xrun -f $BASE/verification/sim_gtl.f"
alias psoc_sim_par="reset && xrun -f $BASE/verification/sim_par.f"
alias psoc_sim_par_delay="reset && xrun -f $BASE/verification/sim_par.f -define SDF_ANNOTATE"
