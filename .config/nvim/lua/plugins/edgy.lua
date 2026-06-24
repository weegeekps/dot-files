return {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
        vim.opt.laststatus = 3
        vim.opt.splitkeep = "screen"
    end,
    opts = {
        bottom = {
            {
                ft = "trouble",
                title = "Trouble",
                size = { height = 0.3 },
            },
            bottom = {
                { ft = "dapui_scopes", title = "Scopes", size = { height = 0.3 } },
                { ft = "dapui_breakpoints", title = "Breakpoints", size = { height = 0.3 } },
                { ft = "dapui_watches", title = "Watches", size = { height = 0.3 } },
                { ft = "dapui_console", title = "Console", size = { height = 0.3 } },
                { ft = "dap-repl", title = "REPL", size = { height = 0.3 } },
                { ft = "dapui_stacks", title = "Stacks", size = { height = 0.3 } },
                { ft = "trouble", title = "Trouble", size = { height = 0.3 } },
            },
        },
        left = {
            {
                ft = "neo-tree",
                title = "Neo-Tree",
                size = { width = 40, height = 0.5 },
            },
        },
    },
}
