#!/bin/zsh
# Full path to your start_container.sh
SCRIPT="path/to/vivado-on-silicon-mac-main/scripts/start_container.sh"

# Open Terminal and run the script
osascript <<EOF
tell application "Terminal"
    activate
    do script "zsh '$SCRIPT'"
end tell
EOF
