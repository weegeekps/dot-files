-- Hyprland configuration (Lua)
-- Session launched via uwsm (hyprland-uwsm.desktop).
-- Shell stack: waybar + rofi + dunst + hyprlock + hyprpaper + hypridle.
-- hypridle/hyprlock/hyprpaper remain on hyprlang.

-- ─────────────────────────────────────────────────────────────────────────────
-- Monitors — driven by environment variables for portability.
-- ─────────────────────────────────────────────────────────────────────────────
-- Each HYPRLAND_PRIMARY_MONITOR / HYPRLAND_SECONDARY_MONITOR env var (set in
-- ~/.config/uwsm/env) holds: desc:Make Model Serial, WxH@refresh, XxY, scale
-- Falls back to auto-detection if unset.
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
-- hy3 tiling plugin — must load before general.layout = "hy3" is applied.
-- ─────────────────────────────────────────────────────────────────────────────
hl.plugin.load("/usr/lib/libhy3.so")

-- ─────────────────────────────────────────────────────────────────────────────
-- Environment — compositor-level vars; IM/cursor theme live in environment.d/
-- ─────────────────────────────────────────────────────────────────────────────
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("GDK_BACKEND", "wayland,x11")

-- ─────────────────────────────────────────────────────────────────────────────
-- General / layout / decoration / input
-- ─────────────────────────────────────────────────────────────────────────────
hl.config({
    general = {
        layout = "hy3",
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            -- Nord frost gradient: nord8 (#88c0d0) to nord10 (#5e81ac), 45deg
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
-- Animations — custom bezier + per-leaf settings
-- ─────────────────────────────────────────────────────────────────────────────
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

-- ─────────────────────────────────────────────────────────────────────────────
-- Window rules — auto-loaded from ~/.config/hypr/window_rules/*.lua
-- ─────────────────────────────────────────────────────────────────────────────
-- Each .lua file in window_rules/ is loaded in sorted (alphabetical) order.
-- Window rules evaluate top-to-bottom, so filename order governs rule order —
-- prefix files with NN_ (e.g. 10-floating.lua) to control precedence.
local window_rules_dir = os.getenv("HOME") .. "/.config/hypr/window_rules"
local listing = io.popen('ls -1 "' .. window_rules_dir .. '"/*.lua 2>/dev/null')
if listing then
    for path in listing:lines() do
        loadfile(path)()
    end
    listing:close()
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Keybindings — extracted to keybindings.lua
-- ─────────────────────────────────────────────────────────────────────────────
loadfile(os.getenv("HOME") .. "/.config/hypr/keybindings.lua")()

-- ─────────────────────────────────────────────────────────────────────────────
-- Autostart — exec-once via hyprland.start event.
-- ─────────────────────────────────────────────────────────────────────────────
-- Mirrors the i3 exec --no-startup-id set. dunst starts via graphical-session.target.
-- session_started gates the monitor.added KVM-recovery handler below until the
-- initial monitor setup completes, so login doesn't trigger a spurious dpms cycle.
local session_started = false
hl.on("hyprland.start", function()
    session_started = true
    hl.exec_cmd("systemctl --user import-environment XDG_CURRENT_DESKTOP")
    hl.exec_cmd("fcitx5 -d")
    hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("waybar") -- bar
    hl.exec_cmd("hyprpaper") -- wallpaper
    hl.exec_cmd("which-key-wayland") -- keybind cheatsheet
    hl.exec_cmd("sh -c 'sleep 2; hypridle'") -- idle/lock daemon
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- KVM / monitor reconnect recovery
-- ─────────────────────────────────────────────────────────────────────────────
-- This KVM does not emulate the displays: switching away/back makes the monitors
-- genuinely disconnect and reconnect. Hyprland re-adds them (firing monitor.added)
-- but the re-add modeset alone doesn't wake the physical panel — a dpms off→on
-- cycle does (the same cycle the idle/lock path uses on resume). So on every real
-- monitor reconnect, run kvm-recover.sh. FALLBACK is the virtual output Hyprland
-- creates while all real monitors are gone (KVM switched away) — skip it. The
-- session_started gate skips the startup monitor burst. SUPER+B (keybindings.lua)
-- is the manual fallback.
hl.on("monitor.added", function(monitor)
    if not session_started or monitor.name == "FALLBACK" then return end
    hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/kvm-recover.sh")
end)
