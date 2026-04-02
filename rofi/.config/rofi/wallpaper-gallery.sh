#!/usr/bin/env bash

# --- CONFIGURATION ---
WALLPAPERS_DIR="$HOME/Pictures/Wallpaper"
PREVIEW_FILE="$HOME/.config/hypr/current_wallpaper"
# ---------------------

if [ ! -d "$WALLPAPERS_DIR" ]; then
    notify-send "Wallpaper Gallery" "Directory $WALLPAPERS_DIR does not exist."
    exit 1
fi

shopt -s nocaseglob
shopt -s nullglob

gen_list() {
	cd "$WALLPAPERS_DIR"
	for img in *.{jpg,jpeg,png,gif,webp}; do
		echo -en "$img\0icon\x1f$WALLPAPERS_DIR/$img\n"
	done
}

# --- DYNAMIC SIZING ---
# Fetch monitor width using hyprctl (fallback to 1920 if it fails)
mon_width=$(hyprctl monitors | awk '/^[[:space:]]+[0-9]+x[0-9]+@/ {print $1}' | cut -d'x' -f1 | head -n1)
if [ -z "$mon_width" ]; then
    mon_width=1920
fi

# Calculate icon size: ~16% of total monitor width to comfortably fit 4 columns inside an 80% window
icon_size=$(( mon_width * 16 / 100 ))
# ----------------------

SELECTED=$(
	gen_list | rofi -dmenu \
		-theme-str 'window { width: 80%; height: 80%; }' \
		-theme-str 'mainbox { children: [ "listview" ]; padding: 20px; }' \
		-theme-str 'listview { columns: 4; lines: 3; spacing: 20px; padding: 10px; flow: horizontal; layout: vertical; fixed-height: true; fixed-columns: true; }' \
		-theme-str 'element { orientation: vertical; padding: 10px; border-radius: 15px; }' \
		-theme-str "element-icon { size: ${icon_size}px; horizontal-align: 0.5; }" \
		-theme-str 'element-text { enabled: false; }'
)

if [ -n "$SELECTED" ]; then
	FULL_PATH="$WALLPAPERS_DIR/$SELECTED"

	awww img "$FULL_PATH" --transition-type grow --transition-pos 0.9,0.9 --transition-step 90 --transition-fps 144
	cp "$FULL_PATH" "$PREVIEW_FILE"
	#Custom hooks
	matugen image "$FULL_PATH" --source-color-index 0 >/dev/null 2>&1
	killall -SIGUSR2 waybar >/dev/null 2>&1
	notify-send "Wallpaper changed" "Applied: $FULL_PATH"
fi
