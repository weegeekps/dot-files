-- with lazy.nvim
return {
    "LintaoAmons/bookmarks.nvim",
    -- backup your bookmark sqlite db when there are breaking changes (major version change)
    tag = "v4.0.0",
    dependencies = {
        { "kkharji/sqlite.lua" },
        -- picker backend (choose one):
        { "nvim-telescope/telescope.nvim" }, -- set picker.picker_backend = "telescope" to use
    },
    keys = {
        { "<Leader>kk", ":BookmarksMark<CR>", desc = " Bookmark Current Line" },
        { "<Leader>kt", ":BookmarksTree<CR>", desc = " Browse Bookmarks" },
        { "<Leader>kn", ":BookmarksNewList<CR>", desc = "󰗛 Create a new Bookmark List" },
        { "<Leader>kl", ":BookmarksLists<CR>", desc = "󰂺 Pick a Bookmark List" },
        { "<Leader>kc", ":BookmarksCommands<CR>", desc = " Find a Bookmark Command" },
        { "<C-k>", ":BookmarkGotoPrev<CR>", desc = "󰒮 Previous Bookmark" },
        { "<C-l>", ":BookmarkGotoNext<CR>", desc = "󰒭 Next Bookmark" },
    },
    config = function()
        local opts = {
            picker = {
                picker_backend = "telescope",
            },
        }
        require("bookmarks").setup(opts)
    end,
}
