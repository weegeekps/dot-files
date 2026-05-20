local keymap = vim.keymap.set

-- Leader key
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

-- Save
keymap("n", "<Leader>s", ":wa<CR>", { desc = "Save All Files", noremap = true })

-- nvim-tree
-- keymap("n", "<Leader>1", ":NvimTreeToggle<CR>", { desc = "Toggle Tree", noremap = true, silent = true })
-- keymap("n", "<Leader>2", ":NvimTreeFindFile<CR>", { desc = "Focus Tree", noremap = true, silent = true })

-- neo-tree
keymap("n", "<Leader>1", ":Neotree toggle<CR>", { desc = "Open Tree", noremap = true, silent = true })
keymap("n", "<Leader>2", ":Neotree reveal<CR>", { desc = "Focus Tree", noremap = true, silent = true })
keymap(
    "n",
    "<Leader>3",
    ":Neotree source=buffers reveal=true<CR>",
    { desc = "Tree Buffer View", noremap = true, silent = true }
)
keymap(
    "n",
    "<Leader>4",
    ":Neotree source=filesystem reveal=true<CR>",
    { desc = "Tree Filesystem View", noremap = true, silent = true }
)

-- Linting
keymap("n", "<Leader>\\", ":lua require('lint').try_lint()<CR>", { desc = "Do Lint", noremap = true, silent = true })

-- Buffer navigation
keymap("n", "<Leader>n", ":bn<CR>", { desc = "Next Buffer", noremap = true, silent = true })
keymap("n", "<Leader>p", ":bp<CR>", { desc = "Previous Buffer", noremap = true, silent = true })

-- Surround
-- Insert mode Ctrl-U
keymap("i", "<C-U>", "<C-G>u<C-U>", { desc = "Surround", noremap = true })

-- Format shortcut for Rust (rustfmt)
keymap("n", "<Leader>f", function()
    require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Force rustfmt", noremap = true, silent = true })
