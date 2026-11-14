"""Read battery popup details without changing power or charging settings."""
import json
import re
import subprocess


def power_details(text):
    match = re.search(r'(\d+)%;', text)
    if not match:
        return None
    percent = int(match.group(1))
    external = 'AC Power' in text
    charging = bool(re.search(r';\s*charging;', text))
    if external:
        if percent == 100 or re.search(r';\s*charged;', text):
            status = 'Fully charged · plugged in'
        elif charging:
            status = 'Charging'
        else:
            status = 'Plugged in · charging paused'
    else:
        status = 'Running on battery'
    remaining = re.search(r'(\d+):(\d+)\s+remaining', text)
    estimate = None
    if remaining and (charging or not external):
        hours, minutes = map(int, remaining.groups())
        estimate = f'{"Time to full" if charging else "Time remaining"}: {hours}h {minutes:02}m'
    elif 'no estimate' in text.lower() and (charging or not external):
        estimate = 'Time estimate: Calculating…'
    return {'charge': f'Charge: {percent}%', 'status': status, 'time': estimate}


def health_details(tree):
    if isinstance(tree, dict):
        if 'sppower_battery_health_info' in tree:
            return tree['sppower_battery_health_info']
        for value in tree.values():
            result = health_details(value)
            if result:
                return result
    elif isinstance(tree, list):
        for value in tree:
            result = health_details(value)
            if result:
                return result
    return {}


def main():
    try:
        text = subprocess.check_output(['/usr/bin/pmset', '-g', 'batt'], text=True, timeout=3)
        details = power_details(text)
    except (OSError, subprocess.SubprocessError):
        return
    if details is None:
        return
    try:
        health = health_details(json.loads(subprocess.check_output(
            ['/usr/sbin/system_profiler', 'SPPowerDataType', '-json'], text=True, timeout=8)))
    except (OSError, ValueError, subprocess.SubprocessError):
        health = {}
    condition = health.get('sppower_battery_health')
    capacity = health.get('sppower_battery_health_maximum_capacity')
    cycles = health.get('sppower_battery_cycle_count')
    details.update({
        'health': f'Condition: {condition}' if condition else None,
        'capacity': f'Maximum capacity: {capacity}' if capacity else None,
        'cycles': f'Cycle count: {cycles}' if cycles is not None else None,
    })
    args = ['sketchybar']
    for key, value in details.items():
        args += ['--set', 'battery.' + key, f'drawing={"on" if value else "off"}']
        if value:
            args += [f'label={value}']
    subprocess.run(args, check=True)


if __name__ == '__main__':
    main()
