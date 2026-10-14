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
                json = { "prettier", "", stop_after_first = true },
                lua = { "stylua" },
                d2 = { "d2" },
            },
            formatters = {
                clang_format = {
                    command = "clang-format-18",
                    prepend_args = { "--style=file", "--fallback-style=LLVM" },
                },
                prettier = {
                    require_cwd = true,
                    cwd = require("conform.util").root_file({
                        ".prettierrc",
                        ".prettierrc.json",
                        ".prettierrc.yml",
                        ".prettierrc.yaml",
                        ".prettierrc.json5",
                        ".prettierrc.js",
                        ".prettierrc.cjs",
                        ".prettierrc.mjs",
                        ".prettierrc.toml",
                        "prettier.config.js",
                        "prettier.config.cjs",
                        "prettier.config.mjs",
                    }),
                },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        })
    end,
}
