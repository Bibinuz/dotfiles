#!/usr/bin/env bash

# Options
lock="󰌾   Lock"
suspend="󰤄   Suspend"
logout="󰗽   Logout"
reboot="󰑐   Reboot"
shutdown="󰐥   Power Off"

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-theme ~/.config/rofi/powermenu.rasi
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
chosen="$(run_rofi)"
case ${chosen} in
    $lock)
		hyprlock
        ;;
    $suspend)
		systemctl suspend
        ;;
    $logout)
		hyprctl dispatch exit
        ;;
    $reboot)
		systemctl reboot
        ;;
    $shutdown)
		systemctl poweroff
        ;;
esac