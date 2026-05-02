#!/bin/sh
# Quant BSPWM - xinitrc

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# Input method
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus

# Java fix for BSPWM
export _JAVA_AWT_WM_NONREPARENTING=1
export AWT_TOOLKIT=MToolkit

# Cursor
xsetroot -cursor_name left_ptr

# Keyboard rate
xset r rate 300 50

# DPMS (Display Power Management)
xset s 600 5
xset dpms 600 900 1200

# Starship prompt
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

exec bspwm
