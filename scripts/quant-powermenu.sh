#!/bin/bash
# Quant BSPWM - Power Menu

options="  Lock\n  Logout\n  Suspend\n  Reboot\n  Shutdown"

chosen=$(echo -e "$options" | rofi -dmenu \
    -p "Power" \
    -mesg "  Quant BSPWM  |  $(date '+%A, %d %B %Y')" \
    -theme "$HOME/.config/rofi/themes/quant-powermenu.rasi")

case "$chosen" in
    *Lock)
        "$HOME/scripts/quant-lock.sh"
        ;;
    *Logout)
        bspc quit
        ;;
    *Suspend)
        "$HOME/scripts/quant-lock.sh" && systemctl suspend
        ;;
    *Reboot)
        systemctl reboot
        ;;
    *Shutdown)
        systemctl poweroff
        ;;
esac
