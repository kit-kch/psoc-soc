proc step8b_verify { } {
#   setDelayCalMode -engine signalStorm
   setExtractRCMode -coupled true
#   setAnalysisMode -cppr none
#   The analysis mode needs to be set to 'OCV' in post route stage for post route timing & optimization. To avoid this message & allow post route steps to proceed set 'setAnalysisMode -analysisType onChipVariation'. It is also recommended to set '-cppr both' alongside this to remove clock re-convergence pessimism for both setup and hold modes
  
   setAnalysisMode -analysisType onChipVariation -cppr both 

   setExtractRCMode -engine postRoute -effortLevel low -coupled true
   extractRC
#   rcOut -rc_corner rc_max -spef rc_max.spef.gz
#   rcOut -rc_corner rc_min -spef rc_min.spef.gz
   
#   setDelayCalMode -engine signalStorm
   setDelayCalMode -engine default -SIaware true 
#  timeDesign -prefix signoff -signoff -si -outDir reports -reportOnly 
#  timeDesign -prefix signoff -signoff -si -reportOnly -outDir reports -hold
#The command 'timeDesign -signoff -si [-hold | -reportOnly]' is obsolete. To avoid this warning and to ensure compatibility with future releases you should use the very latest Signoff AAE SI Analysis. To do this ensure that'setDelayCalMode -engine default -siAware true' is set & use 'timeDesign-signoff [-hold | -reportOnly]'   
   timeDesign -prefix signoff -signoff -outDir reports -reportOnly
   timeDesign -prefix signoff -signoff -outDir reports -reportOnly -hold
   summaryReport -outDir reports
   verifyConnectivity -noAntenna
   verifyGeometry
   verifyProcessAntenna
   report_power -outfile reports/power.txt
   reportGateCount -outfile reports/gatecount.txt
}

