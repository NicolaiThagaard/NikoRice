#!/bin/bash
time=$(date +%k%M)
for i in {1..1}; do
if [[ "$time" -ge 0730 ]] && [[ "$time" -le 1830 ]];then
      /home/a/.local/bin/wal -i /home/a/baggrunde/macro.png -a 90
else
      /home/a/.local/bin/wal -i /home/a/baggrunde/KhyzylSaleem6_1366x768.jpg -a 90
fi
done

#Scriptet er som reference i .config/scripts/i3lock.sh
