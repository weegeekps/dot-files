return {
    "stevearc/overseer.nvim",
    ---@module 'overseer'
    ---@type overseer.SetupOpts
    opts = {
        task_list = {
            direction = "bottom",
        },
        component_aliases = {
            default = {
                { "on_output_quickfix", open = false },
                "on_exit_set_status",
                "on_complete_notify",
                { "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
            },
        },
    },
    keys = {
        { "<Leader>mo", ":OverseerToggle<CR>", desc = "Toggle Overseer" },
    },
}
