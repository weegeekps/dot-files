-- Hyprland configuration (Lua) — migrated from hyprland.conf per ~/hyprland_plan.md
-- Session launched via uwsm (hyprland-uwsm.desktop).
--
-- Shell stack: waybar (bar) + rofi (launcher/power-menu) + dunst
-- (notifications) + hyprlock (lock) + hyprpaper (wallpaper) + hypridle (idle).
-- Keeps the i3 toolchain intact; see hyprland_plan.md §4–§7.
--
-- NOTE: hyprland.lua fully replaces hyprland.conf (Hyprland 0.55+ Lua config).
-- hypridle/hyprlock/hyprpaper remain on hyprlang (only Hyprland itself supports Lua).

-- ─────────────────────────────────────────────────────────────────────────────
-- Monitors  (§12) — driven by environment variables for portability.
-- ─────────────────────────────────────────────────────────────────────────────
-- Each HYPRLAND_PRIMARY_MONITOR / HYPRLAND_SECONDARY_MONITOR env var (set in
-- ~/.config/uwsm/env) holds a full monitor rule string of the form:
--   desc:Make Model Serial, WxH@refresh, XxY, scale
-- We parse it into hl.monitor's structured fields. If the var is unset (e.g.
-- verify-config run outside the session, or a machine without the override),
-- we fall back to Hyprland's auto-detection (preferred mode, auto position,
-- scale 1) — graceful, never breaks the session.
local function monitor_from_env(varname)
    local s = os.getenv(varname)
    if not s or s == "" then
        hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
        return
    end
    -- Description contains no commas, so splitting on "," is safe.
    local output, mode, position, scale = s:match("^%s*(.-)%s*,%s*(.-)%s*,%s*(.-)%s*,%s*(.-)%s*$")
    if not output then
        hl.monitor({ output = s, mode = "preferred", position = "auto", scale = "auto" })
        return
    end
    hl.monitor({ output = output, mode = mode, position = position, scale = scale })
end
monitor_from_env("HYPRLAND_PRIMARY_MONITOR")
monitor_from_env("HYPRLAND_SECONDARY_MONITOR")

