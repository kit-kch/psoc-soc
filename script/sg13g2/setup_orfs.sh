#!/bin/bash
set -e

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
export FLOW_HOME=$PWD/flow

# If in IIC-OSIC-TOOLS container
if [ -n "$TOOLS" ]; then
    # Check that the ORFS version matches
    if [ -f "$TOOLS/openroad-latest/ORFS_COMMIT" ] && ! cmp -s "$TOOLS/openroad-latest/ORFS_COMMIT" ../ORFS_COMMIT; then
        echo "ORFS commit in $TOOLS/openroad-latest/ORFS_COMMIT '$(cat $TOOLS/openroad-latest/ORFS_COMMIT)'"
        echo "does not match the ORFS_COMMIT in the repo '$(cat ../ORFS_COMMIT)'"
        echo "Are you using the right IIC-OSIC-TOOLS version?"
        exit 1
    fi
    export YOSYS_EXE=$TOOLS/yosys/bin/yosys
    export OPENROAD_EXE=$TOOLS/openroad-latest/bin/openroad
    export OPENSTA_EXE=$TOOLS/openroad-latest/bin/sta
fi

popd