#!/bin/bash
# Quant BSPWM - IME Status for Polybar

if ! command -v fcitx5-remote &>/dev/null; then
    echo "N/A"
    exit 0
fi

CURRENT=$(fcitx5-remote -n 2>/dev/null)

case "$CURRENT" in
    keyboard-us*) echo "EN" ;;
    mozc)         echo "JP" ;;
    *)            echo "EN" ;;
esac
