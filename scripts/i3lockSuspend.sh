#!/bin/bash
#file=~/.config/scripts/lock2.png

#script der sætter baggrundsbilledet alt efter hvad klokken er
#/home/a/.config/scripts/TimeBasedTheme.sh 

file=~/.config/scripts/lockNEW3.png

PARAM=(--bar-indicator --bar-position h --bar-direction 1 --redraw-thread -t "" \
        --bar-step 50 --bar-width 250 --bar-base-width 50 --bar-max-height 100 --bar-periodic-step 50 \
        --bar-color 00000077 --keyhlcolor 00666666 --ringvercolor cc87875f --wrongcolor ffff0000 \
        --veriftext="" --wrongtext="" --noinputtext="" )
i3lock -n "${PARAM[@]}" -i "$file" >/dev/null 2>&1 &

sleep 2
printf "Your Sudo password" | base64 -d | sudo -S systemctl suspend
sleep 5
printf "Your Sudo Password" | base64 -d | sudo -S /home/a/dell-bios-fan-control/dell-bios-fan-control enable
/home/a/.config/scripts/i8kctl.sh
sleep 1
/home/a/.config/scripts/i8kctl.sh
sleep 10
/home/a/.config/scripts/i8kctl.sh
sleep 30
/home/a/.config/scripts/i8kctl.sh

#i3lock -i /home/a/baggrunde/baggrund3.jpg
