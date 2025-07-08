#include <neorv32.h>

#include "../../../../../ext/psoc_demo_sw/common/i2s_regs.h"
#include "../../../../../ext/psoc_demo_sw/common/psoc.h"
#include "../../../../../ext/psoc_demo_sw/common/sin_buf.h"

int main()
{
    // Use DAC on PAD 4 and 5
    IOMUX_REG_FUNC = (0b11 << 4);
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
