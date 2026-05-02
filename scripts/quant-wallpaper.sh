#!/bin/bash
# Quant BSPWM - Wallpaper Manager

WALLPAPER_DIR="$HOME/wallpapers"
CACHE_FILE="$HOME/.cache/quant-wallpaper-current"

mkdir -p "$WALLPAPER_DIR"

set_wallpaper() {
    local wall="$1"
    if [[ -f "$wall" ]]; then
        feh --bg-fill --no-fehbg "$wall"
        echo "$wall" > "$CACHE_FILE"
        notify-send -a "Wallpaper" -i preferences-desktop-wallpaper \
            "Wallpaper Changed" "$(basename "$wall")"
    fi
}

case "${1:-cycle}" in
    cycle)
        current=$(cat "$CACHE_FILE" 2>/dev/null || echo "")
        walls=($(find "$WALLPAPER_DIR" -type f \( -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' -o -name '*.webp' \) | sort))

        if [[ ${#walls[@]} -eq 0 ]]; then
            notify-send -a "Wallpaper" "No wallpapers found" "$WALLPAPER_DIR"
            exit 1
        fi

        next_idx=0
        for i in "${!walls[@]}"; do
            if [[ "${walls[$i]}" == "$current" ]]; then
                next_idx=$(( (i + 1) % ${#walls[@]} ))
                break
            fi
        done

        set_wallpaper "${walls[$next_idx]}"
        ;;
    random)
        wall=$(find "$WALLPAPER_DIR" -type f \( -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' -o -name '*.webp' \) | shuf -n1)
        if [[ -n "$wall" ]]; then
            set_wallpaper "$wall"
        else
            notify-send -a "Wallpaper" "No wallpapers found" "$WALLPAPER_DIR"
        fi
        ;;
    select)
        wall=$(find "$WALLPAPER_DIR" -type f \( -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' -o -name '*.webp' \) | \
            rofi -dmenu -p "Wallpaper" -theme "$HOME/.config/rofi/themes/quant-launcher.rasi")
        if [[ -n "$wall" ]]; then
            set_wallpaper "$wall"
        fi
        ;;
    *)
        if [[ -f "$1" ]]; then
            set_wallpaper "$1"
        else
            echo "Usage: $0 {cycle|random|select|<path>}"
            exit 1
        fi
        ;;
esac
