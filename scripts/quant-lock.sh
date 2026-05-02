#!/bin/bash
# Quant BSPWM - Lock Screen (i3lock-color)

BLANK='#00000000'
BG='#16141fcc'
FG='#e0def4'
PINK='#f5c2e7'
LAVENDER='#c4a7e7'
MAUVE='#cba6f7'
ROSE='#f38ba8'
TEAL='#94e2d5'
MIST='#2a2837'

# Pause notifications
dunstctl set-paused true

i3lock \
    --nofork \
    --color="$BG" \
    --blur=12 \
    --clock \
    --indicator \
    --time-str="%H:%M" \
    --date-str="%A, %d %B %Y" \
    --time-color="$PINK" \
    --date-color="$LAVENDER" \
    --time-font="JetBrainsMono Nerd Font" \
    --date-font="JetBrainsMono Nerd Font" \
    --time-size=64 \
    --date-size=18 \
    --layout-font="JetBrainsMono Nerd Font" \
    --verif-font="JetBrainsMono Nerd Font" \
    --wrong-font="JetBrainsMono Nerd Font" \
    --greeter-font="JetBrainsMono Nerd Font" \
    --inside-color="$BLANK" \
    --ring-color="$MIST" \
    --insidever-color="$BLANK" \
    --ringver-color="$TEAL" \
    --insidewrong-color="$BLANK" \
    --ringwrong-color="$ROSE" \
    --line-color="$BLANK" \
    --keyhl-color="$PINK" \
    --bshl-color="$ROSE" \
    --separator-color="$BLANK" \
    --verif-color="$TEAL" \
    --wrong-color="$ROSE" \
    --modif-color="$LAVENDER" \
    --layout-color="$FG" \
    --greeter-text="Quant BSPWM" \
    --greeter-color="$MAUVE" \
    --greeter-size=14 \
    --verif-text="Verifying..." \
    --wrong-text="Wrong!" \
    --noinput-text="Empty" \
    --lock-text="Locking..." \
    --lockfailed-text="Lock Failed" \
    --radius=120 \
    --ring-width=6 \
    --pass-media-keys \
    --pass-screen-keys \
    --pass-volume-keys \
    --indicator

# Resume notifications
dunstctl set-paused false
