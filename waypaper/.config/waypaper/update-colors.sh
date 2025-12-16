#!/bin/bash

# Log output to a file for debugging
LOG_FILE="$HOME/waypaper-debug.log"
echo "--- Script started at $(date) ---" >> "$LOG_FILE"
echo "Wallpaper path received: $1" >> "$LOG_FILE"

# 1. Set the Path (Crucial for scripts run by GUI apps)
export PATH=$PATH:/usr/local/bin:/usr/bin

# 2. Run Matugen
# We use full paths just to be safe
matugen image "$1" >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "Matugen success" >> "$LOG_FILE"
else
    echo "Matugen failed" >> "$LOG_FILE"
fi

# 3. Reload Waybar
killall -SIGUSR2 waybar >> "$LOG_FILE" 2>&1

echo "--- Script finished ---" >> "$LOG_FILE"
