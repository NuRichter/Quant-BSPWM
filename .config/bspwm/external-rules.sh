#!/bin/bash
# Quant BSPWM - External Rules
# Dynamic window placement and sizing

wid=$1
class=$2
instance=$3
consequences=$4

get_geometry() {
    local mon_width mon_height
    mon_width=$(xdpyinfo | awk '/dimensions:/ {print $2}' | cut -d'x' -f1)
    mon_height=$(xdpyinfo | awk '/dimensions:/ {print $2}' | cut -d'x' -f2)
    echo "$mon_width $mon_height"
}

case "$class" in
    Spotify)
        echo "state=floating"
        echo "rectangle=1200x700+0+0"
        echo "center=on"
        ;;
    "Picture-in-Picture"|"picture in picture")
        echo "state=floating"
        echo "sticky=on"
        echo "layer=above"
        echo "rectangle=480x270+0+0"
        ;;
    Peek)
        echo "state=floating"
        echo "sticky=on"
        echo "rectangle=800x600+0+0"
        ;;
esac

# Fix for Java applications (JetBrains IDEs, etc.)
case "$instance" in
    sun-awt-X11-XDialogPeer)
        echo "state=floating"
        echo "center=on"
        ;;
    sun-awt-X11-XFramePeer)
        echo "state=tiled"
        ;;
esac
