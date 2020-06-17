#!/bin/bash

file=~/.config/scripts/lockNEW3.png

PARAM=(--bar-indicator --bar-position h --bar-direction 1 --redraw-thread -t "" \
        --bar-step 50 --bar-width 250 --bar-base-width 50 --bar-max-height 100 --bar-periodic-step 50 \
        --bar-color 00000077 --keyhlcolor 00666666 --ringvercolor cc87875f --wrongcolor ffff0000 \
        --veriftext="" --wrongtext="" --noinputtext="" )
i3lock -n "${PARAM[@]}" -i "$file" >/dev/null 2>&1 &

sleep 2
printf "Your Sudo password" | base64 -d | sudo -S systemctl suspend

#Optional. If script is run from a Dell Latitude e5570, to disable BIOS fan control and the the system handle it.
#sleep 5
#printf "Your Sudo Password" | base64 -d | sudo -S /home/a/dell-bios-fan-control/dell-bios-fan-control enable
