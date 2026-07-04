#!/usr/bin/zsh

usage() {
	echo
	echo "Sets the wallpaper. On X11 also refreshes the betterlockscreen cache;"
	echo "on Hyprland reloads it into hyprpaper. hyprlock reads the image path"
	echo "directly, so no lock-screen cache step is needed under Wayland."
	echo "Usage: update_wallpaper <PATH_TO_WALLPAPER>"
    echo
    echo "Depends on lock_wrapper.zsh"
	echo
	exit 1
}

WP_PATH=$([ "$1" = "" ] && echo "" || realpath $1)

[[ $WP_PATH = "" ]] && usage

source "${0:a:h}/lock_wrapper.zsh"

LOG_ID="WallpaperUpdateScript"

update_wallpaper() {
    local WP_UPDATE_CMD

    # Session detection. XDG_CURRENT_DESKTOP is the reliable signal when this
    # is invoked by satpaper.service: it is set by uwsm before Hyprland starts
    # and is in the service's PassEnvironment list, so it is always present.
    # WAYLAND_DISPLAY / XDG_SESSION_TYPE are NOT reliably propagated to user
    # units (PassEnvironment captures them at service start, which can race
    # the compositor's import-environment), so they are only secondary checks
    # useful for manual invocations.
    if [[ "$XDG_CURRENT_DESKTOP" == "Hyprland" || -n "$WAYLAND_DISPLAY" || "$XDG_SESSION_TYPE" == "wayland" ]]; then
        # Hyprland session: reload the image into hyprpaper via IPC. hyprpaper
        # caches textures at load time, so satpaper overwriting the file on
        # disk is not enough on its own — this `wallpaper` request re-reads it.
        # Empty monitor (leading comma) applies to all outputs; hyprlock reads
        # the same path directly from its config, so no cache step is needed.
        # Guarded on pidof so a missing hyprpaper doesn't spam errors (e.g. if
        # satpaper fires before the compositor's autostart completes).
        WP_UPDATE_CMD="pidof hyprpaper >/dev/null && hyprctl hyprpaper wallpaper \",$WP_PATH,cover\""
        logger -t $LOG_ID "Session: wayland"
        logger -t $LOG_ID "Wayland Display, $WAYLAND_DISPLAY"
    else
        # i3/X11 session: refresh the betterlockscreen cache and set the wallpaper.
        WP_UPDATE_CMD="betterlockscreen -u $WP_PATH --fx dim; feh --bg-fill $WP_PATH"
        logger -t $LOG_ID "Session: x11"
        logger -t $LOG_ID "Display, $DISPLAY"
        logger -t $LOG_ID "Xauthority, $XAUTHORITY"
    fi

    # We divert all of the output to syslog.
    bash -c "$WP_UPDATE_CMD" 2>&1 | logger -t $LOG_ID 
}

run_with_lock "$HOME/tmp/wallpaper_update.pid" $LOG_ID update_wallpaper
