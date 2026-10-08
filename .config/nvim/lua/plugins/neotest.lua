return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "orjangj/neotest-ctest",
        "mfussenegger/nvim-dap",
    },

    keys = {
        {
            "<Leader>tt",
            function()
                require("neotest").run.run()
            end,
            desc = "Run nearest test",
        },
        {
            "<Leader>td",
            function()
                require("neotest").run.run({ strategy = "dap" })
            end,
            desc = "Debug nearest test",
        },
        {
            "<Leader>tf",
            function()
                require("neotest").run.run(vim.fn.expand("%:p"))
            end,
            desc = "Run tests in file",
        },
        {
            "<Leader>ta",
            function()
                require("neotest").run.run({ suite = true })
            end,
            desc = "Run test suite",
        },
        {
            "<Leader>tl",
            function()
                require("neotest").run.run_last()
            end,
            desc = "Repeat last test run",
        },
        {
            "<Leader>ts",
            function()
                require("neotest").summary.toggle()
            end,
            desc = "Toggle test summary",
        },
        {
            "<Leader>to",
            function()
                require("neotest").output.open({
                    enter = true,
                    auto_close = true,
                })
            end,
            desc = "Show test output",
        },
        {
            "<Leader>tp",
            function()
                require("neotest").output_panel.toggle()
            end,
            desc = "Toggle test output panel",
        },
        {
            "<Leader>tx",
            function()
                require("neotest").run.stop()
            end,
            desc = "Stop nearest test",
        },
    },

    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-ctest").setup({
                    dap_adapter = "gdp",

                    -- Recognize common test filenames and test directories.
                    is_test_file = function(path)
                        path = path:gsub("\\", "/"):lower()
                        local name = vim.fn.fnamemodify(path, ":t:r")
                        local ext = vim.fn.fnamemodify(path, ":e")

                        return vim.tbl_contains({ "cpp", "cc", "cxx" }, ext)
                            and (name:find("test", 1, true) ~= nil or path:find("/tests?/") ~= nil)
                    end,
                }),
            },
        })
    end,
}
