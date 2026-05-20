return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        local lint = require("lint")
        lint.linters_by_ft = {
            html = { "htmlhint" },
            python = { "flake8" },
            cpp = { "clangtidy" },
            c = { "clangtidy" },
            javascript = { "eslint" },
            typescript = { "eslint" },
        }
        lint.linters.eslint = vim.tbl_deep_extend("force", lint.linters.eslint, {
            cmd = "npx",
            args = vim.list_extend({ "eslint", "--format", "json" }, lint.linters.eslint.args or {}),
            condition = function(ctx)
                return vim.fs.find({
                    "eslint.config.js",
                    "eslint.config.mjs",
                    ".eslintrc.json",
                    ".eslintrc.js",
                    ".eslintrc.yml",
                }, { path = ctx.filename, upward = true })[1] ~= nil
            end,
        })
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            callback = function()
                lint.try_lint()
            end,
        })
    end,
}
