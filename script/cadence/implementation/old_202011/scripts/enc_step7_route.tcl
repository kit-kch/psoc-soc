proc step7_route { } {
    # we get no multi-cuts without this command, but a SEGV with it...
    generateVias

    setNanoRouteMode -routeBottomRoutingLayer 2 -routeTopRoutingLayer 5 -routeWithTimingDriven true -routeWithSiDriven true  -routeWithViaInPin true -routeWithViaOnlyForStandardCellPin 1:1 -drouteUseMultiCutViaEffort high

    ## Antenna Fix
    setNanoRouteMode -drouteFixAntenna true
    setNanoRouteMode -routeAntennaCellName ANTENNA_HV 

    # /opt/eda/EDI120/doc/timingclosure/Detailed_Routing.html
    changeUseClockNetStatus -noFixedNetWires

    #The new preferred routing command is routeDesign
    routeDesign

    #Doing post routing optimization
    setExtractRCMode -engine postRoute
    setAnalysisMode -analysisType onChipVariation -cppr both
    optDesign -postRoute -outDir reports -prefix postroute
    optDesign -postRoute -hold -outDir reports -prefix postroute_hold

    #Save the design state after the power planning
    saveDesign savings/save05_postRouting.enc
}

proc step7a_viaOpt { } {
    setNanoRouteMode -drouteMinSlackForWireOptimization 0.1
    setNanoRouteMode -droutePostRouteSwapVia multiCut
    routeDesign -viaOpt
}

proc step7b_si { } {
   setExtractRCMode -coupled true
   setDelayCalMode -engine default -siAware true
   setOptMode -fixHoldAllowSetupTnsDegrade true
   setSIMode -deltaDelayThreshold -1 -analysisType default
 #  optDesign -postRoute -si -hold -outDir reports -prefix postroute_si_hold
#The 'optDesign -postRoute -si [-hold]' command is obsolete. To avoid this message and ensure compatibility with future releases use the latest SI Optimization technology by ensuring 'setDelayCalMode -engine default -siAware true' is set & calling 'optDesign -postRoute [-hold]'
   optDesign -postRoute -hold -outDir reports -prefix postroute_si_hold
   setAnalysisMode -cppr none
   optDesign -postRoute -outDir reports -prefix postroute_si
}
