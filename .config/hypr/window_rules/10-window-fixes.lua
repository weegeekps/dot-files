-- These window rules are various fixes that should be temporary but will
-- likely live on forever.

hl.window_rule({
    name = "fix-xwayland-ghost-windows",
    match = {
        xwayland = true,
        class = "^$",
        title = "^$",
    },
    no_focus = true,
})

-- For Edge and Chromium
hl.window_rule({
    name = "fix-chromium-ghost-windows",
    match = {
        class = "^$",
        title = "^$",
    },
    float = true,
    no_initial_focus = true,
    move = { "9999999", "9999999" },
})
