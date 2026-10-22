#!/usr/bin/env zsh

isup() {
    local deadline=30 # in seconds
    local packet_rate=1 # in seconds
    local successful_packets=1

    if [[ "$OSTYPE" == darwin* || "$OSTYPE" == *bsd* ]]; then
        ping -c $successful_packets -W $(( packet_rate * 1000 )) -t $deadline "$@"
    elif [[ "$OSTYPE" == linux* ]]; then
        ping -c $successful_packets -W $packet_rate -w $deadline "$@"
    else
        echo "isup(): Unsupported OS."
        exit 1
    fi
}
