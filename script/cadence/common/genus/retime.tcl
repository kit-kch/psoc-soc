
proc adl_retime_disable_all_clocks args {

    foreach_in_collection clk [get_clocks] { 
        #puts "C: [get_object_name $clk]"; 
        puts "## ADL## Disabling clock  [get_object_name $clk]"
        set_db [all::all_seqs -clock [get_object_name $clk]] .dont_retime true 
        
    }
}

proc adl_retime_clock name {

    ## Disable retime and enable on this clock
    adl_retime_disable_all_clocks
     set_db [all::all_seqs -clock $name] .dont_retime false

     ## Retime for delay
     retime -prepare 
     retime -min_delay
}

proc adl_retime_all_clocks args {

     foreach_in_collection clk [get_clocks] { 
        #puts "C: [get_object_name $clk]"; 
        puts "## ADL## Retiming clock  [get_object_name $clk]"
        adl_retime_clock  [get_object_name $clk]
        
    }

}

proc adl_retime_get_possible_clocks args {

     foreach_in_collection clk [get_clocks] { 
        #puts "C: [get_object_name $clk]"; 
        puts "## ADL## Clock:  [get_object_name $clk]"
        
    }

}

proc adl_retime_clocks args {

     foreach clk_name $args { 
        #puts "C: [get_object_name $clk]"; 
        puts "## ADL## Retiming clock $clk_name"
        adl_retime_clock  $clk_name
        
    }

}

