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
}
