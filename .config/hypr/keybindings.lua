-- ─────────────────────────────────────────────────────────────────────────────
-- Keybindings — $mod = SUPER
-- ─────────────────────────────────────────────────────────────────────────────
local HOME_DIR = os.getenv("HOME")
local mainMod = "SUPER"

-- hy3 plugin API. Under Lua config, `hyprctl dispatch` breaks plugin dispatchers
-- containing colons (hy3:*), so the typed hl.plugin.hy3.* API is the only path.
local hy3 = hl.plugin.hy3

-- Terminal / file manager
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd("dolphin"))

-- Screenshot
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m output"))

-- Kill focused window
hl.bind(mainMod .. " + SHIFT + Q", hy3.kill_active())

-- Launcher
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd("rofi -modi drun,run -show drun"))

-- Focus movement — vim-style j/k/l/; remap
hl.bind(mainMod .. " + J", hy3.move_focus("l"))
hl.bind(mainMod .. " + K", hy3.move_focus("d"))
hl.bind(mainMod .. " + L", hy3.move_focus("u"))
hl.bind(mainMod .. " + semicolon", hy3.move_focus("r"))
hl.bind(mainMod .. " + left", hy3.move_focus("l"))
hl.bind(mainMod .. " + down", hy3.move_focus("d"))
hl.bind(mainMod .. " + up", hy3.move_focus("u"))
hl.bind(mainMod .. " + right", hy3.move_focus("r"))

-- Move window — left/right use edge-aware script for cross-monitor moves
hl.bind(mainMod .. " + SHIFT + J", hy3.move_window("l"))
hl.bind(mainMod .. " + SHIFT + K", hy3.move_window("d"))
hl.bind(mainMod .. " + SHIFT + L", hy3.move_window("u"))
hl.bind(mainMod .. " + SHIFT + semicolon", hy3.move_window("r"))
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.exec_cmd(HOME_DIR .. "/.config/hypr/scripts/move-window.sh l"))
hl.bind(mainMod .. " + SHIFT + down", hy3.move_window("d"))
hl.bind(mainMod .. " + SHIFT + up", hy3.move_window("u"))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.exec_cmd(HOME_DIR .. "/.config/hypr/scripts/move-window.sh r"))

-- Split orientation
hl.bind(mainMod .. " + H", hy3.make_group("h"))
hl.bind(mainMod .. " + V", hy3.make_group("v"))

-- Fullscreen — mode "maximized" == legacy `fullscreen, 1`
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))

-- Layout toggle
hl.bind(mainMod .. " + W", hy3.change_group("opposite"))

-- Tabbed/stacked containers
hl.bind(mainMod .. " + T", hy3.change_group("toggletab"))

-- Floating toggle / focus layer toggle
hl.bind(mainMod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + space", hy3.toggle_focus_layer())

-- Focus parent/child
hl.bind(mainMod .. " + A", hy3.change_focus("raise"))
hl.bind(mainMod .. " + D", hy3.change_focus("lower"))

-- Workspaces 1-10 — 10 maps to key 0
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Reload config
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprctl reload"))

-- Re-handshake displays after a KVM switch (dpms off→on cycle). Hyprland keeps
-- the output "active" through a KVM switch, so the link never re-trains and the
-- screens stay black until a DPMS cycle. Always-works manual fallback; the
-- kvm-recover.service automates it when the kernel emits a DRM hotplug event.
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(HOME_DIR .. "/.config/hypr/scripts/kvm-recover.sh"))

-- Power/exit menu
hl.bind(
    mainMod .. " + SHIFT + E",
    hl.dsp.exec_cmd(
        "rofi -show power-menu -modi 'power-menu:rofi-power-menu --choices=lockscreen/logout/suspend/reboot/shutdown'"
    )
)

-- which-key helper
hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd("which-key-wayland show"))

-- Resize submap
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

-- Volume/media keys — locked = active on lockscreen; repeating = key-repeat
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
