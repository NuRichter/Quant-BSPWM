#!/bin/bash
# Quant BSPWM - Gap Manager

CURRENT=$(bspc config window_gap)

case "${1:-toggle}" in
    increase)
        bspc config window_gap $((CURRENT + 2))
        notify-send -a "Gaps" "Window Gap" "$(bspc config window_gap)px" -t 1000
        ;;
    decrease)
        local new=$((CURRENT - 2))
        [[ $new -lt 0 ]] && new=0
        bspc config window_gap $new
        notify-send -a "Gaps" "Window Gap" "${new}px" -t 1000
        ;;
    toggle)
        if [[ $CURRENT -eq 0 ]]; then
            bspc config window_gap 10
            bspc config border_width 2
            notify-send -a "Gaps" "Gaps On" "10px" -t 1000
        else
            bspc config window_gap 0
            bspc config border_width 0
            notify-send -a "Gaps" "Gaps Off" "Gapless mode" -t 1000
        fi
        ;;
    set)
        bspc config window_gap "${2:-10}"
        notify-send -a "Gaps" "Window Gap" "${2:-10}px" -t 1000
        ;;
    *)
        echo "Usage: $0 {increase|decrease|toggle|set [px]}"
        exit 1
        ;;
esac
