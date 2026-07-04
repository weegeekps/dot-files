# EndeavourOS Hyprland

This is my Hyprland (Wayland) environment. It uses the same toolchain as my i3 (X11) setup — rofi, dunst, fcitx5, satpaper — with Wayland-native replacements for the X11-specific parts: Hyprland (compositor), waybar (bar), hyprlock/hypridle (lock/idle), and hyprpaper (wallpaper). i3 remains installed as an X11 fallback; LightDM selects whichever session you pick at the greeter.

### Core Configuration

Install dependencies.

From `pacman`:

```zsh
pacman -Sy alacritty blueman dolphin dunst fcitx5-im hypridle hyprland hyprpaper hyprpolkitagent hyprshot network-manager-applet nerd-fonts pavucontrol rofi ttf-fira-code uwsm waybar which-key-wayland
```

From AUR:

```zsh
yay -Sy hyprland-plugin-hy3 pamac-tray-plasma rofi-power-menu
```

`hyprland-plugin-hy3` must match the installed `hyprland` version exactly (the AUR package tracks Hyprland releases). Do not use `hyprpm` to manage hy3 on 0.55+ — it clobbers the system `hyprland.pc`.

Configure:

 - Blueman: https://wiki.archlinux.org/title/Blueman
 - Fcitx5: https://wiki.archlinux.org/title/Fcitx5
 - NetworkManager: https://wiki.archlinux.org/title/NetworkManager
 - Polkit: https://wiki.archlinux.org/title/Polkit

LightDM launches the session via the `uwsm` wrapper (`hyprland-uwsm.desktop`). `uwsm` sources `~/.config/uwsm/env` as a shell script and exports the resulting environment to Hyprland's process. This file is **per-host** and holds the monitor rules; the config files themselves stay identical across machines. Vars *must* be `export`-ed — non-exported shell vars are dropped from the delta and never reach Hyprland.

Create `~/.config/uwsm/env` (override the descriptions/modes/positions per machine):

```sh
export HYPRLAND_PRIMARY_MONITOR="desc:Maker Model Serial, 3840x2160@143.96, 2560x0, 1.2"
export HYPRLAND_SECONDARY_MONITOR="desc:Maker Model Serial, 2560x1440@180.00, 0x0, 1"
```

The config reads these with `os.getenv` and parses each into a monitor rule. Use `desc:` (make/model/serial) rather than connector names (`DP-1`) so the layout survives recabling. If a var is unset, the config falls back to Hyprland auto-detection — graceful, never breaks the session. Monitor changes here require a re-login: Hyprland's process environment is fixed at exec time, so `hyprctl reload` will not pick up new values.

### Configure satpaper, hyprpaper & hyprlock

