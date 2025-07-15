import cocotb

from common.lib.psoc import initializeSoC
from common.lib.audio_lp import collect_audio
from common.lib.util import buildDirPath, testDirPath

@cocotb.test()
async def test_dac_sin(dut):
    dut._log.info("Starting DAC Data Generation Test")
    await initializeSoC(dut, testDirPath("firmware.raw_exe.bin"))

    await collect_audio(buildDirPath("test_dac_sin.wav"), testDirPath("test_dac_sin.golden.wav"),
                                     dut.clk, dut.dacl, int(48000000 * 0.05) + 1)