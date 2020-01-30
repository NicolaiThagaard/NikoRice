#!/bin/bash
sleep 10
tmux new-session -s a -d \; \
  send-keys "printf 'Koden i Base64' | base64 -d | sudo -S /home/a/VPNscript2.sh " C-m \; \
  split-window -v \; \
  send-keys "printf 'Koden i Base64' | base64 -d | sudo -S xinit qbittorrent $* -- :1" C-m \; 
exit 0 


