#!/usr/bin/env bash

STATE_FILE="$HOME/.config/hypr/monitor_layout"

# Read current state or default to portrait
if [ -f "$STATE_FILE" ]; then
    CURRENT_STATE=$(cat "$STATE_FILE" | tr -d '[:space:]')
else
    CURRENT_STATE="portrait"
fi

if [ "$CURRENT_STATE" = "portrait" ]; then
    NEW_STATE="landscape"
    MSG="DP-2 switched to Landscape (1920x1080)"
else
    NEW_STATE="portrait"
    MSG="DP-2 switched to Portrait Flipped (1080x1920)"
fi

# Save new state
echo "$NEW_STATE" > "$STATE_FILE"

# Re-eval monitors.lua dynamically in Hyprland
hyprctl eval 'dofile(os.getenv("HOME") .. "/.config/hypr/monitors.lua")'

# Send notification if notify-send is available
if command -v notify-send >/dev/null 2>&1; then
    notify-send -a "Hyprland" "Monitor Layout Changed" "$MSG" -i display
fi
