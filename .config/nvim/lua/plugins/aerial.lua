return {
    "stevearc/aerial.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    keys = {
        {
            "<Leader>fss",
            function()
                require("telescope").extensions.aerial.aerial()
            end,
            desc = "Find symbols",
        },
    },
    opts = {
        -- Prefer clangd for C++ symbols
        backends = { "lsp", "treesitter" },

        filter_kind = {
            "Class",
            "Constructor",
            "Enum",
            "EnumMember",
            "Function",
            "Interface",
            "Method",
            "Namespace",
            "Struct",
        },
    },
    config = function(_, opts)
        require("aerial").setup(opts)
        require("telescope").load_extension("aerial")
    end,
}
