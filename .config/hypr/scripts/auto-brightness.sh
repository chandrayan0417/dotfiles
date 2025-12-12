#!/bin/zsh

while true; do
  hour=$(date +%H)

  if ((hour >= 6 && hour < 10)); then
    level=50 # Morning
  elif ((hour >= 10 && hour < 16)); then
    level=70 # Noon
  elif ((hour >= 16 && hour < 18)); then
    level=50 # Afternoon
  elif ((hour >= 18 && hour < 22)); then
    level=30 # Night
  else
    level=20 # Late night
  fi

  ddcutil setvcp 10 $level
  sleep 300
done
