"""Persistent 27-minute Pomodoro timer; no background timer process required."""
import fcntl
import json
import math
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import time

from controls import apply as apply_visibility

DURATION = 27 * 60
CACHE = Path.home() / 'Library/Caches/sketchybar-pomodoro'


def transition(state, action, now):
    state = dict(state)
    finished = False
    if state.get('status') == 'running' and state.get('ends_at', now) <= now:
        state = {'status': 'complete', 'remaining': 0}
        finished = True
    if action == 'start':
        state = {'status': 'running', 'ends_at': now + DURATION}
        finished = False
    elif action == 'pause' and state.get('status') == 'running':
        state = {'status': 'paused', 'remaining': max(0, state['ends_at'] - now)}
    elif action == 'resume' and state.get('status') == 'paused':
        state = {'status': 'running', 'ends_at': now + state['remaining']}
    elif action == 'reset':
        state = {'status': 'idle', 'remaining': DURATION}
        finished = False
    return state, finished


def render(state, now):
    status = state.get('status', 'idle')
    seconds = state.get('ends_at', now) - now if status == 'running' else state.get('remaining', DURATION)
    seconds = max(0, math.ceil(seconds))
    clock = f'{seconds // 60:02}:{seconds % 60:02}'
    text = {'idle': 'Ready · 27 minutes', 'running': f'Focus · {clock}',
            'paused': f'Paused · {clock}', 'complete': 'Session complete!'}[status]
    color = '0xffa6e3a1' if status == 'running' else '0xffcdd6f4'
    if status == 'complete':
        color = '0xffcba6f7'
    subprocess.run([
        'sketchybar', '--set', 'pomodoro', f'icon.color={color}',
        f'label={"Done" if status == "complete" else clock}',
        f'label.drawing={"off" if status == "idle" else "on"}',
        '--set', 'pomodoro.status', f'label={text}',
        '--set', 'pomodoro.start', f'label={"Restart 27 minutes" if status != "idle" else "Start 27 minutes"}',
        '--set', 'pomodoro.pause', f'drawing={"on" if status in ("running", "paused") else "off"}',
        f'label={"Resume" if status == "paused" else "Pause"}',
    ], check=True, stdout=subprocess.DEVNULL)


def main():
    CACHE.mkdir(parents=True, exist_ok=True)
    with (CACHE / 'timer.lock').open('w') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        path = CACHE / 'timer.json'
        try:
            state = json.loads(path.read_text())
        except (OSError, ValueError):
            state = {'status': 'idle', 'remaining': DURATION}
        action = sys.argv[1] if len(sys.argv) > 1 else ''
        if action == 'pause-toggle':
            action = 'resume' if state.get('status') == 'paused' else 'pause'
        now = time.time()
        previous = dict(state)
        state, finished = transition(state, action, now)
        if state != previous or not path.exists():
            fd, temporary = tempfile.mkstemp(dir=CACHE)
            with os.fdopen(fd, 'w') as file:
                json.dump(state, file)
            os.replace(temporary, path)
        render(state, now)
        if state != previous or os.environ.get('SENDER') != 'routine':
            apply_visibility(state.get('status', 'idle'))
        if finished:
            subprocess.Popen(['/usr/bin/afplay', '/System/Library/Sounds/Glass.aiff'],
                             stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


if __name__ == '__main__':
    main()