The wallpaper and lock screen use [satpaper](https://github.com/Colonial-Dev/satpaper), which writes a near-real-time satellite image to `~/tmp/satpaper/satpaper_latest.png`. hyprpaper displays that image on all outputs; hyprlock uses it (blurred and dimmed) as the lock background.

Create `~/.config/systemd/user/satpaper.service`. Its targets include `graphical-session.target`, so the same unit runs under both X11 and Wayland:

```sh
[Unit]
Description=Run Satpaper on login.
After=x11-ready.target graphical-session.target
PartOf=x11-ready.target graphical-session.target

[Service]
Environment=SATPAPER_SATELLITE=goes-east
Environment=SATPAPER_RESOLUTION_X=3840
Environment=SATPAPER_RESOLUTION_Y=2160
Environment=SATPAPER_DISK_SIZE=94
Environment=SATPAPER_TARGET_PATH=%h/tmp/satpaper/
Environment=SATPAPER_WALLPAPER_COMMAND="%h/scripts/update_wallpaper.sh"
PassEnvironment=XDG_CURRENT_DESKTOP DISPLAY XAUTHORITY WAYLAND_DISPLAY
ExecStart=%h/.cargo/bin/satpaper
Restart=on-failure
RestartSec=5

[Install]
WantedBy=x11-ready.target graphical-session.target
```

Enable it with `systemctl --user enable satpaper`.

`SATPAPER_WALLPAPER_COMMAND` points at [scripts/update_wallpaper.sh](/scripts/update_wallpaper.sh), which satpaper calls each time it writes a new image. The script branches on the session: on Hyprland it reloads the image into hyprpaper via `hyprctl hyprpaper wallpaper` (hyprpaper caches textures at load time, so the on-disk overwrite alone is not enough); on X11 it refreshes the betterlockscreen cache and sets the wallpaper with `feh`. Detection keys on `XDG_CURRENT_DESKTOP=Hyprland` rather than `WAYLAND_DISPLAY`, because `PassEnvironment` captures env vars at service start and can race the compositor's `import-environment` — `XDG_CURRENT_DESKTOP` is set by uwsm before Hyprland starts, so it is always present. To reload the wallpaper manually:

```sh
hyprctl hyprpaper wallpaper ',/home/USER/tmp/satpaper/satpaper_latest.png,cover'
```

Copy over the Hyprland configuration from `dot-files`:

 - `.config/hypr/hyprland.lua` — compositor config. Loads `hy3`, sets the Nord theme, and defines all keybindings.
 - `.config/hypr/hypridle.conf` — idle/lock daemon. Locks after 5 min, blanks displays after 10 min, locks before suspend.
 - `.config/hypr/hyprlock.conf` — Wayland lock screen, Nord-themed, `satpaper` background blurred and dimmed.
 - `.config/hypr/hyprpaper.conf` — wallpaper daemon. Displays `~/tmp/satpaper/satpaper_latest.png` on all outputs. (hyprpaper 0.8+ uses a `wallpaper { }` block; the old `preload =`/`wallpaper =` syntax was removed.)
 - `.config/hypr/scripts/move-window.sh` — edge-aware window move (hy3 within-workspace move, cross-monitor fallback at the workspace edge).

`hyprlock` is invoked by `hypridle` via `lock_cmd = pidof hyprlock || hyprlock`. `rofi-power-menu`'s `lockscreen` choice calls `loginctl lock-session`, which `hypridle` catches and routes to `hyprlock`.

### Copy bar, notifications and portal configuration

Copy over from `dot-files`:

 - `.config/waybar/config.jsonc` and `.config/waybar/style.css` — Nord-themed bar mirroring the xfce4-panel layout (Arch logo, taskbar, workspaces, pulseaudio, tray, clock, power menu). Height 35px, 3px rounding, font-size 15px.
 - `.config/waybar/scripts/distro-logo.sh` — picks a Nerd Font glyph from `/etc/os-release`.
 - `.config/dunst/dunstrc` — Nord-themed notifications, top-right origin.
 - `.config/which-key-wayland/config.kdl` — keybind cheatsheet daemon.
 - `.config/xdg-desktop-portal/hyprland-portals.conf` — portal routing.

The waybar `output` field is **per-host**: it pins the bar to the primary monitor by description identifier (`"Maker Model Serial"` — the monitor description minus the ` (name)` suffix), not connector name. `waybar` has no fail-soft fallback for a non-matching description, so override it per machine. The dunst `monitor` field is also **per-host**: it takes a connector name (`DP-1`), not a description — dunst has no description support. Both are the only per-host values in those files.

## Monitor Configuration

Hyprland handles monitors itself; there is no `xrandr` step and no `monitor_setup.sh`. The layout is defined entirely by the `HYPRLAND_*_MONITOR` env vars in `~/.config/uwsm/env` (see above).

Connector names are 1-indexed under Wayland (`DP-1`, `DP-4`) versus 0-indexed under X11 (`DP-0`, `DP-3`). This only matters for the per-host fields that still use connector names (dunst `monitor`, and any `hyprctl` calls in scripts that reference monitors by name) — the `desc:` rules and the `waybar` description identifier are unaffected.

To inspect the connected outputs and their descriptions:

```sh
hyprctl monitors
```

Scale is set per-monitor in the env-var rule (e.g. `1.2` for a 4K panel). Unlike X11, Hyprland applies fractional scaling natively; alacritty needs a per-machine `font.size` override to compensate (see [terminal.md](./terminal.md)), since its config is shared across machines.
