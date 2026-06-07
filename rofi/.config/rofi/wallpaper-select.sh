#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    echo -en "Wallpaper Gallery"
else
    quickshell ipc call wallpaper toggle >/dev/null 2>&1 &
    disown
    exit 0
fi
