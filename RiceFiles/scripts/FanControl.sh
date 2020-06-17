#!/bin/bash
#This script checks whether fans are spinning at the desired speed.
#The goal is to keep the fans spinning at 2500 rpm at all times, except;
#If the temperature reaches over 65 degrees the fan will spin at full speed. 
#If the temperature drops to under 65 degrees the fan will decrease speed.
#This command can be used behind "head -n 1" to specify grep further: 
# | grep -x -E '[[:blank:]]*[0-9]+[[:blank:]]*'


while true; do
	FANSPEED=$(sensors | grep "Processor Fan" | grep -o '[0-9]*')
                if [[ $FANSPEED -le 2000 ]]; then
                        i8kctl fan - 1
                elif [[ $? -gt 3000 ]]; then
                        i8kctl fan - 1
                fi
                sleep 5
        CPUTEMP=$(sensors | grep "CPU:" | grep -o '[0-9]*' | head -n 1)
                if [[ $CPUTEMP -le 65 ]]; then
                        i8kctl fan - 1
                elif [[ $CPUTEMP -gt 65 ]]; then
                        i8kctl fan - 2
                fi
done

