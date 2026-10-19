#include <CoreMediaIO/CMIOHardware.h>
#include <stdio.h>
#include <stdlib.h>

// Read system-wide camera activity without opening a capture session.
int main(void) {
    CMIOObjectPropertyAddress address = {
        kCMIOHardwarePropertyDevices,
        kCMIOObjectPropertyScopeGlobal,
        kCMIOObjectPropertyElementMain
    };
    UInt32 size = 0;
    if (CMIOObjectGetPropertyDataSize(kCMIOObjectSystemObject, &address, 0, NULL, &size) != noErr)
        return 2;
    if (size == 0) { puts("0"); return 0; }
    CMIODeviceID *devices = malloc(size);
    if (!devices) return 2;
    if (CMIOObjectGetPropertyData(kCMIOObjectSystemObject, &address, 0, NULL,
                                 size, &size, devices) != noErr) {
        free(devices);
        return 2;
    }
    address.mSelector = kCMIODevicePropertyDeviceIsRunningSomewhere;
    int active = 0;
    for (UInt32 i = 0; i < size / sizeof(*devices); i++) {
        UInt32 running = 0, used = 0;
        if (CMIOObjectGetPropertyData(devices[i], &address, 0, NULL,
                                     sizeof(running), &used, &running) == noErr && running) {
            active = 1;
            break;
        }
    }
    free(devices);
    puts(active ? "1" : "0");
    return 0;
}
