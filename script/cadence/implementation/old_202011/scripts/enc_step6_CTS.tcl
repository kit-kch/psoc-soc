proc step6_cts_prep { } {
   global clockbuffer_cell
   optDesign -preCTS -outDir reports -prefix cts_prep

    setCTSMode -addClockRootProp true -optAddBuffer true -optLatency true -reportHTML true -routeBottomPreferredLayer 2 -routeClkNet false -routeTopPreferredLayer 5 -routeLeafBottomPreferredLayer 2 -routeLeafTopPreferredLayer 5 -powerAware true -synthLatencyEffort high -traceIoPinAsLeaf true
 #-powerAware true
   exec mkdir -p cts
   createClockTreeSpec -output ./cts/Clock.ctstch  -bufferList CLKBUFX4_HV CLKBUFX6_HV CLKBUFX8_HV CLKBUFX10_HV CLKBUFX3_HV CLKINVX32_HV CLKINVX24_HV CLKINVX16_HV CLKINVX2_HV CLKINVX4_HV
}

proc step6a_onlySetCTSMode { } {

    setCTSMode -addClockRootProp true -optAddBuffer true -optLatency true -reportHTML true -routeBottomPreferredLayer 2 -routeClkNet false -routeTopPreferredLayer 5 -routeLeafBottomPreferredLayer 2 -routeLeafTopPreferredLayer 5 -synthLatencyEffort high -powerAware true -traceIoPinAsLeaf true
}

proc step6b_cts { } {
    cleanupSpecifyClockTree

   #bufferTreeSynthesis -nets {RESET} -bufList {UCL_INV4 UCL_BUF UCL_BUF4 UCL_BUF8 UCL_BUF8_2 UCL_BUF16 UCL_INV16 UCL_BUF16B} -leafPorts {UCL_DFF_RES/RES UCL_DFF_SET/SET} -maxDelay +800ps -fixedBuf -fixedNet

    specifyClockTree -clkfile ./cts/Clock.ctstch

    clockDesign
    #ckSynthesis -report ./reports/clock.report -forceReconvergent -breakLoop

    #Doing postCTS optimization
    setOptMode -dynamicPowerEffort high -leakagePowerEffort high
    optDesign -postCTS -outDir reports -prefix postcts
    optDesign -postCTS -hold -outDir reports -prefix postcts_hold

    #The clock tree synthesis places clock buffers even if there is no space. That results in nasty DRC violations!
    #Execute refinePlace in order to correct the stuff
    refinePlace

    #Save the design state after the CTS
    saveDesign savings/save04_postCTS.enc

}

