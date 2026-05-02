#!/bin/bash
# Quant BSPWM - Polybar GPU Module (NVIDIA)

if ! command -v nvidia-smi &>/dev/null; then
    echo "N/A"
    exit 0
fi

INFO=$(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null)

if [[ -z "$INFO" ]]; then
    echo "N/A"
    exit 0
fi

GPU_UTIL=$(echo "$INFO" | cut -d',' -f1 | xargs)
GPU_TEMP=$(echo "$INFO" | cut -d',' -f2 | xargs)
MEM_USED=$(echo "$INFO" | cut -d',' -f3 | xargs)
MEM_TOTAL=$(echo "$INFO" | cut -d',' -f4 | xargs)

# Temperature-based color
if [[ $GPU_TEMP -ge 80 ]]; then
    TEMP_COLOR="%{F#f38ba8}"
elif [[ $GPU_TEMP -ge 65 ]]; then
    TEMP_COLOR="%{F#fab387}"
else
    TEMP_COLOR="%{F#a6e3a1}"
fi

echo "󰢮 ${GPU_UTIL}% ${TEMP_COLOR}${GPU_TEMP}C%{F-}"
