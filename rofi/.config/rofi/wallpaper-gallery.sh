#!/usr/bin/env bash

# --- CONFIGURATION ---
WALLPAPERS_DIR="$HOME/Pictures/Wallpaper"
PREVIEW_FILE="$HOME/.config/hypr/current_wallpaper" 
# ---------------------

shopt -s nocaseglob
shopt -s nullglob

gen_list() {
    cd "$WALLPAPERS_DIR"
    for img in *.{jpg,jpeg,png,gif,webp}; do
        echo -en "$img\0icon\x1f$WALLPAPERS_DIR/$img\n"
    done
}

SELECTED=$(gen_list | rofi -dmenu \
    -p "Wallpaper" \
    -display-columns 4 \
    -theme-str 'window { width: 50%; height: 60%; }' \
    -theme-str 'mainbox { children: [ "inputbar", "listview" ]; }' \
    -theme-str 'listview { columns: 4; lines: 3; spacing: 10px; padding: 10px; }' \
    -theme-str 'element { orientation: vertical; padding: 10px; border-radius: 10px; }' \
    -theme-str 'element-icon { size: 200px; horizontal-align: 0.5; }' \
    -theme-str 'element-text { enabled: false; }' \
    -theme-str 'entry { placeholder: "Search..."; }'
)

if [ -n "$SELECTED" ]; then
    FULL_PATH="$WALLPAPERS_DIR/$SELECTED"	
    
    swww img "$FULL_PATH" --transition-type grow --transition-pos 0.9,0.9 --transition-step 90 --transition-fps 144
    cp "$FULL_PATH" "$PREVIEW_FILE"
    notify-send "Wallpaper changed" "Applied: $@"
 
    #Custom hooks
    matugen image "$FULL_PATH" >> /dev/null
    killall -SIGUSR2 waybar >> /dev/null
fi
