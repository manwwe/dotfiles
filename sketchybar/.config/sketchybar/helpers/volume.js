function run(argv) {
    var system = Application.currentApplication();
    system.includeStandardAdditions = true;
    var info = system.getVolumeSettings();
    var volume = info.outputVolume;
    if (argv[0] === 'up' || argv[0] === 'down') {
        volume = Math.max(0, Math.min(100, volume + (argv[0] === 'up' ? 5 : -5)));
        system.setVolume(null, {outputVolume: volume});
    } else if (argv[0] === 'mute') {
        system.setVolume(null, {outputMuted: !info.outputMuted});
    }
    info = system.getVolumeSettings();
    return JSON.stringify({volume: info.outputVolume, muted: info.outputMuted});
}
