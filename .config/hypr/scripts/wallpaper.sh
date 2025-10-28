#!/bin/zsh

# === Catalina-style Dynamic Wallpaper Script ===
# Cycles through 8 frames between 8 AM and 2 AM using swww

# --- CONFIG ---
WALLPAPER_DIR="$HOME/.wallpapers/catalina_frames"
FRAMES=8
START_HOUR=8       # 8 AM
END_HOUR=2         # 2 AM (next day)
TRANSITION_TYPE="grow"
TRANSITION_DURATION=2

# --- Derived values ---
TOTAL_ACTIVE_MINUTES=$(( ((24 - START_HOUR + END_HOUR) % 24) * 60 ))  # 18 hours = 1080 minutes
INTERVAL=$((TOTAL_ACTIVE_MINUTES / FRAMES))  # 135 minutes per frame

# --- Ensure swww is installed ---
if ! command -v swww >/dev/null 2>&1; then
  echo "Error: swww not found in PATH. Install it first."
  exit 1
fi

# --- Function to start swww-daemon safely ---
function start_swww_daemon() {
  local SOCKET_PATH="${XDG_RUNTIME_DIR}/swww.socket"

  if ! pgrep -x swww-daemon >/dev/null; then
    rm -f "$SOCKET_PATH"
    swww-daemon &>> ~/.local/share/swww-daemon.log &
    sleep 0.5
    swww restore 2>/dev/null
  fi
}

# --- Main Loop ---
while true; do
  # Current time in minutes since midnight
  HOUR=$(date +%H)
  MIN=$(date +%M)
  CURRENT_MINUTES=$((10#$HOUR * 60 + 10#$MIN))

  # Convert to minutes since START_HOUR (cyclic 24-hour)
  MINUTES_SINCE_START=$(( (CURRENT_MINUTES - (START_HOUR * 60) + 1440) % 1440 ))

  # Only run between START_HOUR and END_HOUR
  if (( MINUTES_SINCE_START < TOTAL_ACTIVE_MINUTES )); then
    start_swww_daemon

    # Determine current frame index (1–FRAMES)
    IDX=$((MINUTES_SINCE_START / INTERVAL + 1))
    IMG="frame-${IDX}.jpg"

    # Apply wallpaper if it exists
    if [ -f "$WALLPAPER_DIR/$IMG" ]; then
      swww img "$WALLPAPER_DIR/$IMG" \
        --transition-type "$TRANSITION_TYPE" \
        --transition-duration "$TRANSITION_DURATION"
    else
      echo "[$(date)] WARNING: File $IMG not found, skipping." >> ~/.catalina.log
    fi

    # Sleep until next frame change
    WAIT_MINUTES=$((INTERVAL - (MINUTES_SINCE_START % INTERVAL)))
    sleep $((WAIT_MINUTES * 60))
  else
    # Outside 8AM–2AM window: sleep until 8 AM
    NEXT_START=$(( (START_HOUR * 60 - CURRENT_MINUTES + 1440) % 1440 ))
    sleep $((NEXT_START * 60))
  fi
done
