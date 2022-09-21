#! /bin/sh

#Create floorplan directory if it it not already existing
if [ \! -d ./floorplan ]
then
    mkdir ./floorplan
fi

#For some reason Encounter needs the target file to exist...
cd floorplan
touch floorplan.def
cd ..

# WIN=-win

#run encounter and generate the floorplan file
source /opt/eda/environment/edi110_path.bash
velocity ${WIN} -init ./scripts/generate_floorplan.tcl
