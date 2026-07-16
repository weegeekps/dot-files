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

 - `.config/hypr/hyprland.lua` — compositor config. Loads `hy3`, sets the Nord theme, wires up monitors/env/animations/autostart, and loads keybindings + window rules from sibling files rather than defining them inline.
 - `.config/hypr/keybindings.lua` — all keybinds (vim-style focus, hy3 dispatchers, resize submap, media keys). Loaded by `hyprland.lua` via `loadfile`.
 - `.config/hypr/window_rules/` — window rules directory. `hyprland.lua` globs `*.lua` from here in sorted order; prefix files with `NN_` to control precedence (rules evaluate top-to-bottom, last match wins).
 - `.config/hypr/hypridle.conf` — idle/lock daemon. Locks after 5 min, blanks displays after 10 min, locks before suspend.
 - `.config/hypr/hyprlock.conf` — Wayland lock screen, Nord-themed, `satpaper` background blurred and dimmed.
 - `.config/hypr/hyprpaper.conf` — wallpaper daemon. Displays `~/tmp/satpaper/satpaper_latest.png` on all outputs. (hyprpaper 0.8+ uses a `wallpaper { }` block; the old `preload =`/`wallpaper =` syntax was removed.)
 - `.config/hypr/scripts/move-window.sh` — edge-aware window move (hy3 within-workspace move, cross-monitor fallback at the workspace edge).
 - `.config/hypr/scripts/kvm-recover.sh` — `dpms off → on` cycle that re-handshakes displays after a KVM switch. Invoked by the SUPER+B keybind and by the `monitor.added` handler in `hyprland.lua`.

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

### KVM / Monitor Recovery

**Symptom.** Switching a KVM (or a shared monitor's input) away from this machine and back leaves the displays black, even though `hyprctl monitors` still reports them active (`dpmsStatus: 1`, `disabled: false`). The screens only come back once the session has idled into `hyprlock` + DPMS-off, because that path performs a real `dpms off → on` cycle.

**Cause.** This KVM does not emulate the displays — the monitors genuinely disconnect and reconnect, and Hyprland fires `monitor.added`/`monitor.removed` for each (visible on socket2). But the modeset Hyprland performs on re-add alone does not wake the physical panel; only a `dpms off → on` cycle re-trains the link. The idle/lock path recovers the screens for exactly this reason — it runs that cycle on resume — so the fix runs the same cycle when a monitor reconnects. The kernel DRM `HOTPLUG=1` stream from `udevadm` is unusable as a trigger on this GPU: it fires continuously, not just on a switch. Hyprland's own `monitor.added` event is the clean, discrete signal, so the handler keys on that. (A related bug was also fixed in `hypridle.conf`: the DPMS commands used `hl.dsp.dpms("off")`, which is not a valid action and behaved like a toggle — they now use the wiki-documented `hl.dsp.dpms({ action = "disable" })` / `"enable"` form.)

**Fix.** `hyprland.lua` registers an `hl.on("monitor.added", ...)` handler that runs `.config/hypr/scripts/kvm-recover.sh` (a `dpms off → on` cycle) whenever a real monitor reconnects. It skips `FALLBACK` (the virtual output Hyprland creates while all real monitors are gone) and the startup burst, so it only fires on genuine reconnects. **SUPER+B** (`keybindings.lua`) is the manual fallback — press it once after switching back if the screens stay black.

**Setup.** Copy the new file over and reload:

```sh
cp .config/hypr/scripts/kvm-recover.sh ~/.config/hypr/scripts/
chmod +x ~/.config/hypr/scripts/kvm-recover.sh
hyprctl reload                 # load the monitor.added handler + SUPER+B keybind
killall hypridle; hypridle &   # apply the hypridle.conf DPMS-syntax fix
```

**Verify.** Watch Hyprland's own monitor events while switching the KVM — these are what the handler keys on:

```sh
socat - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | grep --line-buffered '^monitor'
```

A reconnect produces `monitorremoved>>DP-1` … `monitoradded>>FALLBACK` … `monitoradded>>DP-1` (and likewise for the other monitors); the handler fires on each non-`FALLBACK` `monitoradded`.

**Tuning.** `kvm-recover.sh` honors `KVM_RECOVER_OFF_HOLD` (seconds to hold DPMS off before re-enabling, default 1). If the black flash is too long, lower it; if a monitor doesn't wake, raise it.

**Escalation:** if a `dpms off → on` cycle alone does not wake a particular monitor (some GPU/monitor combos need a deeper refresh), the next step is a VT switch away and back. Add a narrow sudoers rule (run by hand — needs elevation):

```sh
sudo visudo -f /etc/sudoers.d/kvm-recover-chvt
# then add (replace <user>):
# <user> ALL=(root) NOPASSWD: /usr/bin/chvt
```

and have `kvm-recover.sh` call `sudo -n /usr/bin/chvt 2; sleep 1; sudo -n /usr/bin/chvt 1` (adjust VT numbers to your session — check with `loginctl show-session "$XDG_SESSION_ID" -p VTNr`). This is left out of the default script so the recovery stays privilege-free.
