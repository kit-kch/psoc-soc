#!/bin/bash

rm -r build
mkdir build
cd build

vivado -source ../prj/gen_prj.tcl

