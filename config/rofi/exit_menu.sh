#!/bin/bash

option1="logout"
option2="suspend"
option3="reboot"
option4="shutdown"

options="$option1\n$option2\n$option3\n$option4"

chosen="$(echo -e "$options" | rofi -dmenu -config ~/.config/rofi/config_exit_menu.rasi)"
case $chosen in
	$option1)
		xfce4-session-logout --logout;;
	$option2)
		xfce4-session-logout --suspend;;
	$option3)
		reboot;;
	$option4)
		shutdown now;;
esac
