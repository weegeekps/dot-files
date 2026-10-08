return {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = { "saghen/blink.cmp" },
    config = function()
        local lspconfig = require("lspconfig")

        local capabilities = require("blink.cmp").get_lsp_capabilities({
            textDocument = {
                foldingRange = {
                    dynamicRegistration = false,
                    lineFoldingOnly = true,
                },
            },
        })
        vim.lsp.config("*", { capabilities = capabilities })

        vim.lsp.enable("rust_analyzer")

        vim.lsp.config("vtsls", {
            settings = {
                vtsls = {
                    autoUseWorkspaceTsdk = true,
                },
                typescript = {
                    tsdk = "node_modules/typescript/lib",
                },
            },
        })
        vim.lsp.enable("vtsls")

        local clangd_markers = vim.lsp.config["clangd"].root_markers or {}
        vim.lsp.config("clangd", {
            cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--completion-style=detailed",
                "--function-arg-placeholders",
                "--header-insertion=iwyu",
                "--pch-storage=memory",
                "-j=8",
            },
            init_options = {
                fallbackFlags = { "-std=c++20" },
            },
            root_markers = {
                ".clang-tidy",
                ".clangd",
                ".clang-format",
                "compile_commands.json",
                "compile_flags.txt",
                "configure.ac",
                "CMakeLists.txt",
                ".git",
            },
        })
        vim.lsp.enable("clangd")

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
            desc = "Go to Definition",
            noremap = true,
            silent = true,
        })
        vim.keymap.set(
            "n",
            "<Leader><Space>",
            vim.lsp.buf.code_action,
            { desc = "LSP Code Action", noremap = true, silent = true }
        )
        vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, {
            desc = "Rename symbol",
            noremap = true,
            silent = true,
        })
    end,
}
