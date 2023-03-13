#!/bin/bash

option0="Wallpaper"
option1="Themes"
option2="Default Applications"
option3="Sound"
option4="Display"
option5="Network"
option6="Bluetooth Manager"
option7="Panels and Menus"
option8="Openbox"

options="$option0\n$option1\n$option2\n$option3\n$option4\n$option5\n$option6\n$option7\n$option8"

chosen="$(echo -e "$options" | dmenu -nb '#383c4a' -nf '#ffffff' -sb '#5294e2' -fn 'DejaVu Sans:size=9.6' -p "Configurations:")"
case $chosen in
	$option0)
		$SETWALLPAPER;;
	$option1)
		$SETAPPEARANCE;;
	$option2)
		$SETDEFAPPS;;
	$option3)
		$CTRLSOUND;;
	$option4)
		$CTRLDISPLAYS;;
	$option5)
		$CTRLNETWORK;;
	$option6)
		$CTRLBLUETOOTH;;
	$option7)
		$EDITOR $XDG_CONFIG_HOME/lemonbar/*;;
	$option8)
		$EDITOR $XDG_CONFIG_HOME/openbox/*;;
esac
