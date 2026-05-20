local keymap = vim.keymap.set

-- Leader key
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

-- Quit
keymap("n", "<Leader>q", ":waq", { desc = "Save All and Quit", noremap = true, silent = true })

-- Save
keymap("n", "<Leader>s", ":wa<CR>", { desc = "Save All Files", noremap = true, silent = true })

-- Cursor navigation
keymap("n", "<Home>", "^", { noremap = true, silent = true })
keymap("i", "<Home>", "<C-o>^", { noremap = true, silent = true })

-- Quit All
keymap("n", "<Leader>qq", ":qa<CR>", { desc = "Quit All without Saving", noremap = true, silent = true })

-- Quit All & Save
keymap("n", "<Leader>qs", ":wqa<CR>", { desc = "Quit All and Save", noremap = true, silent = true })

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

-- Neovide Specific
if vim.g.neovide then
    -- System Copy, Cut, Paste
    keymap("n", "<Leader>x", '"+d', { desc = "Cut to system register", noremap = true })
    keymap("n", "<Leader>c", '"+y', { desc = "Copy to system register", noremap = true })
    keymap("n", "<Leader>p", '"+p', { desc = "Paste from system register", noremap = true })

    -- Zoom In
    keymap("n", "<C-=>", function()
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
    end, { desc = "Zoom In", noremap = true, silent = true })

    -- Zoom Reset
    keymap("n", "<C-->", function()
        -- On Windows I use a 0.8 scaling factor.
        -- See options.lua
        vim.g.neovide_scale_factor = vim.fn.has("win64") and 0.8 or 1.0
    end, { desc = "Reset Zoom", noremap = true, silent = true })
end
