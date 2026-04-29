return {
    {
        "andrewferrier/wrapping.nvim",
        config = function()
            require("wrapping").setup({
                auto_set_mode_filetype_allowlist = {
                    "asciidoc",
                    "gitcommit",
                    "latex",
                    "mail",
                    "markdown",
                    "rst",
                    "tex",
                    "text",
                },
                softener = {
                    asciidoc = true,
                    latex = true,
                    markdown = true,
                    rst = true,
                    tex = true,
                    text = true,
                },
            })
        end,
    },
}
