return {
    "nvim-telescope/telescope.nvim",
    version = "0.2.*",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "rmagatti/auto-session",
        "BurntSushi/ripgrep",
    },
    keys = {
        { "<C-p>", ":Telescope live_grep<CR>" },
        { "<Leader>ff", ":Telescope find_files<CR>" },
        { "<Leader>b", ":Telescope buffers<CR>" },
        { "<Leader>/", ":Telescope session_lens<CR>" },
        { "<Leader>i", ":Telescope nerdy<CR>" },
        { "<Leader>h", ":Telescope keymaps<CR>" },
    },
    config = function()
        require("telescope").setup()
        require("telescope").load_extension("nerdy")
    end,
}
