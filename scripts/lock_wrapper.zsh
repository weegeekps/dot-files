#!/usr/bin/zsh

run_with_lock() {
    local PIDFILE="$1"
    local LOG_ID="$2"
    shift 2

    if [[ -z "$PIDFILE" || -z "$1" ]]; then
        logger -t $LOG_ID "PIDFILE path and command must be provided"
        return 2
    fi

    if [[ -f "$PIDFILE" ]]; then
        local OLD_PID=$(cat "$PIDFILE")
        if kill -0 "$OLD_PID" 2>/dev/null; then
            logger -t $LOG_ID "Another instance $OLD_PID is using $PIDFILE"
            return 1
        fi
    fi

    echo "$$" > "$PIDFILE"

    {
        "$@" # Runs the passed function
    } always {
        if [[ -f "$PIDFILE" && $(cat "$PIDFILE") -eq $$ ]]; then
            rm -f "$PIDFILE"
        fi
    }
}
