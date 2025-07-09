import cocotb

from common.lib.psoc import initializeSoC
from common.lib.util import waitForEdge, testDirPath
from cocotb.triggers import Timer


@cocotb.test()
async def test_blink_led(dut):
    dut._log.info("Starting LED Blink Test")
    await initializeSoC(dut, testDirPath("firmware.raw_exe.bin"))

    # Wait till the application booted. 300 us is enough
    await Timer(500, units='us')

    # Check that dut.pwm0 is high
    assert dut.pwm0.value == 1, "Pin pwm0 did not go high at expected time"

    # Check that dut.pwm1 is toggling
    for i in range(1, 10):
        await waitForEdge(dut.pwm1, 1000, True)
        await waitForEdge(dut.pwm1, 1000, False)