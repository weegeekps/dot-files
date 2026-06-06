#!/usr/bin/zsh

# This runs when betterlockscreen is unlocked. This script is necessary
# since the wallpaper doesn't get updated when suspended or locked.

# Path to the latest satpaper
WP_PATH="$HOME/tmp/satpaper/satpaper_latest.png"

# Bail if the satpaper is invalid
[[ ! -e "$WP_PATH" ]] && exit 1

source "${0:a:h}/lock_wrapper.zsh"

LOG_ID="BetterlockscreenPostScript"

post_script() {
    # Updates the wallpaper
    bash -c "feh --bg-scale $WP_PATH" 2>&1 | logger -t $LOG_ID

    # Syncs the betterlockscreen cache
    bash -c "betterlockscreen -u $WP_PATH --fx dim" 2>&1 | logger -t $LOG_ID
}

run_with_lock "$HOME/tmp/wallpaper_update.pid" $LOG_ID post_script
