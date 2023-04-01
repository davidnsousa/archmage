#!/bin/bash


option1="Logout"
option2="Reboot"
option3="Shutdown"

options="$option1\n$option2\n$option3"

chosen="$(echo -e "$options" | dmenu -nb '#383c4a' -nf '#ffffff' -sb '#5294e2' -fn 'DejaVu Sans:size=9.6' -p "Exit:")"
case $chosen in
	$option1)
		openbox --exit;;
	$option2)
		reboot;;
	$option3)
		shutdown now;;
esac
