#!/bin/bash

# This script runs inside the container at start

script_dir=$(dirname -- "$(readlink -nf $0)";)
source "$script_dir/header.sh"
validate_linux

# Generate encoded VNC password
mkdir -p /home/user/.vnc
cat "$script_dir/vncpasswd" | vncpasswd -f > /home/user/.vnc/passwd

# Start VNC server with LXDE
vncserver -DisconnectClients -NeverShared \
    -nocursor \
    -geometry $(tr -d "\n\r\t " < "$script_dir/vnc_resolution") \
    -SecurityTypes VncAuth -PasswordFile /home/user/.vnc/passwd \
    -localhost no \
    -verbose -fg \
    -RawKeyboard -RemapKeys "0xffe9->0xff7e,0xffe7->0xff7e" \
    -- LXDE

# Wait a few seconds for LXDE to initialize
sleep 5

# Force LXDE components to start to restore desktop icons and file manager
# Runs inside LXDE session
export DISPLAY=:1
export XDG_RUNTIME_DIR=/tmp/runtime-user

# Start desktop manager and panel if not already running
pgrep -x pcmanfm > /dev/null || pcmanfm --desktop &
pgrep -x lxpanel > /dev/null || lxpanel &
pgrep -x xscreensaver > /dev/null || xscreensaver -no-splash &

# Optional: print info
echo "LXDE desktop components started. You can now open Vitis manually in a terminal:"
echo "/home/user/Xilinx/Vitis/2024.1/bin/vitis"
