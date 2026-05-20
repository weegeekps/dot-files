return {
    "stevearc/conform.nvim",
    lazy = false,
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
