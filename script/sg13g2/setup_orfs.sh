#!/bin/bash
git clone --quiet --filter=blob:none https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git orfs
pushd orfs
git checkout $(cat $TOOLS/openroad-latest/ORFS_COMMIT)

export YOSYS_EXE=$TOOLS/yosys/bin/yosys
export OPENROAD_EXE=$TOOLS/openroad-latest/bin/openroad
export OPENSTA_EXE=$TOOLS/openroad-latest/bin/sta
export FLOW_HOME=$PWD/flow

popd