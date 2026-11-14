// Read artwork only from an existing process; never resolve Music by name.
ObjC.import('ScriptingBridge');
function run(argv) {
    var pid = Number(argv[1]);
    if (!pid) return;
    var music = $.SBApplication.applicationWithProcessIdentifier(pid);
    var track = music.valueForKey('currentTrack');
    var artworks = track.valueForKey('artworks');
    if (!Number(artworks.count)) return;
    var bytes = artworks.objectAtIndex(0).valueForKey('rawData');
    if (!bytes.writeToFileAtomically(argv[0], true)) throw Error('Cannot write artwork');
}
