#!/bin/zsh
current=$(ddcutil getvcp 10 --brief | awk '{print $4}')
new=$((current - 10))
if [ $new -lt 0 ]; then new=0; fi
ddcutil setvcp 10 $new
