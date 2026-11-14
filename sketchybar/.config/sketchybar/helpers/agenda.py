"""Render today's Calendar appointments without persisting event contents."""
import datetime as dt
import json
from pathlib import Path
import subprocess
import sys
import time


def main():
    helper=Path(__file__).with_suffix('')
    authorize=len(sys.argv)>1 and sys.argv[1]=='authorize'
    try:
        data=json.loads(subprocess.check_output([str(helper)]+(['--authorize'] if authorize else []),text=True,timeout=50 if authorize else 8))
    except (OSError,ValueError,subprocess.SubprocessError):
        data={'status':'error'}
    args=['sketchybar']
    events=data.get('events',[])
    now=time.time()
    upcoming=next((e for e in events if not e['allDay'] and e['end']>now),None)
    rows=[]
    if data.get('status')=='permission':rows=[('Allow Calendar access…',False)]
    elif data.get('status')!='ok':rows=[('Calendar temporarily unavailable',False)]
    elif not events:rows=[('No appointments today',False)]
    else:
        for event in events[:8]:
            title=' '.join(event['title'].split())
            times='All day' if event['allDay'] else dt.datetime.fromtimestamp(event['start']).strftime('%H:%M')+'–'+dt.datetime.fromtimestamp(event['end']).strftime('%H:%M')
            rows.append((f'{times} · {title}',event is upcoming))
        if len(events)>8:rows.append((f'+{len(events)-8} more · open Calendar',False))
    for i in range(9):
        args+=['--set',f'agenda.{i}',f'drawing={"on" if i<len(rows) else "off"}']
        if i<len(rows):
            text,highlight=rows[i]
            args+=[f'label={text}',f'label.color={"0xffcac8a8" if highlight else "0xffd5d4bc"}',
                   f'click_script="{helper.parent.parent}/plugins/clock.sh" {"authorize" if data.get("status")=="permission" else "open-calendar"}']
    subprocess.run(args,check=True)

if __name__=='__main__':main()
