#!/bin/bash
# Quant BSPWM - Display Layout Manager

THEME="$HOME/.config/rofi/themes/quant-powermenu.rasi"

INTERNAL=$(xrandr --query | grep " connected primary" | cut -d' ' -f1)
EXTERNAL=$(xrandr --query | grep " connected" | grep -v "$INTERNAL" | head -n1 | cut -d' ' -f1)

notify() {
    notify-send -a "Display" -i video-display "$1" "$2" -t 3000
}

if [[ -z "$EXTERNAL" ]]; then
    notify "Display" "Single monitor detected: $INTERNAL"
    exit 0
fi

options="  Internal only\n  External only\n  Extend right\n  Extend left\n  Mirror\n  Extend above"

chosen=$(echo -e "$options" | rofi -dmenu \
    -p "Display" \
    -mesg "  Internal: $INTERNAL | External: $EXTERNAL" \
    -theme "$THEME")

case "$chosen" in
    *"Internal only"*)
        xrandr --output "$EXTERNAL" --off --output "$INTERNAL" --auto --primary
        bspc monitor "$INTERNAL" -d 一 二 三 四 五 六 七 八 九 十
        notify "Internal Only" "$INTERNAL"
        ;;
    *"External only"*)
        xrandr --output "$INTERNAL" --off --output "$EXTERNAL" --auto --primary
        bspc monitor "$EXTERNAL" -d 一 二 三 四 五 六 七 八 九 十
        notify "External Only" "$EXTERNAL"
        ;;
    *"Extend right"*)
        xrandr --output "$INTERNAL" --primary --auto \
               --output "$EXTERNAL" --auto --right-of "$INTERNAL"
        bspc monitor "$INTERNAL" -d 一 二 三 四 五
        bspc monitor "$EXTERNAL" -d 六 七 八 九 十
        notify "Extended Right" "$INTERNAL + $EXTERNAL"
        ;;
    *"Extend left"*)
        xrandr --output "$INTERNAL" --primary --auto \
               --output "$EXTERNAL" --auto --left-of "$INTERNAL"
        bspc monitor "$INTERNAL" -d 一 二 三 四 五
        bspc monitor "$EXTERNAL" -d 六 七 八 九 十
        notify "Extended Left" "$EXTERNAL + $INTERNAL"
        ;;
    *"Mirror"*)
        xrandr --output "$INTERNAL" --primary --auto \
               --output "$EXTERNAL" --auto --same-as "$INTERNAL"
        bspc monitor "$INTERNAL" -d 一 二 三 四 五 六 七 八 九 十
        notify "Mirror" "$INTERNAL = $EXTERNAL"
        ;;
    *"Extend above"*)
        xrandr --output "$INTERNAL" --primary --auto \
               --output "$EXTERNAL" --auto --above "$INTERNAL"
        bspc monitor "$INTERNAL" -d 一 二 三 四 五
        bspc monitor "$EXTERNAL" -d 六 七 八 九 十
        notify "Extended Above" "$EXTERNAL above $INTERNAL"
        ;;
esac

# Reload polybar and wallpaper
sleep 0.5
"$HOME/.config/polybar/launch.sh" &
"$HOME/scripts/quant-wallpaper.sh" cycle &
