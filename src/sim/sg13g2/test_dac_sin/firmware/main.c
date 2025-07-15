#include <neorv32.h>

// IOMUX Registers
#define IOMUX_REG_FUNC *(volatile uint32_t*)0xffd10004
#define PAD04 4
#define PAD05 5
#define PIN_DAC_L     PAD04
#define PIN_DAC_R     PAD05
#define FUNC_DAC      ((1 << PIN_DAC_L) | (1 << PIN_DAC_R))

// PSoC Audio Registers
#define I2S_REG_CTRL0  *(volatile uint32_t*)0xffd00000
#define I2S_REG_STAT0  *(volatile uint32_t*)0xffd00004
#define I2S_REG_AUDIOL *(volatile uint32_t*)0xffd00010
#define I2S_REG_AUDIOR *(volatile uint32_t*)0xffd00014

#define CTRL0_RST 0b1
#define CTRL0_DAC_BUILTIN 0b10
#define CTRL0_DAC_EN 0b100
#define CTRL0_I2S_EN 0b1000

#define STAT0_FIFO_FULL 0b100

#define AUDIO_COMMIT 0x80000000

// Sinus waveform
const size_t sin_buf_len = 90;
int32_t sin_buf[90] = { 
    0x000000, 0x08edc7, 0x11d06c, 0x1a9cd9, 0x234815, 0x2bc750, 
    0x340ff1, 0x3c17a4, 0x43d464, 0x4b3c8b, 0x5246dc, 0x58ea90, 
    0x5f1f5d, 0x64dd88, 0x6a1de6, 0x6ed9ea, 0x730bae, 0x76adf4, 
    0x79bc37, 0x7c32a5, 0x7e0e2d, 0x7f4c7d, 0x7fec08, 0x7fec08, 
    0x7f4c7d, 0x7e0e2d, 0x7c32a5, 0x79bc37, 0x76adf4, 0x730bae, 
    0x6ed9ea, 0x6a1de6, 0x64dd88, 0x5f1f5d, 0x58ea90, 0x5246dc, 
    0x4b3c8b, 0x43d464, 0x3c17a4, 0x340ff1, 0x2bc750, 0x234815, 
    0x1a9cd9, 0x11d06c, 0x08edc7, 0x000000, 0xf71239, 0xee2f94, 
    0xe56327, 0xdcb7eb, 0xd438b0, 0xcbf00f, 0xc3e85c, 0xbc2b9c, 
    0xb4c375, 0xadb924, 0xa71570, 0xa0e0a3, 0x9b2278, 0x95e21a, 
    0x912616, 0x8cf452, 0x89520c, 0x8643c9, 0x83cd5b, 0x81f1d3, 
    0x80b383, 0x8013f8, 0x8013f8, 0x80b383, 0x81f1d3, 0x83cd5b, 
    0x8643c9, 0x89520c, 0x8cf452, 0x912616, 0x95e21a, 0x9b2278, 
    0xa0e0a3, 0xa71570, 0xadb924, 0xb4c375, 0xbc2b9c, 0xc3e85c, 
    0xcbf00f, 0xd438b0, 0xdcb7eb, 0xe56327, 0xee2f94, 0xf71239 };

int main()
{
    // Use DAC on PAD 4 and 5
    IOMUX_REG_FUNC = FUNC_DAC;
    I2S_REG_CTRL0 |= CTRL0_RST | CTRL0_DAC_BUILTIN | CTRL0_DAC_EN;
    I2S_REG_CTRL0 &= ~(CTRL0_RST | CTRL0_I2S_EN);

    while (1)
    {
        for (size_t i = 0; i < sin_buf_len; i++)
        {
            // Wait till there's space in the FIFO
            while(I2S_REG_STAT0 & STAT0_FIFO_FULL)
            {}

            I2S_REG_AUDIOL = sin_buf[i];
            I2S_REG_AUDIOR = sin_buf[i] | AUDIO_COMMIT;
        }
    }

    return 0;
}
