#!/bin/bash
# The native clock menu bar item opens macOS Notification Center.
# Requires System Events Accessibility/Automation permission.
/usr/bin/osascript <<'APPLESCRIPT'
tell application "System Events"
  tell process "ControlCenter"
    repeat with itemRef in menu bar items of menu bar 1
      try
        if value of attribute "AXIdentifier" of itemRef is "com.apple.menuextra.clock" then
          click itemRef
          return
        end if
      end try
    end repeat
    error "Native clock item unavailable; enable the macOS clock in Menu Bar settings."
  end tell
end tell
APPLESCRIPT
