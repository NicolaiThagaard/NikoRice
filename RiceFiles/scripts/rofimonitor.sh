#!/bin/bash
#Author: Michael Sørensen 
source ~/.config/settings.conf

case $1 in
	built-in)
		xrandr --output eDP1 --auto --output HDMI1 --off --output DP3 --off
		setwal
	;;
	hdmi)
		xrandr --output eDP1 --mode 1366x768 --pos 0x0 --rotate normal --output HDMI1 --primary --preferred --pos 1366x0 --rotate normal --output DP3 --off
		setwal
	;;
	only-hdmi)
		xrandr --output eDP1 --off --output DP3 --off --output HDMI1 --auto
		setwal
	;;
	vga)
		xrandr --output eDP1 --mode 1366x768 --pos 0x0 --rotate normal --output DP3 --primary --preferred --pos 1366x0 --rotate normal --output HDMI1 --off
		setwal
	;;
	only-vga)
		xrandr --output eDP1 --off --output HDMI1 --off --output DP3 --auto
		setwal
	;;
	*)
		echo "Usage: ${0} {built-in|hdmi|only-hdmi|vga|only-vga}"
	;;
esac
