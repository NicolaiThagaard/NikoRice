#!/bin/bash
L=0
while true
do
        bash mappeshit.sh $L &
        let "L++"
done
