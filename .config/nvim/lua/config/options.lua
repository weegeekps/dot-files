local opt = vim.opt

opt.number = true
opt.backspace = { "indent", "eol", "start" }
opt.backup = true
opt.undofile = true
opt.history = 50
opt.ruler = true
opt.showcmd = true
opt.incsearch = true
opt.hlsearch = true
opt.mouse = "a"
opt.directory = { vim.fn.expand("~/tmp"), "./tmp", "." }
opt.backupdir = { vim.fn.expand("~/tmp"), "./tmp", "." }
opt.undodir = { vim.fn.expand("~/tmp"), "./tmp", "." }

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

-- Scaling on majorian
local hostname = vim.uv.os_gethostname()
if vim.g.neovide and hostname == "majorian" then
    vim.g.neovide_scale_factor = 1.4
end

-- Scaling for Windows
if vim.g.neovide and vim.fn.has("win64") then
    vim.g.neovide_scale_factor = 0.8
end
