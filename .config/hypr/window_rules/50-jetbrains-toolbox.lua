-- Window rules for Jetbrains Toolbox
-- Makes the window float in the upper right of the screen.

hl.window_rule({
    name = "jetbrains-toolbox-float",
    match = {
        class = "jetbrains-toolbox",
    },
    float = true,
    move = { "monitor_w - (window_w * 1.5)", "100" },
})
