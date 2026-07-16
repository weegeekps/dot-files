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
-- Keybindings — extracted to keybindings.lua
-- ─────────────────────────────────────────────────────────────────────────────
loadfile(os.getenv("HOME") .. "/.config/hypr/keybindings.lua")()

-- ─────────────────────────────────────────────────────────────────────────────
-- Autostart — exec-once via hyprland.start event.
-- ─────────────────────────────────────────────────────────────────────────────
-- Mirrors the i3 exec --no-startup-id set. dunst starts via graphical-session.target.
hl.on("hyprland.start", function()
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
