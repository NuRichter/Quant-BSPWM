#!/bin/bash
# Quant BSPWM - Brightness Notification

BRIGHTNESS=$(brightnessctl -m | cut -d',' -f4 | tr -d '%')

dunstify -a "Brightness" -i display-brightness -h string:x-dunst-stack-tag:brightness \
    -h int:value:"$BRIGHTNESS" "Brightness" "${BRIGHTNESS}%" -u low -t 1500
