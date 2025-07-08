from cocotb.triggers import RisingEdge, FallingEdge, Timer, First

async def waitForEdge(signal, timeout, rising):
    if rising:
        edge = RisingEdge(signal)
    else:
        edge = FallingEdge(signal)

    result = await First(edge, Timer(timeout, units='ns'))
    verb = "rise" if rising else "fall"
    assert result is edge, f"Signal {signal.name} did not {verb} in {timeout} ns"

import os
def buildDirPath(file):
    base = os.getenv("SIM_BUILD", ".build")
    return os.path.join(base, file)

import inspect
def testDirPath(file):
    base = os.path.dirname(inspect.stack()[1][1])
    return os.path.join(base, file)