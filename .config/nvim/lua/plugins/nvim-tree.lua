return {
	"nvim-tree/nvim-tree.lua",
	lazy = false,
	enabled = false, -- Disabled to try out neo-tree
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("nvim-tree").setup({
			git = { enable = true },
			view = { side = "left", width = 30 },
			update_focused_file = {
				enable = true,
				update_root = true,
			},
			root_dirs = { ".git", "Cargo.toml", "package.json", "CMakeLists" },
			filters = {
				custom = { "^\\.git$" },
			},
		})
	end,
}
