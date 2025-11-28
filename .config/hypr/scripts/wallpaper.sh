#!/bin/zsh

# --- CONFIG ----
WALLPAPER_DIR="$HOME/.wallpapers/catalina_frames"
FRAMES=8
START_HOUR=8
END_HOUR=2
TRANSITION_TYPE="grow"
TRANSITION_DURATION=2

# Ensure PATH when run by Hypr
export PATH="$PATH:/usr/bin:/usr/local/bin:$HOME/.local/bin"

# Start swww daemon if not running
if ! pgrep -x swww-daemon >/dev/null; then
    swww-daemon &
    sleep 1
fi

# Time per frame (24h / 8 frames = 180 minutes, but Catalina uses 135, so fine)
INTERVAL=$((135 * 60))

while true; do
    hour=$(date +%H)
    minute=$(date +%M)
    current=$((hour * 60 + minute))

    start=$((START_HOUR * 60))
    end=$((END_HOUR * 60 + 1440))

    # Adjust for after-midnight window
    if (( END_HOUR < START_HOUR )); then
        if (( current < start )); then
            current=$((current + 1440))
        fi
    fi

    # Check active time window
    if (( current >= start && current < end )); then
        elapsed=$((current - start))
        index=$((elapsed / (INTERVAL/60) + 1))

        if (( index > FRAMES )); then
            index=$FRAMES
        fi

        img="$WALLPAPER_DIR/frame-$index.jpg"

        if [[ -f "$img" ]]; then
            swww img "$img" \
                --transition-type "$TRANSITION_TYPE" \
                --transition-duration "$TRANSITION_DURATION"
        fi

        sleep $INTERVAL
    else
        # Sleep until next cycle
        next_sleep=$(( (start - (current % 1440) + 1440) % 1440 ))
        sleep $((next_sleep * 60))
    fi
done
