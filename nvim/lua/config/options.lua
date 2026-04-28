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

-- Colorscheme
-- vim.g.base16colorspace = 256
vim.opt.termguicolors = true
vim.cmd.colorscheme("base16-tomorrow-night")

-- Neovide Font
vim.opt.guifont = "Fira Code:h12"

