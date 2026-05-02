return {
    "2kabhishek/nerdy.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    cmd = "Nerdy",
    opts = {
        max_recents = 20, -- Configure recent icons limit
        copy_to_clipboard = false, -- Copy glyph to clipboard instead of inserting
        copy_register = "+", -- Register to use for copying (if `copy_to_clipboard` is true)
    },
    keys = {
        { "<Leader>in", ":Nerdy list<CR>", desc = "Browse nerd icons" },
        { "<Leader>iN", ":Nerdy recents<CR>", desc = "Browse recent nerd icons" },
    },
}
