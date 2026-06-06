#!/usr/bin/zsh

usage() {
	echo
	echo "Updates betterlockscreen cache and then sets wallpaper."
	echo "Usage: update_wallpaper <PATH_TO_WALLPAPER>"
    echo
    echo "Depends on lock_wrapper.zsh"
	echo
	exit 1
}

WP_PATH=$([ "$1" = "" ] && echo "" || realpath $1)

# Shows usage if path is missing or invalid.
[[ $WP_PATH = "" ]] && usage

source "${0:a:h}/lock_wrapper.zsh"

LOG_ID="WallpaperUpdateScript"

update_wallpaper() {
    # First updates the cache and updates the wallpaper.
    local WP_UPDATE_CMD="betterlockscreen -u $WP_PATH --fx dim; feh --bg-fill $WP_PATH"

    logger -t $LOG_ID "Display, $DISPLAY"
    logger -t $LOG_ID "Xauthority, $XAUTHORITY"

    # We divert all of the output to syslog.
    bash -c "$WP_UPDATE_CMD" 2>&1 | logger -t $LOG_ID 
}

run_with_lock "$HOME/tmp/wallpaper_update.pid" $LOG_ID update_wallpaper
