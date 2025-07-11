#!/bin/bash
pushd src/sim/sg13g2

mkdir -p .build
if [ ! -d ".build/env" ]; then
    python3 -m venv .build/env
fi

source .build/env/bin/activate
pip install --upgrade pip
pip install -r common/requirements.txt

popd