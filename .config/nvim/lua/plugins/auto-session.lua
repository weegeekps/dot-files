return {
    "rmagatti/auto-session",
    lazy = false,
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    keys = {
        { "<Leader>/", ":AutoSession search<CR>", desc = "Search Sessions" },
    },
    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    config = function()
        require("auto-session").setup({
            allowed_dirs = { "~/Projects/**", "~/dot-files/**" },
            auto_restore_last_session = false,
            close_filetypes_on_save = {
                "lazy",
                "checkhealth",
                "neo-tree",
                "Trouble",
                "gitcommit",
                "TelescopePrompt",
                "TelescopeResults",
                "TelescopePreview",
                "TelescopeChooser",
                "help",
            },
            close_unsupported_windows = true,
            session_lens = {
                picker = "telescope",
                load_on_setup = true,
            },
            -- log_level = 'debug',
        })
    end,
}
