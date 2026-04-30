return {
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
}
