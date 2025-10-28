#!/bin/zsh

DIR="$HOME/Pictures/screenshots"
mkdir -p "$DIR"

FILE="$DIR/screenshot_$(date +%s).png"

# Check argument: full or region
if [[ "$1" == "full" ]]; then
    # Full screen screenshot
    if grim "$FILE"; then
        wl-copy < "$FILE"
        notify-send "Screenshot Saved" "Full screen: $FILE"
    fi
else
    # Region screenshot
    if grim -g "$(slurp)" "$FILE"; then
        wl-copy < "$FILE"
        notify-send "Screenshot Saved" "Region: $FILE"
    fi
fi

