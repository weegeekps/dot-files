return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {
            paragraph = {
                enabled = true,
                left_margin = 5,
            },
            heading = { border = true },
            indent = {
                enabled = true,
                skip_heading = true,
            },
            completions = {
                lsp = { enabled = true },
            },
        },
    },
}
