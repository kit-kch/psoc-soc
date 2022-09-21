proc step4_place_cells { } {
    #debug
    #setDelayCalMode -reportOutBound true

    #setOptMode -usefulSkew true #!!!!!
    #setOptMode -usefulSkew false
    setTrialRouteMode -maxRouteLayer 5
    setTrialRouteMode -minRouteLayer 2
    # Place the Design with the following command
    # Lots of placement options can be set by means of the setPlaceMode command 
    # before executing the placeDesign command
    # the inPlaceOpt switch turns on the optDesign with -preCTS
    #read_activity_file -format TCF -tcf_scope dcd_b_digital_block_full_sim_digital_top/dut_I ./power_intent/dcd_b_digital_block_togglecount.tcf
    #setPlaceMode -powerDriven true -maxRouteLayer 4 -wireLenOptEffort high

    setPlaceMode -timingDriven true -maxRouteLayer 5 -wireLenOptEffort high

    setOptMode -allEndPoints true
#    placeDesign -inPlaceOpt -incremental
    placeDesign -inPlaceOpt
    #run TimeDesign in preCTS mode
    timeDesign -preCTS
    timeDesign -hold -preCTS

    #optimize!
    optDesign -preCTS -outDir reports -prefix prects
}

proc step4a_save_placed_design { } {    
    #Save the design state after the cell placement
    saveDesign savings/save02_postCellPlacement.enc

}
