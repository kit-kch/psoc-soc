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
        unsigned int volume;
};

#include "mario.h"

static unsigned int time;
static unsigned int note_positions[VOICE_COUNT];
static unsigned int voice_phase[VOICE_COUNT];

#define CHUNK 64
static int buf[CHUNK];

void gen_audio(const int **bufptr_out, unsigned int *count_out)
{
    unsigned int ii;
    for(ii = 0; ii < VOICE_COUNT; ii++) {
	const struct voice *voice = voices[ii];
	const struct note *notes = voice->notes;
	unsigned int note_count = voice->note_count;
	// advance note position
	unsigned int pos = note_positions[ii];
	while(pos != (note_count - 1) && time > notes[pos+1].time)
	    pos++;
	note_positions[ii] = pos;
	// generate audio
	unsigned int d_phase = notes[pos].d_phase;
	unsigned int phase = voice_phase[ii];
	unsigned int jj;
	int hi = voice->volume;
	int lo = -hi;
	if(ii == 0)
	    for(jj = 0; jj < CHUNK; jj++)
		buf[jj] = (phase += d_phase) > 0x7fffffff ? hi : lo;
	else
	    for(jj = 0; jj < CHUNK; jj++)
		buf[jj] += (phase += d_phase) > 0x7fffffff ? hi : lo;
	voice_phase[ii] = phase;
    }
    time += CHUNK;
    *bufptr_out = buf;
    *count_out = CHUNK;
    // reset to start of the song when past the end
    if(time > song_duration + 50000) {
	time = 0;
	for(ii = 0; ii < VOICE_COUNT; ii++) {
	    note_positions[ii] = 0;
	    voice_phase[ii] = 0;
	}
    }
}
