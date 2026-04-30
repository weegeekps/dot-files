local keymap = vim.keymap.set

-- Leader key
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

-- nvim-tree
-- keymap("n", "<Leader>1", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
-- keymap("n", "<Leader>2", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })

-- neo-tree (replaces NvimTreeToggle / NvimTreeFindFile)
keymap("n", "<Leader>1", ":Neotree toggle<CR>", { noremap = true, silent = true })
keymap("n", "<Leader>2", ":Neotree reveal<CR>", { noremap = true, silent = true })
keymap("n", "<Leader>3", ":Neotree source=buffers reveal=true<CR>", { noremap = true, silent = true })
keymap("n", "<Leader>4", ":Neotree source=filesystem reveal=true<CR>", { noremap = true, silent = true })

-- Linting (syntastic → nvim-lint)
keymap("n", "<Leader>\\", ":lua require('lint').try_lint()<CR>", { noremap = true, silent = true })

-- Buffer navigation
keymap("n", "<Leader>n", ":bn<CR>", { noremap = true, silent = true })
keymap("n", "<Leader>p", ":bp<CR>", { noremap = true, silent = true })
keymap("n", "<Leader>l", ":ls<CR>", { noremap = true, silent = true })

-- Surround
-- Insert mode Ctrl-U
keymap("i", "<C-U>", "<C-G>u<C-U>", { noremap = true })

-- Format shortcut for Rust (rustfmt)
keymap("n", "<Leader>f", function()
    require("conform").format({ async = true, lsp_fallback = true })
end, { noremap = true, silent = true })
