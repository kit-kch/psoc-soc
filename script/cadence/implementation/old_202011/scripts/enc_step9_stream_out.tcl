proc step9_stream_out { } {
    global design_name
    global layermap_filei
    global BASE

    #The "-edges noedge" switch is necessary for annotating the SDF file to the
    #standard cell models.
    exec mkdir -p stream_out
    write_sdf -view functional_slowHT -edges noedge ./stream_out/$design_name.slow.sdf
#    write_sdf -view view_PM_typical_functional -edges noedge ./stream_out/$design_name.typical.sdf
    write_sdf -view functional_fastLT -edges noedge ./stream_out/$design_name.fast.sdf
    
#     saveNetlist -includePowerGround -includePhysicalInst -excludeLeafCell ./stream_out/$design_name.v

    saveNetlist -flat -includePhysicalCell {FILLCAPX16_HV FILLCAPX32_HV FILLCAPX4_HV FILLCAPX8_HV} -excludeLeafCell ./stream_out/$design_name.lvs.v

    #saveNetlist -includePowerGround -includePhysicalInst -excludeLeafCell ./stream_out/$design_name.v



    #save an additional version of the netlist without the "-flat" switch for use in post place and rout simulation
    saveNetlist ./stream_out/$design_name.simulation.nonFlat.v

  set terms [dbGet top.terms]
  foreach term $terms {
     set pt [dbGet $term.pt]
     set port [get_ports [dbGet $term.name]]
     foreach p $pt {
        addCustomText [dbGet $term.layer.name] [get_property $port net_name] [lindex $p 0] [lindex $p 1] 0.1
     }
  }

  set terms [dbGet top.pgTerms]
  foreach term $terms {
     set pt [dbGet $term.pt]
     # no buses here
     set name [dbGet $term.name]
     foreach p $pt {
        addCustomText [dbGet $term.layer.name] $name [lindex $p 0] [lindex $p 1] 0.1
     }
  }

    #Stream out the GDS2 file
 #   streamOut ./stream_out/$design_name.gds -mapFile $layermap_file

    streamOut ./stream_out/$design_name.gds \
    -mapFile $BASE/implementation/scripts/gds2.map \

    #Save the final design state 
    saveDesign savings/save06_final.enc

}
