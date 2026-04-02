#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    echo -en "Wallpaper Gallery"
else
    ~/.config/rofi/wallpaper-gallery.sh >/dev/null 2>&1 &
    disown
    exit 0
fi
