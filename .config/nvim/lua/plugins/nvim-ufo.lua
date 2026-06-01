return {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost", -- Lazy load after opening a buffer
    keys = {
        {
            "zR",
            function()
                require("ufo").openAllFolds()
            end,
            desc = "Open all folds",
        },
        {
            "zM",
            function()
                require("ufo").closeAllFolds()
            end,
            desc = "Close all folds",
        },
    },
    init = function()
        -- These are strictly required by nvim-ufo
        vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldclose:]]
        vim.o.foldcolumn = "auto:9" -- Show fold column
        vim.o.foldlevel = 99 -- Unfold everything by default
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
    end,
    opts = {
        -- Optional: Provider selector
        provider_selector = function(bufnr, filetype, buftype)
            return { "lsp", "indent" }
        end,
    },
}
