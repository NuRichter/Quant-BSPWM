#!/bin/bash
# Quant BSPWM - Scratchpad Manager

TERMINAL="kitty"

toggle_scratchpad() {
    local class="$1"
    local cmd="$2"

    if xdotool search --class "$class" > /dev/null 2>&1; then
        local wid
        wid=$(xdotool search --class "$class" | head -n1)
        if [[ $(bspc query -N -n .hidden | grep "$wid") ]]; then
            bspc node "$wid" --flag hidden=off
            bspc node -f "$wid"
        else
            bspc node "$wid" --flag hidden=on
        fi
    else
        eval "$cmd" &
        sleep 0.5
        local wid
        wid=$(xdotool search --class "$class" | head -n1)
        if [[ -n "$wid" ]]; then
            bspc node "$wid" --flag sticky=on
            bspc node "$wid" -t floating
            # Center and resize: 70% width, 65% height
            local mon_w mon_h
            eval "$(xdotool getdisplaygeometry | awk '{print "mon_w="$1, "mon_h="$2}')"
            local w=$(( mon_w * 70 / 100 ))
            local h=$(( mon_h * 65 / 100 ))
            local x=$(( (mon_w - w) / 2 ))
            local y=$(( (mon_h - h) / 2 ))
            xdotool windowsize "$wid" "$w" "$h"
            xdotool windowmove "$wid" "$x" "$y"
        fi
    fi
}

case "${1:-terminal}" in
    terminal)
        toggle_scratchpad "quant-scratch-term" \
            "$TERMINAL --class quant-scratch-term -T 'Quant Scratchpad'"
        ;;
    music)
        toggle_scratchpad "quant-scratch-music" \
            "$TERMINAL --class quant-scratch-music -T 'Music' -e ncmpcpp"
        ;;
    monitor)
        toggle_scratchpad "quant-scratch-monitor" \
            "$TERMINAL --class quant-scratch-monitor -T 'System Monitor' -e btop"
        ;;
    python)
        toggle_scratchpad "quant-scratch-python" \
            "$TERMINAL --class quant-scratch-python -T 'Python REPL' -e python3"
        ;;
    *)
        echo "Usage: $0 {terminal|music|monitor|python}"
        exit 1
        ;;
esac
