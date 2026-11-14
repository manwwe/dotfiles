"""Navigable calendar with native 2× rendering and an accurate today highlight."""
import calendar
import datetime as dt
import fcntl
import json
import os
from pathlib import Path
import subprocess
import sys

CACHE=Path.home()/'Library/Caches/sketchybar-calendar'


def shift(year,month,delta):
    year,index=divmod(year*12+month-1+delta,12)
    return year,index+1


def main():
    CACHE.mkdir(parents=True,exist_ok=True)
    with (CACHE/'calendar.lock').open('w') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX)
        today=dt.date.today()
        state=CACHE/'month.json'
        try:
            year,month=json.loads(state.read_text())
            dt.date(year,month,1)
        except (OSError,ValueError,TypeError):
            year,month=today.year,today.month
        action=sys.argv[1] if len(sys.argv)>1 else ''
        if action in ('previous','next'):
            year,month=shift(year,month,-1 if action=='previous' else 1)
        elif action=='today':
            year,month=today.year,today.month
        state.write_text(json.dumps([year,month]))
        weeks=calendar.Calendar(firstweekday=6).monthdayscalendar(year,month)
        helper=Path(__file__).with_suffix('')
        key=f'{year}-{month}-{today}-{helper.stat().st_mtime_ns}'
        image=CACHE/(key+'.png')
        if not image.exists():
            source=CACHE/'render.json'
            source.write_text(json.dumps({'heading':f'{calendar.month_name[month]} {year}',
                'weeks':weeks,'today':today.day if (year,month)==(today.year,today.month) else 0}))
            subprocess.run([str(helper),str(source),str(image)],check=True,timeout=5)
        height=80+len(weeks)*32
        subprocess.run(['sketchybar','--set','calendar.grid',f'background.image={image}',
            f'background.height={height+8}',
            '--set','calendar.today',f'label=Today · {today.strftime("%a %d %b")}'],check=True)
        for old in CACHE.glob('*.png'):
            if old!=image:old.unlink(missing_ok=True)

if __name__=='__main__':main()
