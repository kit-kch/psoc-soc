#!/usr/bin/env bash
set -e

# NEORV32 home folder
NEORV32_HDL="../../ext/neorv32/rtl"
# Name of the top unit
TOP=neorv32_wrap
# Original NEORV32 source files
NEORV32_FILES=$(sed "s|NEORV32_RTL_PATH_PLACEHOLDER|$NEORV32_HDL|g" src/hdl/sg13g2/file_list_soc.f)
# Modified or extra files
EXTRA_FILES="../../src/hdl/neorv32_wrap.vhd \
    ../../ext/psoc_xip_bootloader/bootloader_tiny/neorv32_bootloader_image.vhd"

rm -rf build/ghdl
mkdir -p build/ghdl
pushd build/ghdl

# show NEORV32 version
echo "NEORV32 Version:"
grep -rni $NEORV32_HDL/core/neorv32_package.vhd -e 'hw_version_c'
echo ""

# Import and analyze sources
ghdl -i --std=08 --work=neorv32 --workdir=. -P. $NEORV32_FILES $EXTRA_FILES
ghdl -m --std=08 --work=neorv32 --workdir=. $TOP
# Synthesize Verilog
ghdl synth --std=08 --work=neorv32 --workdir=. -P. --out=verilog $TOP > ../../src/hdl/sg13g2/neorv32_wrap.v
popd

# Show interface of generated Verilog module
echo ""
echo "-----------------------------------------------"
echo "Verilog instantiation prototype"
echo "-----------------------------------------------"
sed -n "/module $TOP/,/);/p" ./src/hdl/sg13g2/neorv32_wrap.v
echo "-----------------------------------------------"
echo ""