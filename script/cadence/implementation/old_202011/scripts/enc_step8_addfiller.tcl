proc step8_add_filler_cells { } {
    global filler_cell
    
    #add filler cells to the design
    addFiller -cell $filler_cell -prefix FILLER

}
