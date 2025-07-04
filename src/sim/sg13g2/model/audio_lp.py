import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

import numpy as np
from scipy.signal import butter, lfilter
import wave

class AudioFilter:
    def __init__(self):
        order = 5
        nyquist = 0.5 * 24000000
        high = 20000 / nyquist
        self.b, self.a = butter(order, high, btype='low', analog=False)
        self.z = np.zeros(self.b.size - 1)

        self.wf = wave.open("output.wav", 'wb')
        #self.rwf = wave.open("golden.wav", 'rb')
        self.wf.setnchannels(1)
        self.wf.setsampwidth(2)
        self.wf.setframerate(48000)

    # Filter by chunks of 2048 samples (float)
    def __filter(self, data):
        y, self.z = lfilter(self.b, self.a, data, zi = self.z)
        return y

    # Filter by chunks of 2048 samples (float)
    def process(self, data):
        filtered = self.__filter(data)
        resampled = [filtered[255], filtered[767], filtered[1279], filtered[1791]]

        # Convert to int16
        resampled = np.clip(resampled, 0, 1)
        resampled_i16 = (resampled * np.iinfo(np.int16).max).astype(np.int16)

        # Save to wav
        self.wf.writeframes(resampled_i16.tobytes())

        # Compare to reference
        #refdata = self.rwf.readframes(4)
        #assert resampled_i16.tobytes() == refdata, "Data does not match reference"

    def finish(self):
        self.wf.close()

async def collect_audio(clkPin, audioPin, samples = 48000001):
    af = AudioFilter()
    
    buf = np.zeros(2048)
    # 1 second of data
    for i in range(1, samples):
        if (audioPin.value.is_resolvable):
            sample = audioPin.value.integer
        else:
            sample = 0
        buf[i % 2048] = sample
        if (i % 2048 == 2043):
            af.process(buf)
        await ClockCycles(clkPin, 1)

    af.finish()

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock to 24 MHz
    clock = Clock(dut.clk, 41.666, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.rst_n.value = 1
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.uio_in[0].value = 1
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 0

    # Reset needs to be quite long, as its synchronous on slow clk
    await ClockCycles(dut.clk, int(0.003125 * 24000000))
    dut.rst_n.value = 1

    dut._log.info("Testing Audio Generation")
    spi = CD101SPI(dut)

    config = SPIConfig(10, -1, 145, -1, 153, 102, 153)
    await spi.set_config(False, config)
    await ClockCycles(dut.clk, 10)
    
    receiver = cocotb.start_soon(collect_output(dut))
    await ClockCycles(dut.clk, 10)
    await spi.set_trigger(True)
    # Wait 0.5s
    await ClockCycles(dut.clk, 12000000)
    await spi.set_trigger(False)

    await receiver