-- Window rules — loaded by hyprland.lua via glob from this directory.
-- Files load in alphabetical order; prefix with NN_ to control precedence
-- (window rules evaluate top-to-bottom, last match wins).
-- API: hl.window_rule({ name = "...", match = { class = "..." }, <effects> })

-- Ignore spurious maximize requests from every client. Many Electron/GTK apps
-- emit these on startup and would otherwise force-maximize the window.
hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "floating-never-start-maximized",
    match = { float = true },
    maximize = false,
    fullscreen = false,
    suppress_event = "maximize fullscreen",
})
