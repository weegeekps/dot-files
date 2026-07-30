#!/bin/bash
# Requires jq and socat

SOCKET_PATH="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

echo "Streaming raw window rule attributes... Trigger the app window."

socat -u UNIX-CONNECT:"$SOCKET_PATH" - | while read -r line; do
    if [[ $line == "openwindow"* ]]; then
        echo -e "\n--- ATTR CAPTURE [$(date '+%T')] ---"
        
        # Parse live stream data
        payload=$(echo "$line" | awk -F'>>' '{print $2}')
        win_addr=$(echo "$payload" | awk -F',' '{print $1}')
        win_workspace=$(echo "$payload" | awk -F',' '{print $2}')
        win_class=$(echo "$payload" | awk -F',' '{print $3}' | tr -d '\r')
        win_title=$(echo "$payload" | awk -F',' '{for(i=4;i<=NF;i++) printf "%s%s", $i, (i==NF?"":",")}' | tr -d '\r')
        
        # Pull extra attributes from hyprctl state history
        extra_info=$(hyprctl clients -j | jq --arg addr "0x$win_addr" '.[] | select(.address == $addr)' 2>/dev/null)
        initial_title=$(echo "$extra_info" | jq -r '.initialTitle // empty')
        initial_class=$(echo "$extra_info" | jq -r '.initialClass // empty')
        is_floating=$(echo "$extra_info" | jq -r '.floating // empty')
        pid=$(echo "$extra_info" | jq -r '.pid // empty')

        # Output the exact raw values needed for rules
        echo "address:      0x$win_addr"
        echo "class:        $win_class"
        echo "title:        $win_title"
        [ -n "$initial_class" ] && echo "initialClass: $initial_class"
        [ -n "$initial_title" ] && echo "initialTitle: $initial_title"
        [ -n "$pid" ]           && echo "pid:          $pid"
        [ -n "$win_workspace" ] && echo "workspace:    $win_workspace"
        [ -n "$is_floating" ]   && echo "floating:     $is_floating"
        
        # List other existing windows for context
        echo "companions:"
        hyprctl clients -j | jq -r --arg class "$win_class" \
            '.[] | select(.class == $class) | "  - title: \(.title) | workspace: \(.workspace.name) | address: \(.address)"'
    fi
done
