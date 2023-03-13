#!/bin/bash

option0="Lock"
option1="Logout"
option2="Suspend"
option3="Reboot"
option4="Shutdown"

options="$option0\n$option1\n$option2\n$option3\n$option4"

chosen="$(echo -e "$options" | dmenu -nb '#383c4a' -nf '#ffffff' -sb '#5294e2' -fn 'DejaVu Sans:size=9.6' -p "Exit:")"
case $chosen in
	$option0)
		dm-tool lock;;
	$option1)
		xfce4-session-logout -f -l || openbox --exit;;
	$option2)
		xfce4-session-logout -s || ( dm-tool lock && systemctl suspend);;
	$option3)
		reboot;;
	$option4)
		shutdown now;;
esac
