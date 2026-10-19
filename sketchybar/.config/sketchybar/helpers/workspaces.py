"""Update focused-workspace styling while keeping numbered badges minimal."""
import subprocess


def main():
    try:
        focused = subprocess.check_output(
            ['aerospace', 'list-workspaces', '--focused'], text=True, timeout=4).strip()
    except subprocess.SubprocessError:
        return
    args = ['sketchybar']
    for workspace in map(str, range(1, 8)):
        active = workspace == focused
        args += ['--set', 'space.' + workspace,
                 f'background.drawing={"on" if active else "off"}',
                 f'label.color={"0xff1e1e2e" if active else "0xffcdd6f4"}']
    subprocess.run(args, check=True)


if __name__ == '__main__':
    main()
