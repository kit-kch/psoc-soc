import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

import numpy as np
from scipy.signal import butter, lfilter
import wave

class AudioFilter:
    def __init__(self, outPath, goldenPath):
        order = 5
        nyquist = 0.5 * 24000000
        high = 20000 / nyquist
        self.b, self.a = butter(order, high, btype='low', analog=False)
        self.z = np.zeros(self.b.size - 1)

        self.wf = wave.open(outPath, 'wb')
        self.rwf = wave.open(goldenPath, 'rb')
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
        refdata = self.rwf.readframes(4)
        assert resampled_i16.tobytes() == refdata, "Data does not match reference"

    def finish(self):
        self.wf.close()

async def collect_audio(outPath, goldenPath, clkPin, audioPin, samples = 48000001):
    af = AudioFilter(outPath, goldenPath)
    
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