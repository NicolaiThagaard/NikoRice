#!/bin/bash
##Changes ressulution to default of the hdmi monitor and disables the laptop monitor
PATH="${PATH}:${HOME}/.local/bin/"
#HDMICHECK=$(xrandr | grep " connected " | awk '{ print$1 }' | grep HDMI-1)
xrdb ${HOME}/.Xressources
#if [[ $HDMICHECK -eq "HDMI1" ]]
#then
#	echo "HDMI Monitor found"
#	xrandr --output HDMI-1 --auto
#	xrandr --output eDP-1 --off
#	wal -i /home/a/ibm.jpg -a 80
#else
#	echo "HDMI Monitor not fouind"
	wal -i ${HOME}/baggrunde/macro.png -a 80
#fi
##Add more stuff
urxvt -name dropdown &> /dev/null &
urxvt -name pulsemixer -e ${HOME}/.config/scripts/pulsemixer.sh &> /dev/null &
