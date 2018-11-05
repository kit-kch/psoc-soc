struct note {
        unsigned int time;
        unsigned int d_phase;
};

enum waveform {
        SAW,
        TRI,
        SQUARE,
};

struct voice {
        unsigned int phase;
        unsigned int note_count;
        const struct note *notes;
        enum waveform waveform;
        char volume;
};

static int note_events(const struct note *notes, unsigned int note_count,
                    unsigned int start_time,
                    int *phase_out, unsigned int count,
                    int phase)
{
        unsigned int sample_pos = 0;
        while(sample_pos < count) {
                // find the note that is left wrt the current time
                unsigned int now = start_time + sample_pos;
                unsigned int note = note_count - 1;
                while(note != 0 && notes[note].time > now)
                        note--;

                unsigned int next_event;
                if(note == note_count - 1)  // no more notes? assume the next event is very far in the future
                    next_event = 0xffffffff;
                else
                        next_event = notes[note+1].time;

                unsigned int duration = next_event - now;
                if(duration > count - sample_pos)  // cap duration so we don't overflow d_phase
                        duration = count - sample_pos;

                unsigned int d_phase = notes[note].d_phase;
                while(duration--) {
                        phase_out[sample_pos++] = phase;
                        phase += d_phase;
                }
        }
        return phase;
}

static void gen_tri(int *phase, unsigned int count)
{
        unsigned int sample;
        for(sample = 0; sample < count; sample++) {
                int x = phase[sample];
                int y;
                if(x < 0)
                        y = (x + 0x3fffffff) << 1;
                else
                        y = 0x7fffffff - (x << 1);
                phase[sample] = y;
        }
}

static void gen_square(int *phase, unsigned int count)
{
        unsigned int sample;
        for(sample = 0; sample < count; sample++)
                phase[sample] = phase[sample] > 0 ? 0x7fffffff : 0x80000000;
}

static void gen_voice(struct voice *v, unsigned int start_time, int *buf, unsigned int count)
{
        v->phase = note_events(v->notes, v->note_count, start_time, buf, count, v->phase);
        switch(v->waveform) {
        case TRI:
                gen_tri(buf, count);
                break;
        case SQUARE:
                gen_square(buf, count);
                break;
        case SAW:
        default:
                break;
        }
        char volume = v->volume;
        unsigned int sample;
        for(sample = 0; sample < count; sample++)
                buf[sample] >>= volume;
}

static void sum(int *a_out, int *b, unsigned int count)
{
        while(count--)
                *a_out++ += *b++;
}

#include "mario.h"

#define CHUNK 256
static int voice_buf[CHUNK];
static int mix_buf[CHUNK];

unsigned int gen_audio(unsigned int time, int **ptr_out, unsigned int *count_out)
{
    gen_voice(voices[0], time, mix_buf, CHUNK);
    int voice;
    for(voice = 1; voice < voice_count; voice++) {
        gen_voice(voices[voice], time, voice_buf, CHUNK);
        sum(mix_buf, voice_buf, CHUNK);
    }
    *ptr_out = mix_buf;
    *count_out = CHUNK;
    time += CHUNK;
    if(time > song_duration) {
        time = 0;
    }
    return time;
}
