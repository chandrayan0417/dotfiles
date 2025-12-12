#!/bin/zsh
current=$(ddcutil getvcp 10 --brief | awk '{print $4}')
new=$((current + 10))
if [ $new -gt 100 ]; then new=100; fi
ddcutil setvcp 10 $new
