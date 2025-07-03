import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    clkPin = dut.clk
    arstnPin = dut.arstn

    clock = Clock(clkPin, 10.172, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    arstnPin.value = 0
    await ClockCycles(clkPin, 10)
    arstnPin.value = 1
    await ClockCycles(clkPin, 5000)