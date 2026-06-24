return {
    "lucobellic/edgy-group.nvim",
    dependencies = { "folke/edgy.nvim" },
    event = "VeryLazy",
    opts = {
        groups = {
            bottom = {
                { icon = "󰡱 ", titles = { "Scopes", "Stacks" }, pick_key = "s" },
                { icon = " ", titles = { "Breakpoints", "Stacks" }, pick_key = "b" },
                { icon = "󰈈 ", titles = { "Watches", "Stacks" }, pick_key = "w" },
                { icon = " ", titles = { "Console", "Stacks" }, pick_key = "c" },
                { icon = " ", titles = { "REPL", "Stacks" }, pick_key = "r" },
                { icon = " ", titles = { "Trouble" }, pick_key = "t" },
            },
        },
    },
}
