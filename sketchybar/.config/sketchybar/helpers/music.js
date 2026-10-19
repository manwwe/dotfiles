// JXA automation reads Music metadata without starting playback or opening a window.
function run(argv) {
    var music = Application('Music');
    if (!music.running()) return JSON.stringify({running: false});
    switch (argv[0]) {
        case 'playpause': music.playpause(); break;
        case 'previous': music.previousTrack(); break;
        case 'next': music.nextTrack(); break;
    }
    var result = {running: true, state: music.playerState(), title: '', artist: '', album: ''};
    try {
        var track = music.currentTrack;
        result.title = track.name();
        result.artist = track.artist();
        result.album = track.album();
    } catch (_) {
        // Music can be open without a selected track.
    }
    return JSON.stringify(result);
}
