#!/bin/bash

usage() {
	echo
	echo "Updates betterlockscreen cache and then sets wallpaper."
	echo "Usage: update_wallpaper <PATH_TO_WALLPAPER>"
	echo
	exit 1
}

WP_PATH=$([ "$1" = "" ] && echo "" || realpath $1)

# Shows usage if path is missing or invalid.
[[ $WP_PATH = "" ]] && usage

# First updates the cache, and then if successful, updates the wallpaper.
WP_UPDATE_CMD="betterlockscreen -u $WP_PATH --fx dim && betterlockscreen -w"

bash -c "$WP_UPDATE_CMD"

