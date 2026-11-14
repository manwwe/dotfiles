"""Apple Music metadata and playback controls for SketchyBar."""
import json
import hashlib
import math
import tempfile
from pathlib import Path
import subprocess
import sys

def music_pid():
    result = subprocess.run(['/usr/bin/pgrep', '-x', 'Music'], capture_output=True, text=True)
    return result.stdout.splitlines()[0] if result.returncode == 0 and result.stdout.strip() else None

def clean(value):
    return ' '.join(str(value or '').split())


def apple_snapshot(action=''):
    # Do not launch Music when it is closed.
    pid = music_pid()
    if not pid:
        return None
    try:
        result = subprocess.run(
            ['/usr/bin/osascript', '-l', 'JavaScript', str(Path(__file__).with_suffix('.js')), action, pid],
            capture_output=True, text=True, timeout=8, check=True,
        )
        data = json.loads(result.stdout)
        if not data.get('running'):
            return None
        return {'pid': pid, 'backend': 'apple', 'bundle': 'com.apple.Music', 'source': 'Apple Music',
                'icon': '\uf001', 'playing': data.get('state') == 'playing',
                'title': clean(data.get('title')) or 'Nothing playing',
                'artist': clean(data.get('artist')), 'album': clean(data.get('album'))}
    except (subprocess.SubprocessError, ValueError):
        if music_pid() != pid:
            return None
        return {'backend': 'apple', 'bundle': 'com.apple.Music', 'source': 'Apple Music',
                'icon': '\uf001', 'playing': False, 'title': 'Apple Music',
                'artist': 'Allow Music access in Automation settings', 'album': ''}


def artwork(data):
    if data['title'] in ('Apple Music', 'Nothing playing'):
        return None
    cache = Path.home() / 'Library/Caches/sketchybar-music'
    cache.mkdir(parents=True, exist_ok=True)
    key = hashlib.sha256(json.dumps([data['title'], data['artist'], data['album']]).encode()).hexdigest()[:20]
    cover = cache / (key + '.jpg')
    if cover.exists():
        return cover
    try:
        with tempfile.TemporaryDirectory(dir=cache) as temporary:
            raw = Path(temporary) / 'artwork'
            result = Path(temporary) / 'cover.jpg'
            subprocess.run(['/usr/bin/osascript', '-l', 'JavaScript',
                            str(Path(__file__).with_name('music_artwork.js')), str(raw), data.get('pid', '')],
                           capture_output=True, timeout=8, check=True)
            subprocess.run(['/usr/bin/sips', '-s', 'format', 'jpeg', '--resampleHeightWidth', '128', '128',
                            str(raw), '--out', str(result)], capture_output=True, timeout=5, check=True)
            result.replace(cover)
        for old in cache.glob('*.jpg'):
            if old != cover:
                old.unlink(missing_ok=True)
        return cover
    except (OSError, subprocess.SubprocessError):
        return None


def render(data):
    if not data:
        subprocess.run(['sketchybar', '--set', 'music', 'drawing=off', 'popup.drawing=off'], check=True)
        return
    playing = data['playing']
    cover = artwork(data)
    if not music_pid():
        render(None)
        return
    # Roboto Mono 13pt uses a 0.6em character advance. Give every popup row
    # the same content width, then center the 128px cover within that width.
    texts = [data['title'], data['artist'], data['album'], data['source'],
             'Previous track', 'Open Apple Music']
    width = max(220, math.ceil(max(min(len(text), 45) for text in texts) * 13 * 0.6 + 36))
    padding = (width - 128) / 2
    subprocess.run(['sketchybar', '--set', '/^music[.]/', f'width={width}',
                    '--set', 'music.artwork', f'background.image.padding_left={padding:g}'], check=True)
    subprocess.run(['sketchybar', '--set', 'music.artwork', f'drawing={"on" if cover else "off"}'] +
                   ([f'background.image={cover}', 'background.image.drawing=on'] if cover else []), check=True)
    subprocess.run([
        'sketchybar', '--set', 'music', 'drawing=on', f'icon={data["icon"]}', f'label={data["title"]}',
        '--set', 'music.source', f'label={data["source"]}',
        '--set', 'music.title', f'label={data["title"]}',
        '--set', 'music.artist', f'label={data["artist"]}', f'drawing={"on" if data["artist"] else "off"}',
        '--set', 'music.album', f'label={data["album"]}', f'drawing={"on" if data["album"] else "off"}',
        '--set', 'music.playpause', f'icon={"\uf04c" if playing else "\uf04b"}',
        f'label={"Pause" if playing else "Play"}',
        '--set', 'music.open', f'label=Open {data["source"]}', f'icon={data["icon"]}',
    ], check=True)


def main():
    action = sys.argv[1] if len(sys.argv) > 1 else ''
    if action == 'open':
        subprocess.run(['/usr/bin/open', '-a', 'Music'], check=True)
        return
    render(apple_snapshot(action))


if __name__ == '__main__':
    main()
