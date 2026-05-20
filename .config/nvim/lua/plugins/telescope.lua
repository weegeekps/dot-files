return {
    "nvim-telescope/telescope.nvim",
    version = "0.2.*",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "rmagatti/auto-session",
        "BurntSushi/ripgrep",
    },
    keys = {
        { "<C-p>", ":Telescope live_grep<CR>", desc = "Telescope Live Grep" },
        { "<Leader>ff", ":Telescope find_files<CR>", desc = "Telescope Find Files" },
        { "<Leader>b", ":Telescope buffers<CR>", desc = "Telescope Buffers" },
        { "<Leader>/", ":Telescope session_lens<CR>", desc = "Telescope Sessions" },
        { "<Leader>i", ":Telescope nerdy<CR>", desc = "Telescope Nerd Fonts" },
        { "<Leader>h", ":Telescope keymaps<CR>", desc = "Telescope Keymaps" },
    },
    config = function()
        require("telescope").setup()
        require("telescope").load_extension("nerdy")
    end,
}
