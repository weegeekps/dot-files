return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<Leader>l",
            function()
                require("conform").format({ async = true })
            end,
            desc = "Format buffer",
        },
    },
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                rust = { "rustfmt" },
                python = { "black" },
                cpp = { "clang_format" },
                c = { "clang_format" },
                typescript = { "prettier" },
                javascript = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                json = { "prettier" },
                lua = { "stylua" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        })
    end,
}
