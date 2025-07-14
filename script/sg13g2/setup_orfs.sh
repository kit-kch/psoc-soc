#!/bin/bash
if [ ! -d "orfs" ]; then
    git clone --quiet --filter=blob:none https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git orfs
elif [ ! -d "orfs/.git" ]; then
    # When gitlab restored artifacts, but the repos was not yet cloned
    pushd orfs
    git init
    git config --global --add safe.directory $PWD
    git remote add origin https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git
    git fetch origin
    popd
fi
pushd orfs
git checkout $(cat ../ORFS_COMMIT)

export YOSYS_EXE=$TOOLS/yosys/bin/yosys
export OPENROAD_EXE=$TOOLS/openroad-latest/bin/openroad
export OPENSTA_EXE=$TOOLS/openroad-latest/bin/sta
export FLOW_HOME=$PWD/flow

popd