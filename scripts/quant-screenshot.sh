#!/bin/bash
# Quant BSPWM - Screenshot Utility

SAVE_DIR="$HOME/Pictures/Screenshots"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
FILENAME="quant_${TIMESTAMP}.png"

mkdir -p "$SAVE_DIR"

notify_screenshot() {
    local filepath="$1"
    if [[ -f "$filepath" ]]; then
        notify-send -a "Screenshot" -i "$filepath" \
            "Screenshot Saved" \
            "$(basename "$filepath")\n$(du -h "$filepath" | cut -f1)"
    fi
}

case "${1:-full}" in
    full)
        maim "$SAVE_DIR/$FILENAME"
        xclip -selection clipboard -t image/png < "$SAVE_DIR/$FILENAME"
        notify_screenshot "$SAVE_DIR/$FILENAME"
        ;;
    select)
        maim -s -b 2 -c 0.96,0.76,0.91,0.3 "$SAVE_DIR/$FILENAME"
        if [[ -f "$SAVE_DIR/$FILENAME" ]]; then
            xclip -selection clipboard -t image/png < "$SAVE_DIR/$FILENAME"
            notify_screenshot "$SAVE_DIR/$FILENAME"
        fi
        ;;
    window)
        maim -i "$(xdotool getactivewindow)" "$SAVE_DIR/$FILENAME"
        xclip -selection clipboard -t image/png < "$SAVE_DIR/$FILENAME"
        notify_screenshot "$SAVE_DIR/$FILENAME"
        ;;
    clipboard)
        maim -s -b 2 -c 0.96,0.76,0.91,0.3 | xclip -selection clipboard -t image/png
        notify-send -a "Screenshot" "Screenshot" "Copied to clipboard"
        ;;
    *)
        echo "Usage: $0 {full|select|window|clipboard}"
        exit 1
        ;;
esac
