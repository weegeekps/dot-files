return {
	"NeogitOrg/neogit",
	lazy = true,
	dependencies = {
		"sindrets/diffview.nvim",
		"nvim-telescope/telescope.nvim",
	},
	cmd = "Neogit",
	keys = {
		{ "<Leader>gg", ":Neogit cwd=%:p:h<CR>", desc = "Show Neogit UI" },
	},
}
