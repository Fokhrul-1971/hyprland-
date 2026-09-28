#!/usr/bin/env bash

STATE_FILE="$HOME/.cache/waybar_timer_state"

[ -f "$STATE_FILE" ] || echo "0:0:0" > "$STATE_FILE"
IFS=':' read -r running elapsed start_epoch < "$STATE_FILE"

case "$1" in
    toggle)
        now=$(date +%s)
        if [ "$running" -eq 1 ]; then
            new_elapsed=$((elapsed + now - start_epoch))
            echo "0:$new_elapsed:0" > "$STATE_FILE"
        else
            echo "1:$elapsed:$now" > "$STATE_FILE"
        fi
        ;;
    reset)
        echo "0:0:0" > "$STATE_FILE"
        ;;
    status)
        now=$(date +%s)
        if [ "$running" -eq 1 ]; then
            total=$((elapsed + now - start_epoch))
            class="running"
            icon=""
        else
            total=$elapsed
            [ "$total" -eq 0 ] && class="stopped" || class="paused"
            icon=""
        fi
        h=$((total/3600)); m=$(((total%3600)/60)); s=$((total%60))
        text=$(printf "%02d:%02d:%02d" "$h" "$m" "$s")
        printf '{"text":"%s %s","class":"%s","tooltip":"Click: start/pause | Right-click: reset"}\n' "$icon" "$text" "$class"
        ;;
esac