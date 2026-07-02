return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        options = {
            always_show_bufferline = true,
            diagnostics = "nvim_lsp",
            hover = {
                enabled = true,
                delay = 200,
                reveal = { "close" },
            },
            numbers = 0,
            offsets = {
                {
                    filetype = "neo-tree",
                    text = "Explorer",
                    text_align = "left",
                    separator = true,
                },
            },
            persist_buffer_sort = true,
        },
    },
}
