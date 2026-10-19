on run argv
  set destination to POSIX file (item 1 of argv)
  tell application "Music"
    if not running then return ""
    set artworkBytes to raw data of artwork 1 of current track
  end tell
  set outputFile to open for access destination with write permission
  try
    set eof outputFile to 0
    write artworkBytes to outputFile
    close access outputFile
  on error messageText number errorNumber
    close access outputFile
    error messageText number errorNumber
  end try
end run
