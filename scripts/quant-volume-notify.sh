#!/bin/bash
# Quant BSPWM - Volume Notification

VOL=$(pamixer --get-volume 2>/dev/null || echo "0")
MUTED=$(pamixer --get-mute 2>/dev/null || echo "false")

if [[ "$MUTED" == "true" ]]; then
    ICON="audio-volume-muted"
    TEXT="Muted"
else
    if [[ $VOL -ge 70 ]]; then
        ICON="audio-volume-high"
    elif [[ $VOL -ge 30 ]]; then
        ICON="audio-volume-medium"
    else
        ICON="audio-volume-low"
    fi
    TEXT="${VOL}%"
fi

dunstify -a "Volume" -i "$ICON" -h string:x-dunst-stack-tag:volume \
    -h int:value:"$VOL" "Volume" "$TEXT" -u low -t 1500
