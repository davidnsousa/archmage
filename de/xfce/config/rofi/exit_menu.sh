#!/bin/bash

option0="Lock"
option1="Logout"
option2="Suspend"
option3="Reboot"
option4="Shutdown"

options="$option0\n$option1\n$option2\n$option3\n$option4"

chosen="$(echo -e "$options" | rofi -dmenu -config ~/.config/rofi/config_exit_menu.rasi)"
case $chosen in
	$option0)
		xflock4;;
	$option1)
		xfce4-session-logout -f -l;;
	$option2)
		xfce4-session-logout -s;;
	$option3)
		reboot;;
	$option4)
		shutdown now;;
esac
