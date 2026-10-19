"""Serialize popup changes so only one menu can be open at a time."""
import fcntl
import json
from pathlib import Path
import subprocess
import sys

PARENTS = ('apple', 'clock', 'bluetooth', 'wifi', 'ai', 'pomodoro', 'music', 'volume')

def toggle(name):
    cache = Path.home() / 'Library/Caches/sketchybar-controls'
    cache.mkdir(parents=True, exist_ok=True)
    with (cache / 'popup.lock').open('w') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        bar = json.loads(subprocess.check_output(['sketchybar', '--query', 'bar'], text=True))
        current = json.loads(subprocess.check_output(['sketchybar', '--query', name], text=True))
        opened = current.get('popup', {}).get('drawing') == 'on'
        args = ['sketchybar']
        for item in PARENTS:
            if item in bar['items']:
                args += ['--set', item, f'popup.drawing={"on" if item == name and not opened else "off"}']
        subprocess.run(args, check=True)

if __name__ == '__main__':
    toggle(sys.argv[1])
