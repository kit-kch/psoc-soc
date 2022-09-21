#####################################################################
#
# First Encounter setup file
# Created by Encounter(R) RTL Compiler on 08/21/2014 17:04:52
#
#####################################################################


# This script is intended for use with Encounter version 4.2 or later.
#   Multiple timing modes require Encounter version 5.2 or later.
#   CPF requires Encounter version 6.2 or later.


# User Specified CPU usage for EDI
##################################
setMultiCpuUsage -localCpu no_value


# Design Import
###########################################################
loadConfig ./enc_1stOrder/MuPixDigitalTop.conf


# Mode Setup
###########################################################
source ./enc_1stOrder/MuPixDigitalTop.mode


# MSV Setup
###########################################################
loadCPF ./enc_1stOrder/MuPixDigitalTop.cpf
commitCPF -keepRows -powerDomain -power_switch


# The following is partial list of suggested prototyping commands.
# These commands are provided for reference only.
# Please consult the First Encounter documentation for more information.
#   Placement...
#     ecoPlace                     ;# legalizes placement including placing any cells that may not be placed
#     - or -
#     placeDesign -incremental     ;# adjusts existing placement
#     - or -
#     placeDesign                  ;# performs detailed placement discarding any existing placement
#   Optimization & Timing...
#     optDesign -preCTS            ;# performs trial route and optimization
#     timeDesign -preCTS           ;# performs timing analysis

