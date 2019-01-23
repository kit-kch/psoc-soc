#define R_DIP (*(volatile int *)0x80000000)
#define R_LED (*(volatile int *)0x80000004)
#define R_BUTTONS (*(volatile int *)0x80000008)
#define R_AUDIO_STATUS (*(volatile int *)0x8000000c)
#define R_AUDIO_LEFT (*(volatile int *)0x80000010)
#define R_AUDIO_RIGHT (*(volatile int *)0x80000014)

#define AUDIO_STATUS_FIFO_FULL (1 << 0)
#define AUDIO_STATUS_CONFIGURED (1 << 1)

int maskirq(int mask);
int waitirq(void);
unsigned int timer(unsigned int);

static int sin_buf[91] = { 0x000000, 0x08d4b3, 0x119ea1, 0x1a5310, 0x22e761,
    0x2b511e, 0x338602, 0x3b7c0c, 0x432983, 0x4a850c, 0x5185ab, 0x5822d6,
    0x5e547b, 0x64130d, 0x695788, 0x6e1b80, 0x725924, 0x760b49, 0x792d6b,
    0x7bbbb8, 0x7db313, 0x7f1114, 0x7fd411, 0x7ffb1d, 0x7f8607, 0x7e755e,
    0x7cca6f, 0x7a8742, 0x77ae9b, 0x7443f3, 0x704b73, 0x6bc9f5, 0x66c4f7,
    0x61429a, 0x5b4995, 0x54e133, 0x4e1144, 0x46e217, 0x3f5c72, 0x378980,
    0x2f72cd, 0x272238, 0x1ea1e5, 0x15fc33, 0x0d3baf, 0x046b06, 0xfb94fa,
    0xf2c451, 0xea03cd, 0xe15e1b, 0xd8ddc8, 0xd08d33, 0xc87680, 0xc0a38e,
    0xb91de9, 0xb1eebc, 0xab1ecd, 0xa4b66b, 0x9ebd66, 0x993b09, 0x94360b,
    0x8fb48d, 0x8bbc0d, 0x885165, 0x8578be, 0x833591, 0x818aa2, 0x8079f9,
    0x8004e3, 0x802bef, 0x80eeec, 0x824ced, 0x844448, 0x86d295, 0x89f4b7,
    0x8da6dc, 0x91e480, 0x96a878, 0x9becf3, 0xa1ab85, 0xa7dd2a, 0xae7a55,
    0xb57af4, 0xbcd67d, 0xc483f4, 0xcc79fe, 0xd4aee2, 0xdd189f, 0xe5acf0,
    0xee615f, 0xf72b4d };

void irq_handler(void *irq_address, int irq_mask)
{
    R_LED = 0xffffffff;
}

int main(void)
{
    R_LED = 0x00000000;

    maskirq(~(1 << 3)); // enable IRQ 3 (btn_u)
    while(1) {
	waitirq();
    }

#if 0
    while(!(R_AUDIO_STATUS & AUDIO_STATUS_CONFIGURED))
        ;

    unsigned int count = 0;
    R_LED = 0xAAAAAAA;
    while(1)
    {
        while (count < 4800)
        {
            for(int i = 0; i < 91; i++)
            {
                count++;
                while(R_AUDIO_STATUS & AUDIO_STATUS_FIFO_FULL)
                {}
                R_AUDIO_LEFT = sin_buf[i];
                R_AUDIO_RIGHT = sin_buf[i];
            }
        }
        count = 0;

        R_LED = ~R_LED;
    }
#endif
}
