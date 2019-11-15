#!/usr/bin/env python3
from xml.dom import minidom, Node
import sys

# This script reformats a .mmi file for updatemem.
# updatemem tool. 
#
# According to our observations, the following constraints must hold for updatemem
# to work properly:
# * In each AddressSpace, there can be only one BitLane with the same MSB/LSB.
#   E.g. you can't have these two BitLanes in one AddressSpace:
#   <BitLane MemType="RAMB32" Placement="X3Y2">
#          <DataWidth MSB="0" LSB="0" />
#          <AddressRange Begin="0" End="32767" />
#   <BitLane MemType="RAMB32" Placement="X3Y2">
#          <DataWidth MSB="0" LSB="0" />
#          <AddressRange Begin="32768" End="..." />
#   Instead, move them to different AddressSpaces. However, different
#   AddressSpaces have to be addressed explicitly in the .mem file, see
#   vivado_gen_mem.py.
# * RAMs have to be sorted from MSB to LSB.
#
# Usage: vivado_fix_mmi.py input.mmi > output.mmi 

def compElem1(el):
    return int(el.getElementsByTagName("DataWidth")[0].getAttribute("LSB"))

def compElem2(el):
    return int(el.getElementsByTagName("AddressRange")[0].getAttribute("Begin"))

def filtElem(el):
    return el.nodeType == Node.ELEMENT_NODE

fileName = sys.argv[1]
with open(fileName, 'r') as mmiFile:
    mmi = mmiFile.read()

    # Remove leading whitespace, xml declaration has to be in first line
    mmi = mmi.lstrip()

    root = minidom.parseString(mmi)
    block = root.getElementsByTagName("BusBlock")[0]

    block.childNodes = filter(filtElem, block.childNodes)
    block.childNodes = sorted(block.childNodes, key=compElem1, reverse=True)
    block.childNodes = sorted(block.childNodes, key=compElem2)
    
    addrSpace = root.getElementsByTagName("AddressSpace")[0]
    #print(block.childNodes[0].getElementsByTagName("AddressRange")[0].getAttribute("Begin"))
    addrs = set(map(lambda e : int(e.getElementsByTagName("AddressRange")[0].getAttribute("Begin")), block.childNodes))
    addrs = sorted(addrs)
    newABlocks = []
    for addr in addrs:
        ablocks = list(filter(lambda e : int(e.getElementsByTagName("AddressRange")[0].getAttribute("Begin")) == addr, block.childNodes))
        addrSpace2 = addrSpace.cloneNode(deep=False)
        addrSpace2.setAttribute("Begin", str(addr))
        addrSpace2.setAttribute("End", str(ablocks[0].getElementsByTagName("AddressRange")[0].getAttribute("End")))
        newABlocks.append(addrSpace2)
        addrSpace2.childNodes = [root.createElement("BusBlock")]
        addrSpace2 = addrSpace2.childNodes[0]
        addrSpace2.childNodes = ablocks
        

    proc = root.getElementsByTagName("Processor")[0]
    proc.childNodes = newABlocks

    print(root.toxml())
