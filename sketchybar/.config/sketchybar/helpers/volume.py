"""Volume controls and output devices; device names never become shell code."""
import json
import os
from pathlib import Path
import subprocess
import sys


def call(args):
    return subprocess.check_output(args, text=True, timeout=5)


def main():
    action = sys.argv[1] if len(sys.argv) > 1 else ''
    if action == 'device' and len(sys.argv) > 2 and sys.argv[2].isdigit():
        subprocess.run(['SwitchAudioSource', '-t', 'output', '-i', sys.argv[2]], check=True, timeout=5,
                       stdout=subprocess.DEVNULL)
    if action == 'settings':
        subprocess.run(['open', 'x-apple.systempreferences:com.apple.Sound-Settings.extension'], check=True)
        return
    script = Path(__file__).with_suffix('.js')
    info = json.loads(call(['/usr/bin/osascript', '-l', 'JavaScript', str(script), action]))
    volume, muted = info['volume'], info['muted']
    icon = '\uf026' if muted or volume == 0 else '\uf028' if volume >= 50 else '\uf027'
    args = ['sketchybar', '--set', 'volume', f'icon={icon}',
            '--set', 'volume.level', f'label=Volume: {volume}%{" · muted" if muted else ""}',
            '--set', 'volume.mute', f'label={"Unmute" if muted else "Mute"}']
    # Output-device enumeration only on menu open, explicit actions, or initialization.
    if action or os.environ.get('SENDER') in ('mouse.clicked', 'forced', 'system_woke'):
        devices = [json.loads(line) for line in call(['SwitchAudioSource','-a','-t','output','-f','json']).splitlines() if line]
        current = json.loads(call(['SwitchAudioSource','-c','-t','output','-f','json']))
        bar = json.loads(call(['sketchybar','--query','bar']))
        for name in bar['items']:
            if name.startswith('volume.device.'):
                args += ['--remove', name]
        config = os.environ['CONFIG_DIR']
        for device in devices:
            ident = str(device['id'])
            if not ident.isdigit(): continue
            name = 'volume.device.' + ident
            args += ['--add','item',name,'popup.volume','--set',name,
                     f'label={device["name"]}',f'icon={"\uf00c" if ident == str(current["id"]) else "\uf025"}',
                     'icon.width=26','icon.font=RobotoMono Nerd Font:Regular:16.0','label.padding_left=14','label.padding_right=18',
                     f'click_script="{config}/plugins/volume.sh" device {ident}']
    subprocess.run(args, check=True)

if __name__ == '__main__':
    main()
