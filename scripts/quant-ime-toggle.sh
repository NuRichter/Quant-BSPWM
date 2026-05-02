#!/bin/bash
# Quant BSPWM - Input Method Toggle (fcitx5)
# Cycles: English -> Indonesian -> Japanese (Mozc) -> English

if ! command -v fcitx5-remote &>/dev/null; then
    notify-send -a "IME" -u critical "fcitx5 not found" \
        "Install: pacman -S fcitx5 fcitx5-mozc fcitx5-gtk fcitx5-qt fcitx5-configtool"
    exit 1
fi

CURRENT=$(fcitx5-remote -n 2>/dev/null)

case "$CURRENT" in
    keyboard-us|keyboard-us-*)
        fcitx5-remote -s mozc
        notify-send -a "IME" -t 1500 "Input Method" "日本語 (Mozc)" 
        ;;
    mozc)
        fcitx5-remote -s keyboard-us
        notify-send -a "IME" -t 1500 "Input Method" "English (US)"
        ;;
    *)
        fcitx5-remote -s keyboard-us
        notify-send -a "IME" -t 1500 "Input Method" "English (US)"
        ;;
esac
