#!/bin/bash
# Random wallpaper picker for swaybg

WALLPAPER_DIR="${WALLPAPER_DIR:-/usr/share/backgrounds/sway}"

pkill swaybg 2>/dev/null

if [ -n "$1" ] && [ -f "$1" ]; then
    img="$1"
else
    mapfile -t imgs < <(find "$WALLPAPER_DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) 2>/dev/null)
    if [ ${#imgs[@]} -eq 0 ]; then
        notify-send -u critical "No wallpapers found in $WALLPAPER_DIR"
        exit 1
    fi
    img="${imgs[RANDOM % ${#imgs[@]}]}"
fi

swaybg -i "$img" -m fill &>/dev/null &
disown
