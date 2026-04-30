return {
	"nvim-telescope/telescope.nvim",
	version = "0.2.*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"BurntSushi/ripgrep", -- optional but recommended
	},
	keys = {
		{ "<C-p>", ":Telescope find_files<CR>" },
		{ "<Leader>g", ":Telescope live_grep<CR>" },
		{ "<Leader>b", ":Telescope buffers<CR>" },
		{ "<Leader>/", ":Telescope session_lens<CR>" },
	},
}
