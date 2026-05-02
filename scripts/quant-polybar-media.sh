#!/bin/bash
# Quant BSPWM - Polybar Media Player Module

if ! command -v playerctl &>/dev/null; then
    echo ""
    exit 0
fi

STATUS=$(playerctl status 2>/dev/null)

if [[ -z "$STATUS" || "$STATUS" == "Stopped" ]]; then
    echo ""
    exit 0
fi

TITLE=$(playerctl metadata title 2>/dev/null | cut -c1-35)
ARTIST=$(playerctl metadata artist 2>/dev/null | cut -c1-20)

case "$STATUS" in
    Playing) ICON="" ;;
    Paused)  ICON="" ;;
    *)       ICON="" ;;
esac

if [[ -n "$ARTIST" ]]; then
    echo "$ICON $ARTIST ~ $TITLE"
else
    echo "$ICON $TITLE"
fi
