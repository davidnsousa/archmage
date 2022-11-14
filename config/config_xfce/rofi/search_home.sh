#!/bin/bash

options="$(find /home/david -print)"

chosen="$(echo -e "$options" | rofi -dmenu -config ~/.config/rofi/config_search_home.rasi)"

xdg-open "$chosen"
