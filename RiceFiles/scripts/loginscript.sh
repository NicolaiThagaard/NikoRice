#!/bin/bash
PATH="${PATH}:${HOME}/.local/bin/"

xrdb ${HOME}/.Xressources
wal -i ${HOME}/baggrunde/macro.png -a 80

##Add more stuff
urxvt -name dropdown &> /dev/null &
urxvt -name pulsemixer -e ${HOME}/.config/scripts/pulsemixer.sh &> /dev/null &
