#!/bin/zsh
set -e

# Infinite loop to monitor KDE Connect
while true; do
    # Check internet
    if ! ping -q -c1 -W2 8.8.8.8 >/dev/null 2>&1; then
        # No internet → kill KDE Connect
        pkill -x kdeconnectd || true
        sleep 30
        continue
    fi

    # Skip if any KDE Connect device is connected
    devices=$(kdeconnect-cli --list-devices --id-only | tr -d "[:space:]")
    if [[ -n "$devices" ]]; then
        sleep 30
        continue
    fi

    # Internet available and no devices → restart KDE Connect
    pkill -x kdeconnectd || true
    nohup kdeconnectd >/dev/null 2>&1 &

    sleep 30
done
