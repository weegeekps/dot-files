return {
    "rmagatti/auto-session",
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    config = function()
        require("auto-session").setup({
            suppressed_dirs = { "~/", "~/Downloads", "/" },
            session_lens = {
                load_on_setup = true,
            },
            auto_restore_last_session = false,
            -- log_level = 'debug',
        })
    end,
}
