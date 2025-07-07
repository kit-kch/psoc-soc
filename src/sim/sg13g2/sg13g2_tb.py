import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, FallingEdge, Timer, First

from cocotbext.spi import SpiBus
from model.spi_flash import SpiFlash

async def waitForEdge(signal, timeout, rising):
    if rising:
        edge = RisingEdge(signal)
    else:
        edge = FallingEdge(signal)

    result = await First(edge, Timer(timeout, units='ns'))
    assert result is edge, f"Signal {signal.name} did not {"rise" if rising else "fall"} in {timeout} ns"

@cocotb.test()
async def test_blink_led(dut):
    dut._log.info("Starting LED Blink Test")
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

    # Wait till the application booted. 300 us is enough
    await Timer(300, units='us')

    # Check that dut.pwm0 is high
    assert dut.pwm0.value == 1, "Pin pwm0 did not go high at expected time"

    # Check that dut.pwm1 is toggling
    for i in range(1, 10):
        await waitForEdge(dut.pwm1, 1000, True)
        await waitForEdge(dut.pwm1, 1000, False)


# from model.audio_lp import collect_audio

# @cocotb.test()
# async def test_dac_test(dut):
#     dut._log.info("Starting DAC Data Generation Test")
#     flash = SpiFlash(SpiBus.from_entity(dut, cs_name="xip_cs", miso_name="xip_sdi", mosi_name="xip_sdo", sclk_name="xip_clk"), "test_sw/demo_dac_sin.raw_exe.bin")

#     clkPin = dut.clk
#     arstnPin = dut.arstn

#     clock = Clock(clkPin, 10.172, units="ns")
#     cocotb.start_soon(clock.start())

#     # Reset
#     dut._log.info("Reset")
#     arstnPin.value = 0
#     await ClockCycles(clkPin, 10)
#     arstnPin.value = 1

#     audio = cocotb.start_soon(collect_audio("demo_dac_sin.wav", "test_sw/demo_dac_sin.golden.wav", dut.clk, dut.dacl, int(48000000 * 0.05) + 1))
#     await audio