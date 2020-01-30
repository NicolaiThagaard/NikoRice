#!/bin/bash
bash .config/scripts/glitchlock.sh &>/dev/zero & 
sleep 5
printf "Your Sudo password" | base64 -d | sudo -S systemctl suspend

