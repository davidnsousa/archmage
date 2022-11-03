#!/bin/bash

options="$(find /home/david -print)"

chosen="$(echo -e "$options" | rofi -dmenu )"

xdg-open "$chosen"
