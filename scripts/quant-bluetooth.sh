#!/bin/bash
# Quant BSPWM - Bluetooth Manager

THEME="$HOME/.config/rofi/themes/quant-launcher.rasi"

notify() {
    notify-send -a "Bluetooth" -i bluetooth "$1" "$2" -t 3000
}

bt_status() {
    bluetoothctl show | grep -q "Powered: yes" && echo "on" || echo "off"
}

bt_toggle() {
    local status
    status=$(bt_status)
    if [[ "$status" == "on" ]]; then
        bluetoothctl power off > /dev/null 2>&1
        notify "Bluetooth Off" "Radio disabled"
    else
        bluetoothctl power on > /dev/null 2>&1
        notify "Bluetooth On" "Scanning..."
    fi
}

get_paired_devices() {
    bluetoothctl devices Paired 2>/dev/null | while read -r _ mac name; do
        local connected=""
        if bluetoothctl info "$mac" 2>/dev/null | grep -q "Connected: yes"; then
            connected=" [connected]"
        fi
        echo "$name ($mac)$connected"
    done
}

scan_devices() {
    notify "Bluetooth" "Scanning for 5 seconds..."
    bluetoothctl --timeout 5 scan on > /dev/null 2>&1

    bluetoothctl devices 2>/dev/null | while read -r _ mac name; do
        local paired=""
        if bluetoothctl devices Paired 2>/dev/null | grep -q "$mac"; then
            paired=" [paired]"
        fi
        echo "$name ($mac)$paired"
    done
}

extract_mac() {
    echo "$1" | grep -oP '\(([0-9A-F:]+)\)' | tr -d '()'
}

main() {
    local status
    status=$(bt_status)

    local toggle_label
    [[ "$status" == "on" ]] && toggle_label="  Disable Bluetooth" || toggle_label="  Enable Bluetooth"

    local options="$toggle_label"

    if [[ "$status" == "on" ]]; then
        options="$options\n  Scan for devices"

        local paired
        paired=$(get_paired_devices)
        if [[ -n "$paired" ]]; then
            options="$options\n$paired"
        fi
    fi

    local chosen
    chosen=$(echo -e "$options" | rofi -dmenu -p "  Bluetooth" -theme "$THEME" 2>/dev/null)

    case "$chosen" in
        *"Disable Bluetooth"*|*"Enable Bluetooth"*)
            bt_toggle
            ;;
        *"Scan for devices"*)
            local devices
            devices=$(scan_devices)
            if [[ -n "$devices" ]]; then
                local selected
                selected=$(echo -e "$devices" | rofi -dmenu -p "  Connect" -theme "$THEME" 2>/dev/null)
                if [[ -n "$selected" ]]; then
                    local mac
                    mac=$(extract_mac "$selected")
                    if [[ -n "$mac" ]]; then
                        bluetoothctl pair "$mac" > /dev/null 2>&1
                        bluetoothctl trust "$mac" > /dev/null 2>&1
                        bluetoothctl connect "$mac" > /dev/null 2>&1
                        if [[ $? -eq 0 ]]; then
                            notify "Connected" "$selected"
                        else
                            notify "Failed" "Could not connect to $selected"
                        fi
                    fi
                fi
            else
                notify "Bluetooth" "No devices found"
            fi
            ;;
        "")
            exit 0
            ;;
        *)
            local mac
            mac=$(extract_mac "$chosen")
            if [[ -n "$mac" ]]; then
                if echo "$chosen" | grep -q "\[connected\]"; then
                    bluetoothctl disconnect "$mac" > /dev/null 2>&1
                    notify "Disconnected" "$chosen"
                else
                    bluetoothctl connect "$mac" > /dev/null 2>&1
                    if [[ $? -eq 0 ]]; then
                        notify "Connected" "$chosen"
                    else
                        notify "Failed" "Could not connect"
                    fi
                fi
            fi
            ;;
    esac
}

main
