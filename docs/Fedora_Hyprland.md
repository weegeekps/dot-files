# Fedora Hyprland

This is the Fedora port of my [EndeavourOS Hyprland](./Endeavour_OS_Hyprland.md) environment: the same Hyprland + waybar + rofi + dunst + hyprlock/hypridle/hyprpaper + satpaper stack, with `dnf` and COPR in place of `pacman`/AUR. The same dot-files apply unchanged; only the install paths differ. i3 remains available as an X11 fallback session.

Fedora's official `hyprland` package is far too old for this configuration (0.45.x in F42, absent entirely in F43/44), and Hyprland 0.55+ additionally requires a Lua 5.5 runtime that Fedora does not ship. You must install Hyprland from a COPR that tracks 0.55+ and vendors the Lua runtime.

### Core Configuration

Enable a Hyprland COPR and install the hypr* ecosystem from it. `nett00n/hyprland` is currently the most active and comprehensive (Fedora 43/44/rawhide, full ecosystem); `ashbuk/Hyprland-Fedora` is a vendored single-package alternative that pins 0.55.4 and bundles the Lua 5.5 Hyprland 0.55+ requires:

```zsh
sudo dnf copr enable nett00n/hyprland
sudo dnf install hyprland hypridle hyprlock hyprpaper hyprpolkitagent hyprshot uwsm
```

Install the rest from Fedora's own repos:

```zsh
sudo dnf install alacritty blueman dolphin dunst fcitx5 fcitx5-configtool fira-code-fonts nerd-fonts network-manager-applet pavucontrol rofi-wayland waybar
```

`waybar` 0.15.0 ships in Fedora 44, matching the config. `rofi-wayland` is Fedora's Wayland-capable rofi build; rofi 2.0+ (natively Wayland) is preferred if your Fedora carries it. Install the Rust toolchain for the cargo-installed tools below, plus the build deps `which-key-wayland` needs:

```zsh
sudo dnf install rust cargo libxkbcommon-devel pkgconf-pkg-config
```

Configure:

 - Blueman: https://wiki.archlinux.org/title/Blueman
 - Fcitx5: https://wiki.archlinux.org/title/Fcitx5
 - NetworkManager: https://wiki.archlinux.org/title/NetworkManager
 - Polkit: https://wiki.archlinux.org/title/Polkit

The session is launched via the `uwsm` wrapper (`hyprland-uwsm.desktop`). Fedora defaults to GDM, which has known quirks with Hyprland; LightDM is the cleaner choice and matches the EndeavourOS setup. `uwsm` sources `~/.config/uwsm/env` as a shell script and exports the resulting environment to Hyprland's process. This file is **per-host** and holds the monitor rules; the config files themselves stay identical across machines. Vars *must* be `export`-ed — non-exported shell vars are dropped from the delta and never reach Hyprland.

Create `~/.config/uwsm/env` (override the descriptions/modes/positions per machine):

```sh
export HYPRLAND_PRIMARY_MONITOR="desc:Maker Model Serial, 3840x2160@143.96, 2560x0, 1.2"
export HYPRLAND_SECONDARY_MONITOR="desc:Maker Model Serial, 2560x1440@180.00, 0x0, 1"
```

The config reads these with `os.getenv` and parses each into a monitor rule. Use `desc:` (make/model/serial) rather than connector names (`DP-1`) so the layout survives recabling. If a var is unset, the config falls back to Hyprland auto-detection — graceful, never breaks the session. Monitor changes here require a re-login: Hyprland's process environment is fixed at exec time, so `hyprctl reload` will not pick up new values.

### Install hy3, which-key-wayland & rofi-power-menu

These three are packaged for neither Fedora nor the COPR, so install them directly.

**hy3** (the tiling plugin) must match your installed Hyprland version exactly. Build it from source against the COPR's `hyprland-devel`:

```zsh
sudo dnf install hyprland-devel cmake gcc-c++
git clone --recursive https://github.com/outfoxxed/hy3.git && cd hy3
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
cmake --build build
sudo cmake --install build
```

The build installs `libhy3.so` into Hyprland's plugin directory; confirm the path (`pkg-config --variable=plugindir hyprland` or the install output) and ensure the `hl.plugin.load(...)` path in `hyprland.lua` matches. Do not use `hyprpm` to manage hy3 — it clobbers the system `hyprland.pc`.

**which-key-wayland** and **satpaper** install via cargo:

```zsh
cargo install which-key-wayland satpaper
```

`which-key-wayland` needs `libxkbcommon` and `wayland` at build and runtime (installed above); `satpaper` writes its image to `~/tmp/satpaper/`.

