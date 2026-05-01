return {
    "rmagatti/auto-session",
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    config = function()
        require("auto-session").setup({
            allowed_dirs = { "~/Projects/**" },
            auto_restore_last_session = false,
            bypass_save_filetypes = { "neo-tree" },
            session_lens = {
                load_on_setup = true,
            },
            -- log_level = 'debug',
        })
    end,
}
