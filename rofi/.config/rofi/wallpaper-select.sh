#!/usr/bin/env bash

if [ -z "$@" ]; then
    echo -en "Wallpaper Gallery"
else
	coproc ( ~/.config/rofi/wallpaper-gallery.sh > /dev/null 2>&1 )
    exit 0
fi
