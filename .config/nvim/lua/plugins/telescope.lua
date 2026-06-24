return {
    "nvim-telescope/telescope.nvim",
    version = "0.2.*",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "rmagatti/auto-session",
        "BurntSushi/ripgrep",
    },
    keys = {
        { "<C-p>", ":Telescope live_grep<CR>", desc = "󰭎 Live Grep" },
        { "<Leader>ff", ":Telescope find_files<CR>", desc = "󰭎 Find Files" },
        { "<Leader>fg", ":Telescope git_files<CR>", desc = "󰭎 Find Files (respect .gitignore)" },
        { "<Leader>fr", ":Telescope lsp_references<CR>", desc = "󰭎 LSP References" },
        { "<Leader>fd", ":Telescope lsp_definitions<CR>", desc = "󰭎 LSP Definitions" },
        { "<Leader>ft", ":Telescope lsp_type_definitions<CR>", desc = "󰭎 LSP Type Definitions" },
        { "<Leader>fu", ":Telescope lsp_implementations<CR>", desc = "󰭎 LSP Implementations" },
        { "<Leader>fi", ":Telescope lsp_incoming_calls<CR>", desc = "󰭎 LSP Incoming Calls" },
        { "<Leader>fo", ":Telescope lsp_outgoing_calls<CR>", desc = "󰭎 LSP Outgoing Calls" },
        { "<Leader>fss", ":Telescope lsp_document_symbols<CR>", desc = "󰭎 LSP Document Symbols" },
        { "<Leader>fsw", ":Telescope lsp_workspace_symbols<CR>", desc = "󰭎 LSP Workspace Symbols" },
        { "<Leader>fd", ":Telescope diagnostics<CR>", desc = "󰭎 Diagnostics" },
        { "<Leader>b", ":Telescope buffers<CR>", desc = "󰭎 Buffers" },
        { "<Leader>i", ":Telescope nerdy<CR>", desc = "󰭎 Nerd Fonts" },
        { "<Leader>h", ":Telescope keymaps<CR>", desc = "󰭎 Keymaps" },
    },
    config = function()
        require("telescope").setup({
            defaults = {
                theme = "ivy",
            },
            pickers = {
                lsp_references = {
                    theme = "cursor",
                },
                lsp_definitions = {},
                lsp_type_definitions = {},
                lsp_implementations = {},
                lsp_incoming_calls = {
                    theme = "cursor",
                },
                lsp_outgoing_calls = {
                    theme = "cursor",
                },
                lsp_document_symbols = {},
                lsp_workspace_symbols = {},
                lsp_dynamic_workspace_symbols = {},
                diagnostics = {
                    theme = "dropdown",
                },
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
            },
        })
        require("telescope").load_extension("ui-select")
        require("telescope").load_extension("nerdy")
    end,
}
