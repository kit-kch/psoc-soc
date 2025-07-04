import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge

from cocotbext.spi import SpiBus
from model.spi_flash import SpiFlash

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")
    flash = SpiFlash(SpiBus.from_entity(dut, cs_name="xip_cs", miso_name="xip_sdi", mosi_name="xip_sdo", sclk_name="xip_clk"), "test_sw/demo_blink_led.raw_exe.bin")

    clkPin = dut.clk
    arstnPin = dut.arstn

    clock = Clock(clkPin, 10.172, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    arstnPin.value = 0
    await ClockCycles(clkPin, 10)
    arstnPin.value = 1
    # Wait till the application booted
    await(RisingEdge(dut.pwm0))
    # Simulate 1000 more cycles
    await ClockCycles(clkPin, 1000)