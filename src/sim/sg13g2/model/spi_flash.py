# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2025 Johannes Pfau
from cocotb.triggers import First, RisingEdge, FallingEdge
from cocotbext.spi import SpiFrameError, SpiBus, SpiConfig, SpiSlaveBase


class SpiFlash(SpiSlaveBase):
    _config = SpiConfig(
        word_width=0,
        cpol=False,
        cpha=False,
        msb_first=True,
        frame_spacing_ns=10,
        cs_active_low=True,
    )

    def __init__(self, bus: SpiBus, path):
        self.file = open(path, 'rb')
        super().__init__(bus)


    def __del__(self):
        if not self.file.closed:
            self.file.close()

    async def _transaction(self, frame_start, frame_end):
        await frame_start
        self.idle.clear()

        # SCLK pin should be low at the chip select edge
        if bool(self._sclk.value):
            raise SpiFrameError("SpiFlash: sclk should be low at chip select edge")

        cmd = int(await self._shift(8))
        if (cmd != 0x3):
            raise SpiFrameError(f"SpiFlash: Only command 0x3 is implemented. Got command {cmd}")

        address = int(await self._shift(24))

        # Load data from file
        self.file.seek(address)
        data = int.from_bytes(self.file.read(1))

        # Send bits as long as frame is active
        # SPI mode 0: await self._shift returned at a falling edge
        # We have to prepare the first bit immediately, for it to be available on the rising edge of the next clk
        bit_idx = 7
        while True:
            self._miso.value = (data >> (bit_idx)) & 1
            if (bit_idx == 0):
                data = int.from_bytes(self.file.read(1))
                bit_idx = 7
            else:
                bit_idx = bit_idx - 1

            clk_edge = FallingEdge(self._sclk)
            ss_inactive = RisingEdge(self._cs)
            result = await First(clk_edge, ss_inactive)

            if result is ss_inactive:
                break

        if bool(self._sclk.value):
            raise SpiFrameError("SpiFlash: sclk should be low at chip select edge")