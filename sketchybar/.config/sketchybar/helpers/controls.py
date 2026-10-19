"""Visibility for the collapsible CPU, memory, AI quotas, and Pomodoro controls."""
import fcntl
import json
from pathlib import Path
import subprocess
import sys

CACHE = Path.home() / 'Library/Caches/sketchybar-controls'
TIMER = Path.home() / 'Library/Caches/sketchybar-pomodoro/timer.json'


def apply(status=None, toggle=False):
    CACHE.mkdir(parents=True, exist_ok=True)
    with (CACHE / 'visibility.lock').open('w') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        path = CACHE / 'expanded'
        try:
            expanded = path.read_text().strip() == 'true'
        except OSError:
            expanded = False
        if toggle:
            expanded = not expanded
            path.write_text('true' if expanded else 'false')
        if status is None:
            try:
                status = json.loads(TIMER.read_text()).get('status', 'idle')
            except (OSError, ValueError):
                status = 'idle'
        visible = 'on' if expanded else 'off'
        timer_visible = expanded or status in ('running', 'paused', 'complete')
        args = ['sketchybar', '--set', 'controls', f'icon={"" if expanded else ""}',
                '--set', 'cpu', f'drawing={visible}',
                '--set', 'memory', f'drawing={visible}',
                '--set', 'pomodoro', f'drawing={"on" if timer_visible else "off"}']
        if not timer_visible:
            args += ['popup.drawing=off']
        # The AI section can also be disabled entirely in sketchybarrc.
        ai = subprocess.run(['sketchybar', '--query', 'ai'],
                            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        if ai.returncode == 0:
            args += ['--set', 'ai', f'drawing={visible}']
            if not expanded:
                args += ['popup.drawing=off']
        subprocess.run(args, check=True, stdout=subprocess.DEVNULL)
        if expanded and toggle:
            config = Path(__file__).resolve().parent.parent
            subprocess.Popen(['/bin/bash', str(config/'plugins/system_usage.sh')],
                             stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


if __name__ == '__main__':
    apply(toggle=len(sys.argv) > 1 and sys.argv[1] == 'toggle')
