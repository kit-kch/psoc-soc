import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer

from cocotbext.spi import SpiBus
from model.spi_flash import SpiFlash

async def initializeSoC(dut, firmware):
    dut._log.info("Hooking up JTAG")
    dut.jtag_tms.value = 0
    dut.jtag_tdi.value = 0
    dut.jtag_tck.value = 0
    dut._log.info("Hooking up SPI flash")
    SpiFlash(SpiBus.from_entity(dut, cs_name="xip_cs", miso_name="xip_sdi", mosi_name="xip_sdo", sclk_name="xip_clk"), firmware)
    dut._log.info("Starting main clock")
    clock = Clock(dut.clk, 10.18, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.arstn.value = 0
    await ClockCycles(dut.clk, 10)
    dut.arstn.value = 1
    dut._log.info("Reset done")

from model.util import waitForEdge
@cocotb.test()
async def test_blink_led(dut):
    dut._log.info("Starting LED Blink Test")
    await initializeSoC(dut, "test_sw/demo_blink_led.raw_exe.bin")

    # Wait till the application booted. 300 us is enough
    await Timer(300, units='us')

    # Check that dut.pwm0 is high
    assert dut.pwm0.value == 1, "Pin pwm0 did not go high at expected time"

    # Check that dut.pwm1 is toggling
    for i in range(1, 10):
        await waitForEdge(dut.pwm1, 1000, True)
        await waitForEdge(dut.pwm1, 1000, False)


from model.audio_lp import collect_audio
@cocotb.test()
async def test_dac_test(dut):
    dut._log.info("Starting DAC Data Generation Test")
    await initializeSoC(dut, "test_sw/demo_dac_sin.raw_exe.bin")

    await cocotb.start_soon(collect_audio("demo_dac_sin.wav", "test_sw/demo_dac_sin.golden.wav", dut.clk, dut.dacl, int(48000000 * 0.05) + 1))