-- ─────────────────────────────────────────────────────────────────────────────
-- hy3 tiling plugin  (§9.4)
-- ─────────────────────────────────────────────────────────────────────────────
-- Must load BEFORE general.layout = "hy3" is applied. Loaded at top level so it
-- is registered during config parse (mirrors legacy `plugin =`). Idempotent on
-- reload (Hyprland's plugin loader no-ops an already-loaded path).
hl.plugin.load("/usr/lib/libhy3.so")

-- ─────────────────────────────────────────────────────────────────────────────
-- Environment  (§3.1, §8)
-- ─────────────────────────────────────────────────────────────────────────────
-- Only what the compositor itself must expose to children; IM modules / cursor
-- theme live in ~/.config/environment.d/*.conf (imported by uwsm automatically).
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("GDK_BACKEND", "wayland,x11")

-- ─────────────────────────────────────────────────────────────────────────────
-- General / layout / decoration / input  (§9.4 — hy3 is the tiling engine)
-- ─────────────────────────────────────────────────────────────────────────────
hl.config({
    general = {
        layout = "hy3",
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            -- Nord frost gradient: nord8 (#88c0d0) → nord10 (#5e81ac), 45deg
            active_border = { colors = { "rgba(88c0d0ee)", "rgba(5e81acee)" }, angle = 45 },
            inactive_border = "rgba(4c566aaa)", -- nord3 slate
        },
    },
    decoration = {
        rounding = 3,
        blur = { enabled = true, size = 3, passes = 1 },
        shadow = { enabled = true, range = 4, render_power = 3 },
    },
    input = {
        kb_layout = "us",
        kb_variant = "intl", -- US International with Dead Keys
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = { natural_scroll = false },
    },
    animations = {
        enabled = true,
    },
    xwayland = {
        force_zero_scaling = true,
    },
})

-- ─────────────────────────────────────────────────────────────────────────────
-- Animations  (custom bezier + per-leaf settings)
-- ─────────────────────────────────────────────────────────────────────────────
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

-- ─────────────────────────────────────────────────────────────────────────────
-- Keybindings  (§10) — i3 → Hyprland translation, $mod = SUPER
-- ─────────────────────────────────────────────────────────────────────────────
local HOME_DIR = os.getenv("HOME")
local mainMod = "SUPER"

-- hy3 plugin Lua API. hy3 exposes dispatcher factories under hl.plugin.hy3;
-- the returned functions are passed directly to hl.bind (per hy3 README,
-- "Lua dispatchers" section). Under the Lua config, `hyprctl dispatch`
-- routes through the Lua evaluator and breaks plugin dispatchers containing
-- colons (hy3:*), so the typed hl.plugin.hy3.* API is the only working path.
local hy3 = hl.plugin.hy3

-- Terminal / file manager  (Dolphin for the Hyprland session — §2.2/§8)
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd("dolphin"))

-- Screenshot  (xfce4-screenshooter -> hyprshot — §2.2)
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m output"))

-- Kill focused window  (hy3:killactive closes all windows in the focused node,
-- matching i3's kill-focused-container semantics — §10)
hl.bind(mainMod .. " + SHIFT + Q", hy3.kill_active())

-- Launcher  (rofi 2.0 — natively Wayland, same config as i3 — §5)
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd("rofi -modi drun,run -show drun"))

-- Focus movement  (vim-style j/k/l/; remap; hy3:movefocus for node-tree nav)
hl.bind(mainMod .. " + J", hy3.move_focus("l"))
hl.bind(mainMod .. " + K", hy3.move_focus("d"))
hl.bind(mainMod .. " + L", hy3.move_focus("u"))
hl.bind(mainMod .. " + semicolon", hy3.move_focus("r"))
hl.bind(mainMod .. " + left", hy3.move_focus("l"))
hl.bind(mainMod .. " + down", hy3.move_focus("d"))
hl.bind(mainMod .. " + up", hy3.move_focus("u"))
hl.bind(mainMod .. " + right", hy3.move_focus("r"))

-- Move window  (hy3:movewindow for node-tree nav; Mod+Shift+Left/Right use the
-- edge-aware script that falls back to a cross-monitor move at workspace edge)
hl.bind(mainMod .. " + SHIFT + J", hy3.move_window("l"))
hl.bind(mainMod .. " + SHIFT + K", hy3.move_window("d"))
hl.bind(mainMod .. " + SHIFT + L", hy3.move_window("u"))
hl.bind(mainMod .. " + SHIFT + semicolon", hy3.move_window("r"))
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.exec_cmd(HOME_DIR .. "/.config/hypr/scripts/move-window.sh l"))
hl.bind(mainMod .. " + SHIFT + down", hy3.move_window("d"))
hl.bind(mainMod .. " + SHIFT + up", hy3.move_window("u"))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.exec_cmd(HOME_DIR .. "/.config/hypr/scripts/move-window.sh r"))

-- Split orientation  (hy3:makegroup = genuine i3 `split h`/`split v`)
hl.bind(mainMod .. " + H", hy3.make_group("h"))
hl.bind(mainMod .. " + V", hy3.make_group("v"))

-- Fullscreen  (mode "maximized" == legacy `fullscreen, 1`)
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))

-- Layout toggle  (hy3:changegroup opposite = i3 `layout toggle split`)
hl.bind(mainMod .. " + W", hy3.change_group("opposite"))

-- Tabbed/stacked containers  (hy3 — improved equivalent of i3 tabbed/stacked)
hl.bind(mainMod .. " + T", hy3.change_group("toggletab"))

-- Floating toggle / focus layer toggle  (hy3:togglefocuslayer ≈ i3 `focus mode_toggle`)
hl.bind(mainMod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + space", hy3.toggle_focus_layer())

-- Focus parent/child  (hy3:changefocus raise/lower = i3 `focus parent`/`focus child`)
hl.bind(mainMod .. " + A", hy3.change_focus("raise"))
hl.bind(mainMod .. " + D", hy3.change_focus("lower"))

-- Workspaces 1-10  (10 maps to key 0)
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Reload config  (Hyprland auto-reloads on save; explicit reload available)
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprctl reload"))

-- Power/exit menu  (rofi-power-menu — same as i3; lockscreen action uses
-- `loginctl lock-session`, which hypridle catches and routes to hyprlock — §5)
hl.bind(
    mainMod .. " + SHIFT + E",
    hl.dsp.exec_cmd(
        "rofi -show power-menu -modi 'power-menu:rofi-power-menu --choices=lockscreen/logout/suspend/reboot/shutdown'"
    )
)

-- which-key helper  (§11)
hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd("which-key-wayland show"))

-- Resize submap  (i3 "resize" mode -> Hyprland submap)
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    hl.bind("J", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
    hl.bind("K", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
    hl.bind("L", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
    hl.bind("semicolon", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
    hl.bind("left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
    hl.bind("down", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
    hl.bind("up", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
    hl.bind("right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
    hl.bind("Return", hl.dsp.submap("reset"))
    hl.bind("Escape", hl.dsp.submap("reset"))
    hl.bind(mainMod .. " + R", hl.dsp.submap("reset"))
end)

-- Volume/media keys  (locked = active on the lockscreen; repeating = key-repeat)
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +10%"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -10%"),
    { locked = true, repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute   @DEFAULT_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true })

-- ─────────────────────────────────────────────────────────────────────────────
-- Autostart  (§3, §5, §6, §9.4, §11) — exec-once, via the hyprland.start event.
-- ─────────────────────────────────────────────────────────────────────────────
-- These mirror the i3 `exec --no-startup-id` set, keeping the existing i3
-- toolchain (rofi/dunst). dunst is started automatically by
-- graphical-session.target (static unit), so no entry is needed here.
hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user import-environment XDG_CURRENT_DESKTOP")
    hl.exec_cmd("fcitx5 -d")
    hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("waybar") -- bar (§4) — Nord-themed, mirrors xfce4-panel
    hl.exec_cmd("hyprpaper") -- wallpaper (§7) — displays satpaper image
    hl.exec_cmd("which-key-wayland") -- keybind cheatsheet daemon (§11)
    hl.exec_cmd("sh -c 'sleep 2; hypridle'") -- idle/lock daemon (§6.4) — config in hypridle.conf
end)
