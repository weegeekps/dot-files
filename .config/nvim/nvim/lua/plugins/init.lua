return {
    -- Colorscheme
    {
        "RRethy/base16-nvim",
        lazy = false,
        priority = 1000,
    },

    -- Language support
    { "rust-lang/rust.vim", ft = "rust" },
    { "leafgarland/typescript-vim", ft = "typescript" },
    { "udalov/kotlin-vim", ft = "kotlin" },

    -- Git integration
    { "tpope/vim-fugitive" },

    -- Formatting
    {
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
    },

    -- Editing enhancements
    { "tpope/vim-surround" },
    {
        "numToStr/Comment.nvim",
        opts = {},
        keys = {
            { "gcc", mode = "n" },
            { "gc", mode = "v" },
        },
    },

    -- File browser
    -- {
    -- 	"nvim-tree/nvim-tree.lua",
    -- 	lazy = false,
    -- 	dependencies = { "nvim-tree/nvim-web-devicons" },
    -- 	config = function()
    -- 		require("nvim-tree").setup({
    -- 			git = { enable = true },
    -- 			view = { side = "left", width = 30 },
    -- 			update_focused_file = {
    -- 				enable = true,
    -- 				update_root = true,
    -- 			},
    -- 			root_dirs = { ".git", "Cargo.toml", "package.json", "CMakeLists" },
    -- 			filters = {
    -- 				custom = { "^\\.git$" },
    -- 			},
    -- 		})
    -- 	end,
    -- },

    -- Fuzzy finder (replaces ctrlp)
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "BurntSushi/ripgrep", -- optional but recommended
        },
        keys = {
            { "<C-p>", ":Telescope find_files<CR>" },
            { "<Leader>g", ":Telescope live_grep<CR>" },
            { "<Leader>b", ":Telescope buffers<CR>" },
            { "<Leader>s", ":Telescope session-lens<CR>" },
        },
    },

    -- LSP configuration
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lspconfig = require("lspconfig")

            -- Use the new vim.lsp.config API
            vim.lsp.config("rust_analyzer", {
                cmd = { "rust-analyzer" },
                root_markers = { "Cargo.toml", "rust-project.json" },
            })
            vim.lsp.enable("rust_analyzer")

            vim.lsp.config("ts_ls", {
                cmd = { "typescript-language-server", "--stdio" },
                root_markers = { "tsconfig.json", "package.json", ".git" },
            })
            vim.lsp.enable("ts_ls")

            vim.lsp.config("clangd", {
                cmd = { "clangd" },
                root_markers = { "compile_commands.json", ".clangd", "CMakeLists.txt" },
            })
            vim.lsp.enable("clangd")

            -- Optional: Set up keymaps for LSP
            local opts = { noremap = true, silent = true }
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
        end,
    },

    -- Completion engine
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                }),
            })
        end,
    },

    -- Linting
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = {
                html = { "htmlhint" },
                python = { "flake8" },
                cpp = { "clangtidy" },
                c = { "clangtidy" },
                javascript = { "eslint" },
                typescript = { "eslint" },
            }
            lint.linters.eslint = vim.tbl_deep_extend("force", lint.linters.eslint, {
                cmd = "npx",
                args = vim.list_extend({ "eslint", "--format", "json" }, lint.linters.eslint.args or {}),
                condition = function(ctx)
                    return vim.fs.find({
                        "eslint.config.js",
                        "eslint.config.mjs",
                        ".eslintrc.json",
                        ".eslintrc.js",
                        ".eslintrc.yml",
                    }, { path = ctx.filename, upward = true })[1] ~= nil
                end,
            })
            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },

    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", "andrewferrier/wrapping.nvim" },
        config = function()
            local function wrapMode()
                local mode = vim.b.wrapmode
                if mode == "soft" then
                    return "Soft"
                elseif mode == "hard" then
                    return "Hard"
                end

                return ""
            end

            require("lualine").setup({
                options = { theme = "base16" },
                sections = {
                    lualine_x = {
                        "wrapMode",
                        "encoding",
                        "fileformat",
                        "filetype",
                    },
                },
            })
        end,
    },
}