**rofi-power-menu** is a single script — vendor it onto your `PATH` from [its repo](https://github.com/jluttine/rofi-power-menu).

### Configure satpaper, hyprpaper & hyprlock

[satpaper](https://github.com/Colonial-Dev/satpaper) writes a near-real-time satellite image to `~/tmp/satpaper/satpaper_latest.png`. hyprpaper displays it on all outputs; hyprlock uses it (blurred and dimmed) as the lock background.

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

`SATPAPER_WALLPAPER_COMMAND` points at [scripts/update_wallpaper.sh](/scripts/update_wallpaper.sh), which satpaper calls each time it writes a new image. The script branches on the session: on Hyprland it reloads the image into hyprpaper via `hyprctl hyprpaper wallpaper` (hyprpaper caches textures at load time, so the on-disk overwrite alone is not enough); on X11 it refreshes the betterlockscreen cache and sets the wallpaper with `feh` (only relevant if you also keep an i3 session — betterlockscreen is not packaged for Fedora). Detection keys on `XDG_CURRENT_DESKTOP=Hyprland` rather than `WAYLAND_DISPLAY`, because `PassEnvironment` captures env vars at service start and can race the compositor's `import-environment` — `XDG_CURRENT_DESKTOP` is set by uwsm before Hyprland starts, so it is always present. To reload the wallpaper manually:

```sh
hyprctl hyprpaper wallpaper ',/home/USER/tmp/satpaper/satpaper_latest.png,cover'
```

Copy over the Hyprland configuration from `dot-files`:

 - `.config/hypr/hyprland.lua` — compositor config. Loads hy3, sets the Nord theme, wires up monitors/env/animations/autostart, and loads keybindings + window rules from sibling files rather than defining them inline.
 - `.config/hypr/keybindings.lua` — all keybinds (vim-style focus, hy3 dispatchers, resize submap, media keys). Loaded by `hyprland.lua` via `loadfile`.
 - `.config/hypr/window_rules/` — window rules directory. `hyprland.lua` globs `*.lua` from here in sorted order; prefix files with `NN_` to control precedence (rules evaluate top-to-bottom, last match wins).
 - `.config/hypr/hypridle.conf` — idle/lock daemon. Locks after 5 min, blanks displays after 10 min, locks before suspend.
 - `.config/hypr/hyprlock.conf` — Wayland lock screen, Nord-themed, satpaper background blurred and dimmed.
 - `.config/hypr/hyprpaper.conf` — wallpaper daemon. Displays `~/tmp/satpaper/satpaper_latest.png` on all outputs. (hyprpaper 0.8+ uses a `wallpaper { }` block; the old `preload =`/`wallpaper =` syntax was removed.)
 - `.config/hypr/scripts/move-window.sh` — edge-aware window move (hy3 within-workspace move, cross-monitor fallback at the workspace edge).

`hyprlock` is invoked by `hypridle` via `lock_cmd = pidof hyprlock || hyprlock`. `rofi-power-menu`'s `lockscreen` choice calls `loginctl lock-session`, which hypridle catches and routes to hyprlock.

### Copy bar, notifications and portal configuration

Copy over from `dot-files`:

 - `.config/waybar/config.jsonc` and `.config/waybar/style.css` — Nord-themed bar mirroring the xfce4-panel layout (Arch logo, taskbar, workspaces, pulseaudio, tray, clock, power menu). Height 35px, 3px rounding, font-size 15px.
 - `.config/waybar/scripts/distro-logo.sh` — picks a Nerd Font glyph from `/etc/os-release`.
 - `.config/dunst/dunstrc` — Nord-themed notifications, top-right origin.
 - `.config/which-key-wayland/config.kdl` — keybind cheatsheet daemon.
 - `.config/xdg-desktop-portal/hyprland-portals.conf` — portal routing. The `xdg-desktop-portal-hyprland` backend comes from the COPR.

The waybar `output` field is **per-host**: it pins the bar to the primary monitor by description identifier (`"Maker Model Serial"` — the monitor description minus the ` (name)` suffix), not connector name. waybar has no fail-soft fallback for a non-matching description, so override it per machine. The dunst `monitor` field is also **per-host**: it takes a connector name (`DP-1`), not a description — dunst has no description support. Both are the only per-host values in those files.

## Monitor Configuration

Hyprland handles monitors itself; there is no `xrandr` step. The layout is defined entirely by the `HYPRLAND_*_MONITOR` env vars in `~/.config/uwsm/env` (see above).

Connector names are 1-indexed under Wayland (`DP-1`, `DP-4`) versus 0-indexed under X11 (`DP-0`, `DP-3`). This only matters for the per-host fields that still use connector names (dunst `monitor`, and any `hyprctl` calls in scripts that reference monitors by name) — the `desc:` rules and the waybar description identifier are unaffected.

To inspect the connected outputs and their descriptions:

```sh
hyprctl monitors
```

Scale is set per-monitor in the env-var rule (e.g. `1.2` for a 4K panel). Unlike X11, Hyprland applies fractional scaling natively; alacritty needs a per-machine `font.size` override to compensate (see [terminal.md](./terminal.md)), since its config is shared across machines.
