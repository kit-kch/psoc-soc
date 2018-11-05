#define R_DIP (*(volatile int *)0x80000000)
#define R_LED (*(volatile int *)0x80000004)
#define R_BUTTONS (*(volatile int *)0x80000008)
#define R_AUDIO_STATUS (*(volatile int *)0x8000000c)
#define R_AUDIO_LEFT (*(volatile int *)0x80000010)
#define R_AUDIO_RIGHT (*(volatile int *)0x80000014)

#define AUDIO_STATUS_FIFO_FULL (1 << 0)
#define AUDIO_STATUS_CONFIGURED (1 << 1)

unsigned int gen_audio(unsigned int time, int **ptr_out, unsigned int *count_out);  // in synth.c

int main(void)
{
    while(!(R_AUDIO_STATUS & AUDIO_STATUS_CONFIGURED))
        ;

    unsigned int time = 0;
    int *buf;
    unsigned int count;
    while(1) {
        time = gen_audio(time, &buf, &count);
        while(count--) {
            while(R_AUDIO_STATUS & AUDIO_STATUS_FIFO_FULL)
                ;
            int sample = *buf++;
            R_AUDIO_LEFT = sample;
            R_AUDIO_RIGHT = sample;
        }
    }
}
