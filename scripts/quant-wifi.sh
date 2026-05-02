#!/bin/bash
# Quant BSPWM - WiFi Manager (Rofi + nmcli)

THEME="$HOME/.config/rofi/themes/quant-launcher.rasi"

notify() {
    notify-send -a "WiFi" -i network-wireless "$1" "$2" -t 3000
}

get_wifi_status() {
    nmcli radio wifi
}

toggle_wifi() {
    local status
    status=$(get_wifi_status)
    if [[ "$status" == "enabled" ]]; then
        nmcli radio wifi off
        notify "WiFi Disabled" "Wireless radio turned off"
    else
        nmcli radio wifi on
        notify "WiFi Enabled" "Scanning for networks..."
    fi
}

get_networks() {
    nmcli -t -f SSID,SIGNAL,SECURITY,IN-USE device wifi list --rescan yes 2>/dev/null | \
        awk -F: '
            $1 != "" {
                icon = ($4 == "*") ? "" : ""
                lock = ($3 != "" && $3 != "--") ? " " : ""
                signal = $2
                if (signal >= 75) bar = "  "
                else if (signal >= 50) bar = "  "
                else if (signal >= 25) bar = "  "
                else bar = "  "
                printf "%s %s %s%s %s%%\n", icon, $1, lock, bar, signal
            }
        ' | sort -t'%' -k1 -rn | uniq
}

connect_wifi() {
    local ssid="$1"

    # Check if already saved
    if nmcli -t -f NAME connection show | grep -qx "$ssid"; then
        nmcli connection up "$ssid" 2>/dev/null
        if [[ $? -eq 0 ]]; then
            notify "Connected" "$ssid"
        else
            notify "Connection Failed" "$ssid"
        fi
        return
    fi

    # Check if network needs password
    local security
    security=$(nmcli -t -f SSID,SECURITY device wifi list | grep "^${ssid}:" | head -1 | cut -d: -f2)

    if [[ -n "$security" && "$security" != "--" ]]; then
        local pass
        pass=$(rofi -dmenu -p "Password for $ssid" -password -theme "$THEME" 2>/dev/null)
        if [[ -n "$pass" ]]; then
            nmcli device wifi connect "$ssid" password "$pass" 2>/dev/null
            if [[ $? -eq 0 ]]; then
                notify "Connected" "$ssid"
            else
                notify "Connection Failed" "Wrong password or error"
            fi
        fi
    else
        nmcli device wifi connect "$ssid" 2>/dev/null
        if [[ $? -eq 0 ]]; then
            notify "Connected" "$ssid"
        else
            notify "Connection Failed" "$ssid"
        fi
    fi
}

# Main menu
main() {
    local status
    status=$(get_wifi_status)

    local toggle_label
    if [[ "$status" == "enabled" ]]; then
        toggle_label="  Disable WiFi"
    else
        toggle_label="  Enable WiFi"
    fi

    local options="$toggle_label\n  Rescan"

    if [[ "$status" == "enabled" ]]; then
        local networks
        networks=$(get_networks)
        if [[ -n "$networks" ]]; then
            options="$options\n$networks"
        fi
    fi

    local chosen
    chosen=$(echo -e "$options" | rofi -dmenu -p "  WiFi" -theme "$THEME" 2>/dev/null)

    case "$chosen" in
        *"Disable WiFi"*|*"Enable WiFi"*)
            toggle_wifi
            ;;
        *"Rescan"*)
            notify "WiFi" "Rescanning networks..."
            sleep 1
            main
            ;;
        "")
            exit 0
            ;;
        *)
            local ssid
            ssid=$(echo "$chosen" | sed 's/^[^ ]* //' | sed 's/ [  ].*$//' | sed 's/ $//' | xargs)
            connect_wifi "$ssid"
            ;;
    esac
}

main
