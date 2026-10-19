"""Connected-device battery metadata only; disconnected readings may be stale."""
import json
from pathlib import Path
import subprocess
import time

CACHE = Path.home() / 'Library/Caches/sketchybar-bluetooth'


def extract(tree):
    found = {}
    if isinstance(tree, dict):
        connected = tree.get('device_connected', [])
        for device in connected:
            for name, details in device.items():
                values = []
                for key, label in [('device_batteryLevelMain','Battery'),('device_batteryLevel','Battery'),
                                   ('device_batteryLevelLeft','L'),('device_batteryLevelRight','R'),
                                   ('device_batteryLevelCase','Case')]:
                    if key in details: values.append(f'{label} {details[key]}')
                if values:
                    text = ' · '.join(values)
                    found[name] = text
                    found[details.get('device_address','').lower().replace(':','-')] = text
        for value in tree.values(): found.update(extract(value))
    elif isinstance(tree,list):
        for value in tree: found.update(extract(value))
    return found


def main():
    CACHE.mkdir(parents=True,exist_ok=True)
    path = CACHE/'batteries.json'
    if path.exists() and time.time()-path.stat().st_mtime < 60:
        print(path.read_text()); return
    try:
        data = json.loads(subprocess.check_output(['/usr/sbin/system_profiler','SPBluetoothDataType','-json'],
                                                 text=True,timeout=8))
        result = extract(data)
    except (subprocess.SubprocessError, ValueError, OSError):
        result = {}
    # CoreBluetooth's standard GATT Battery Service covers BLE mice omitted by
    # system_profiler. Keep detailed AirPods values when they are available.
    try:
        helper = Path(__file__).with_name('bluetooth_battery')
        levels = json.loads(subprocess.check_output([str(helper)],text=True,timeout=6))
        for name, level in levels.items():
            if isinstance(level, (int,float)) and 0 <= level <= 100:
                result.setdefault(name, f'{level:g}%')
    except (subprocess.SubprocessError, ValueError, OSError):
        pass
    path.write_text(json.dumps(result))
    print(json.dumps(result))

if __name__ == '__main__': main()
