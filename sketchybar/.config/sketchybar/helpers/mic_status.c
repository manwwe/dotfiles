#include <CoreAudio/CoreAudio.h>
#include <stdio.h>
#include <stdlib.h>

// Inspect active input streams, rather than microphone volume or output playback.
int main(void) {
    AudioObjectPropertyAddress list = {
        kAudioHardwarePropertyProcessObjectList,
        kAudioObjectPropertyScopeGlobal,
        kAudioObjectPropertyElementMain
    };
    UInt32 size = 0;
    if (AudioObjectGetPropertyDataSize(kAudioObjectSystemObject, &list, 0, NULL, &size) != noErr)
        return 2;
    if (size == 0) { puts("0"); return 0; }
    AudioObjectID *processes = malloc(size);
    if (!processes) return 2;
    if (AudioObjectGetPropertyData(kAudioObjectSystemObject, &list, 0, NULL, &size, processes) != noErr) {
        free(processes);
        return 2;
    }
    AudioObjectPropertyAddress input = {
        kAudioProcessPropertyIsRunningInput,
        kAudioObjectPropertyScopeGlobal,
        kAudioObjectPropertyElementMain
    };
    int active = 0;
    for (UInt32 i = 0; i < size / sizeof(*processes); i++) {
        UInt32 running = 0, bytes = sizeof(running);
        if (AudioObjectGetPropertyData(processes[i], &input, 0, NULL, &bytes, &running) == noErr && running) {
            active = 1;
            break;
        }
    }
    free(processes);
    puts(active ? "1" : "0");
    return 0;
}
