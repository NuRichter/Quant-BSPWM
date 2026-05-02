#!/bin/bash
# Quant BSPWM - Media Notification (playerctl)

PLAYER="${1:-spotify}"

if ! command -v playerctl &>/dev/null; then
    exit 1
fi

STATUS=$(playerctl -p "$PLAYER" status 2>/dev/null)
[[ -z "$STATUS" ]] && STATUS=$(playerctl status 2>/dev/null)
[[ -z "$STATUS" ]] && exit 0

TITLE=$(playerctl -p "$PLAYER" metadata title 2>/dev/null || playerctl metadata title 2>/dev/null)
ARTIST=$(playerctl -p "$PLAYER" metadata artist 2>/dev/null || playerctl metadata artist 2>/dev/null)
ALBUM=$(playerctl -p "$PLAYER" metadata album 2>/dev/null || playerctl metadata album 2>/dev/null)

ART_URL=$(playerctl -p "$PLAYER" metadata mpris:artUrl 2>/dev/null || playerctl metadata mpris:artUrl 2>/dev/null)
ART_FILE=""

# Download album art for notification
if [[ -n "$ART_URL" ]]; then
    ART_FILE="/tmp/quant-media-art.jpg"
    if [[ "$ART_URL" == file://* ]]; then
        cp "${ART_URL#file://}" "$ART_FILE" 2>/dev/null
    else
        curl -sL "$ART_URL" -o "$ART_FILE" 2>/dev/null
    fi
fi

ICON_ARG=""
[[ -f "$ART_FILE" ]] && ICON_ARG="-i $ART_FILE"

case "$STATUS" in
    Playing) STATUS_ICON="" ;;
    Paused)  STATUS_ICON="" ;;
    Stopped) STATUS_ICON="" ;;
    *)       STATUS_ICON="" ;;
esac

BODY="$ARTIST"
[[ -n "$ALBUM" ]] && BODY="$ARTIST\n$ALBUM"

dunstify -a "Media" $ICON_ARG \
    -h string:x-dunst-stack-tag:media \
    "$STATUS_ICON $TITLE" "$BODY" \
    -u low -t 3000
