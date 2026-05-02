#!/bin/bash
# Quant BSPWM - Color Picker

if command -v xcolor &>/dev/null; then
    COLOR=$(xcolor --format hex 2>/dev/null)
elif command -v gpick &>/dev/null; then
    COLOR=$(gpick -so 2>/dev/null)
elif command -v colorpicker &>/dev/null; then
    COLOR=$(colorpicker --short --one-shot 2>/dev/null)
else
    notify-send -a "Color Picker" -u critical "No color picker found" \
        "Install one: pacman -S xcolor"
    exit 1
fi

if [[ -n "$COLOR" ]]; then
    echo -n "$COLOR" | xclip -selection clipboard
    notify-send -a "Color Picker" "Color Copied" "$COLOR"
fi
