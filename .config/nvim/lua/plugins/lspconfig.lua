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
                vim.deepcopy(clangd_markers),
                { "CMakeLists.txt" },
            },
        })
        vim.lsp.enable("clangd")

        local opts = { noremap = true, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set(
            "n",
            "<Leader><Space>",
            vim.lsp.buf.code_action,
            { desc = "LSP Code Action", noremap = true, silent = true }
        )
        vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
    end,
}
