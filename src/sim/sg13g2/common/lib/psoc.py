import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

from cocotbext.spi import SpiBus
from common.lib.spi_flash import SpiFlash

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