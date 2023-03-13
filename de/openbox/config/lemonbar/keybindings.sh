#!/bin/bash

# Specify the Openbox configuration file
CONFIG_FILE=$XDG_CONFIG_HOME/openbox/rc.xml

# Use awk to extract keybindings and their commands/actions
output=$(awk -F'[<>"]+' '/<keybind/{key=$3}/<command>/{print key " => " $3}' "$CONFIG_FILE")

# Send output to dmenu
echo "$output" | dmenu -l 20 -nb '#383c4a' -nf '#ffffff' -sb '#5294e2' -fn 'DejaVu Sans:size=9.6'
