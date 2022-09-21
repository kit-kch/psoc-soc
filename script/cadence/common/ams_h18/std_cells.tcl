############################
## This File Contains an array definition of standard cells for TSI
## These utilities are meant to easily use the design kit which has rather long file names
## Also this file will help better change cell sets to compare behaviour between corners
##################################

set scriptLocation [file normalize [file dirname [info script]]]


## Some Folders from design kit to make the floy script more readable
#####################

set AMS_HOME  $::env(AMS_HOME)


## Base folder where the lib files for each cell library and corners are located
array set ::STD_CELLS {}

## Define Corner libs and lef files
#################################
set lefAvailableMetals  {3AM 4AM 5AM 6AM 7AM}
set cellLibs            {CORELIB CORELIB_HV CORELIB_HVT CORELIB_TW IOLIB IOLIB_HV PHYSICAL }
set timingCorners 		{BC WC TYP}
set corners             {fast_v132_tm40  fast_v132_tm55  fast_v198_tm40  fast_v198_tm55  slow_v108_t125  slow_v162_t125  typ_v120_t025  typ_v180_t025}

foreach voltageFolder [glob -types d  $AMS_HOME/liberty/*] {
	
	foreach cellLib $cellLibs {
		
		
		
		## General Lib
		set generalLib $voltageFolder/ah18_$cellLib.lib
		if {[file exists $generalLib]} {
			set STD_CELLS($cellLib/lib/$voltageFolder/ALL) $generalLib
		}
		
		## Timing corner files
		foreach timingCorner $timingCorners {
		
			set timingFile $voltageFolder/ah18_${cellLib}_${timingCorner}.lib
			#puts "Testing: $timingFile"
			if {[file exists $timingFile]} {
				set STD_CELLS($cellLib/lib/[file tail $voltageFolder]/$timingCorner) $timingFile
			}
			
		}
			
		
	}
	
}

foreach voltageFolder [glob -types d  $AMS_HOME/synopsys/*] {
	
	foreach cellLib $cellLibs {
		
		## General Lib
		set generalLib $voltageFolder/ah18_$cellLib.db
		if {[file exists $generalLib]} {
			set STD_CELLS($cellLib/cdb/$voltageFolder/ALL) $generalLib
		}
		
		## Timing corner files
		foreach timingCorner $timingCorners {
		
			set timingFile $voltageFolder/ah18_${cellLib}_${timingCorner}.db
			#puts "Testing DB: $timingFile"
			if {[file exists $timingFile]} {
				set STD_CELLS($cellLib/cdb/[file tail $voltageFolder]/$timingCorner) $timingFile
			}
			
		}
			
		
	}
	
}

## LEF
foreach cellLib $cellLibs {
	
	set commonLEF $AMS_HOME/cds/HK_AH18/LEF/ah18a6/ah18a6.lef
	set STD_CELLS($cellLib/lef/common) [list $commonLEF $scriptLocation/CTS_ROUTES.lef]
	
	set libLef $AMS_HOME/cds/HK_AH18/LEF/ah18a6/$cellLib.lef
	if {[file exists $libLef]} {
		set STD_CELLS($cellLib/lef/a6) $libLef 
	}
	
}

## Physical
set STD_CELLS(physical/tie)     [list TIE0_HV TIE1_HV]
#set STD_CELLS(physical/gdsmap)  $AMS_HOME/cds/HK_H18/TECH_H18A7AM/TECH_H18A7AM.layermap 
#set STD_CELLS(physical/gdsmap)  $AMS_HOME/cds/HK_H18/TECH_H18A7AM/strmInOut.layertable 
set STD_CELLS(physical/gdsmap)  $scriptLocation/gds2.map
set STD_CELLS(physical/fillers) [list FILLCELLX1_HV FILLCELLX2_HV  FILLCAPX16_HV FILLCAPX32_HV FILLCAPX4_HV FILLCAPX8_HV]
set STD_CELLS(physical/fillcaps) [list FILLCAPX16_HV FILLCAPX32_HV FILLCAPX4_HV FILLCAPX8_HV]

## QRC
set STD_CELLS(qrc/a6/min) $AMS_HOME/assura/ah18a6/ah18a6/QRC-best/qrcTechFile
set STD_CELLS(qrc/a6/max) $AMS_HOME/assura/ah18a6/ah18a6/QRC-worst/qrcTechFile

## Utils
#######################
namespace  eval std_cells {
	proc print_stdcells args {
		puts "(ADL) Printing available STD Cells definitions"
		foreach k [lsort [array names ::STD_CELLS]] {
			puts "$k -> $::STD_CELLS($k)" 
		}
	}
}


##std_cells::print_stdcells

return

