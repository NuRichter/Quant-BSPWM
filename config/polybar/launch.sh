#!/bin/bash
# Quant BSPWM - Polybar Launcher

# Terminate already running instances
killall -q polybar

# Wait until processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.2; done

# Get connected monitors
MONITORS=$(xrandr --query | grep " connected" | cut -d' ' -f1)

PRIMARY=$(xrandr --query | grep " connected primary" | cut -d' ' -f1)

for mon in $MONITORS; do
    if [[ "$mon" == "$PRIMARY" ]]; then
        MONITOR=$mon polybar --reload quant-primary -c "$HOME/.config/polybar/config.ini" &
    else
        MONITOR=$mon polybar --reload quant-secondary -c "$HOME/.config/polybar/config.ini" &
    fi
done

echo "[Quant] Polybar launched on: $MONITORS"
