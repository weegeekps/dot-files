return {
    "nvim-mini/mini.bufremove",
    version = false,
    keys = {
        {
            "<Leader>qw",
            function()
                require("mini.bufremove").delete(0, false)
            end,
            desc = "Close Buffer",
        },
    },
}
