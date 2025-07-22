import cocotb

from common.lib.psoc import initializeSoC
from common.lib.util import waitForEdge, testDirPath

@cocotb.test()
async def test_mem_quick(dut):
    dut._log.info("Starting Quick Memory Test")
    await initializeSoC(dut, testDirPath("firmware.raw_exe.bin"))
    # LED goes high if tests is ok
    await waitForEdge(dut.pwm1, 10*1000*1000, True)