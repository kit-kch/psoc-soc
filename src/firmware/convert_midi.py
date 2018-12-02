#!/usr/bin/env python3
import mido  # pip3 install mido

SAMPLE_RATE = 48e3


def calc_dphase(midi_note):
    hz = 440 * 2 ** ((midi_note - 69) / 12)
    return int(0xffffffff * hz / SAMPLE_RATE)


def seconds_to_samples(s):
    return int(s * SAMPLE_RATE)


def process(path):
    mid = mido.MidiFile(path)

    t = 0
    voices = []
    active_notes = []

    for msg in mid:
        t += msg.time
        if msg.type == "note_on":
            if all(note != None for note in active_notes):
                voices.append([])
                active_notes.append(None)
            for voice_id, active_note in enumerate(active_notes):
                if active_note is None:
                    break

            d_phase = calc_dphase(msg.note)
            msg_time = seconds_to_samples(t)
            voices[voice_id].append((msg_time, d_phase))
            active_notes[voice_id] = msg.note
        elif msg.type == "note_off":
            for voice_id, active_note in enumerate(active_notes):
                if active_note == msg.note:
                    break

            else:
                continue

            msg_time = seconds_to_samples(t)
            voices[voice_id].append((msg_time, 0))
            active_notes[voice_id] = None

    for i, voice in enumerate(voices):
        print(f"static const struct note voice{i}_notes[] = {{")
        for time, d_phase in voice:
            print(f"{{.time={time}, .d_phase={d_phase}}},")
        print("};")
        print(
            f"""
static struct voice voice{i} = {{
        .note_count={len(voice)},
        .notes=voice{i}_notes,
        .volume=0x1ffffff
}};"""
        )

    print(f"#define VOICE_COUNT {len(voices)}")
    print(
        "static const struct voice *voices[VOICE_COUNT] = {",
        ", ".join(f"&voice{i}" for i, _ in enumerate(voices)),
        "};",
    )

    duration = max(time for time, _ in voice for voice in voices)
    print(f"static const unsigned int song_duration = {duration};")


if __name__ == "__main__":
    from sys import argv

    if len(argv) < 2:
        exit(f"usage: {argv[0]} INPUT.midi")
    process(argv[1])
