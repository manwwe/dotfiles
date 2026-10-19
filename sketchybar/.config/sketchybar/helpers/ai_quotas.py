"""Read quota snapshots through CodexBar; cache only display text, never credentials."""
import concurrent.futures
import datetime as dt
import fcntl
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import time

PROVIDERS = {'codex': 'oauth', 'claude': 'oauth', 'copilot': 'api', 'gemini': 'api'}
CACHE = Path.home() / 'Library/Caches/sketchybar-ai'
TEXT = '0xffcdd6f4'
MUTED = '0xffa6adc8'


def window_text(window, index):
    used = window.get('usedPercent')
    if not isinstance(used, (int, float)):
        return None
    minutes = window.get('windowMinutes')
    if minutes == 10080:
        label = 'Weekly'
    elif minutes == 300:
        label = '5 hours'
    elif isinstance(minutes, (int, float)) and minutes > 0:
        label = f'{minutes / 60:g} hours'
    else:
        label = ('Primary', 'Secondary', 'Other')[index]
    remaining = max(0, min(100, 100 - used))
    reset = ''
    if window.get('resetsAt'):
        try:
            date = dt.datetime.fromisoformat(window['resetsAt'].replace('Z', '+00:00'))
            reset = ' · resets ' + date.astimezone().strftime('%a %H:%M')
        except (ValueError, TypeError):
            pass
    return f'{label}: {remaining:g}% left{reset}'


def fetch(provider, source, cli):
    try:
        result = subprocess.run(
            [cli, 'usage', '--provider', provider, '--source', source,
             '--format', 'json', '--json-only'],
            capture_output=True, text=True, timeout=20,
        )
        payload = json.loads(result.stdout)
        entries = payload if isinstance(payload, list) else [payload]
        entry = next((x for x in entries if x.get('provider') == provider), {})
        usage = entry.get('usage') or {}
        rows = [window_text(usage.get(key) or {}, i)
                for i, key in enumerate(('primary', 'secondary', 'tertiary'))]
        rows = [row for row in rows if row]
        if rows:
            return rows
        return ['Unavailable — check sign-in in CodexBar']
    except subprocess.TimeoutExpired:
        return ['Unavailable — quota request timed out']
    except (OSError, ValueError, TypeError, AttributeError):
        return ['Unavailable — check sign-in in CodexBar']


def render(snapshot):
    args = ['sketchybar']
    for provider in PROVIDERS:
        rows = snapshot.get('providers', {}).get(provider, ['Waiting for quota data…'])
        for index in range(3):
            name = f'ai.{provider}.{index}'
            if index < len(rows):
                color = MUTED if rows[index].startswith(('Unavailable', 'Waiting')) else TEXT
                args += ['--set', name, 'drawing=on', f'label={rows[index]}', f'label.color={color}']
            else:
                args += ['--set', name, 'drawing=off']
    checked = snapshot.get('checked')
    stamp = dt.datetime.fromtimestamp(checked).strftime('%H:%M') if checked else 'not yet'
    args += ['--set', 'ai.updated', f'label=Last checked: {stamp} · click to refresh']
    subprocess.run(args, check=True, stdout=subprocess.DEVNULL)


def main():
    CACHE.mkdir(parents=True, exist_ok=True)
    with (CACHE / 'refresh.lock').open('w') as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            return
        path = CACHE / 'quotas.json'
        try:
            snapshot = json.loads(path.read_text())
        except (OSError, ValueError):
            snapshot = {}
        render(snapshot)
        force = len(sys.argv) > 1 and sys.argv[1] == 'refresh'
        if not force and time.time() - snapshot.get('checked', 0) < 300:
            return
        cli = shutil.which('codexbar')
        if not cli:
            snapshot = {'providers': {p: ['Unavailable — install CodexBar'] for p in PROVIDERS}}
            render(snapshot)
            return
        with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
            futures = {p: pool.submit(fetch, p, source, cli) for p, source in PROVIDERS.items()}
            data = {p: future.result() for p, future in futures.items()}
        snapshot = {'checked': time.time(), 'providers': data}
        fd, temporary = tempfile.mkstemp(dir=CACHE)
        with os.fdopen(fd, 'w') as file:
            json.dump(snapshot, file)
        os.replace(temporary, path)
        render(snapshot)


if __name__ == '__main__':
    main()
