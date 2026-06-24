vim.opt.number = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.backup = true
vim.opt.undofile = true
vim.opt.history = 50
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.mouse = "a"
vim.opt.directory = { vim.fn.expand("~/tmp"), "./tmp", "." }
vim.opt.backupdir = { vim.fn.expand("~/tmp"), "./tmp", "." }
vim.opt.undodir = { vim.fn.expand("~/tmp"), "./tmp", "." }

-- Indentation Settings
-- NOTE: Soft/Hard wrapping and whether or not to wrap is handled by
--   the wrapping.nvim plugin.
vim.opt.breakindent = true
vim.opt.linebreak = true

-- Tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Colorscheme
-- vim.g.base16colorspace = 256
vim.opt.termguicolors = true
vim.cmd.colorscheme("base16-tomorrow-night")

-- Neovide Font
vim.opt.guifont = "Fira Code:h12"

-- glTF Helpers
vim.filetype.add({
    extension = {
        gltf = "json",
    },
})

-- Session
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Scaling on Linux
if vim.g.neovide then
    vim.g.neovide_scale_factor = 1.4
end

-- Scaling for Windows
if vim.g.neovide and vim.fn.has("win64") then
    vim.g.neovide_scale_factor = 0.8
end
