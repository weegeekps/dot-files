return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "helix",
        spec = {
            { "<Leader>d", group = "Diagnostics" },
            { "<Leader>f", group = "Find/Grep" },
            { "<Leader>g", group = "Git" },
            { "<Leader>k", group = "Bookmarks" },
            { "<Leader>m", group = "Make/CMake" },
            { "<Leader>q", group = "Quit" },
            { "<Leader>t", group = "Tests" },
        },
    },
    keys = {
        {
            "<Leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}
