return {
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
}
