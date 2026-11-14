"""DST-aware hourly comparison for California, Dallas, and Lima."""
import datetime as dt
import fcntl
import json
import os
from pathlib import Path
import subprocess
from zoneinfo import ZoneInfo

CITIES = [('California', 'America/Los_Angeles'), ('Dallas, USA', 'America/Chicago'), ('Lima, Peru', 'America/Lima')]
CACHE = Path.home() / 'Library/Caches/sketchybar-world-clock'


def snapshot(now):
    base = now.astimezone(ZoneInfo('America/Lima'))
    start = now.astimezone(dt.timezone.utc).replace(minute=0,second=0,microsecond=0) - dt.timedelta(hours=6)
    rows = []
    for name, zone in CITIES:
        local = now.astimezone(ZoneInfo(zone))
        offset = (local.utcoffset() - base.utcoffset()).total_seconds()/3600
        difference = 'local' if zone == 'America/Lima' else f'{offset:+g}h'
        hours = [(start+dt.timedelta(hours=i)).astimezone(ZoneInfo(zone)) for i in range(18)]
        rows.append({'name': f'{name} ({local.tzname()})',
                     'detail': local.strftime('%H:%M · %a %d %b') + f' · {difference}',
                     'hours':[{'hour':h.hour,'date':h.strftime('%d %b')} for h in hours]})
    return {'rows':rows,'nowColumn':6+now.minute/60}


def main():
    CACHE.mkdir(parents=True,exist_ok=True)
    with (CACHE/'render.lock').open('w') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX)
        now=dt.datetime.now(dt.timezone.utc)
        key=now.strftime('%Y%m%d%H%M') + '-' + str(Path(__file__).with_suffix('').stat().st_mtime_ns)
        image=CACHE/(key+'.png')
        if not image.exists():
            source=CACHE/'clock.json'
            source.write_text(json.dumps(snapshot(now)))
            subprocess.run([str(Path(__file__).with_suffix('')),str(source),str(image)],check=True,timeout=5)
        subprocess.run(['sketchybar','--set','worldclock.grid',f'background.image={image}','drawing=on'],check=True)
        for old in CACHE.glob('*.png'):
            if old!=image:old.unlink(missing_ok=True)

if __name__=='__main__':main()
