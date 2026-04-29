local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local vimrcEx = augroup("vimrcEx", { clear = true })

-- Jump to last known cursor position
autocmd("BufReadPost", {
    group = vimrcEx,
    pattern = "*",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line_count = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.cmd('normal! g`"')
        end
    end,
})

-- Text files: textwidth 78, autowrap
autocmd("FileType", {
    group = vimrcEx,
    pattern = { "markdown", "text", "gitcommit" },
    callback = function()
        vim.opt_local.textwidth = 78
        vim.opt_local.spell = true
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
    end,
})
