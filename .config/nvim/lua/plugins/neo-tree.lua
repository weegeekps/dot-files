-- lua/plugins/neo-tree.lua
return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            local is_neovide = vim.g.neovide ~= nil

            require("neo-tree").setup({
                -- Match your nvim-tree git filter behavior
                filesystem = {
                    filtered_items = {
                        visible = false,
                        hide_dotfiles = false,
                        hide_gitignored = true,
                        hide_by_name = { ".git" },
                        never_show = { ".git" },
                        always_show_by_pattern = { ".gemini*", ".github*", ".claude*", "_my_instructions*" },
                    },
                    follow_current_file = {
                        enabled = true, -- mirrors update_focused_file.enable
                        leave_dirs_open = false,
                    },
                    use_libuv_file_watcher = true,
                    -- Mirrors root_dirs behavior: find project root by these markers
                    find_by_full_path_words = false,
                    bind_to_cwd = false,
                    cwd_target = {
                        sidebar = "window",
                    },
                },

                -- Match your view settings
                window = {
                    position = "left",
                    width = 40,
                    mappings = {
                        -- Keep neo-tree's defaults and add anything custom here
                    },
                },

                -- git status column (mirrors git = { enable = true })
                git_status = {
                    symbols = {
                        added = "✚",
                        modified = "",
                        deleted = "✖",
                        renamed = "󰁕",
                        untracked = "",
                        ignored = "",
                        unstaged = "󰄱",
                        staged = "",
                        conflict = "",
                    },
                },

                -- Sources: filesystem always present; buffers source added for Neovide
                sources = { "filesystem", "buffers", "git_status" },

                -- Source selector renders the tab strip at the top of the panel
                -- Only show it in Neovide where it doubles as a tab system
                source_selector = {
                    winbar = true,
                    statusline = false,
                    show_scrolled_off_parent_node = false,
                    sources = {
                        { source = "filesystem", display_name = " 󰉓 Files " },
                        { source = "buffers", display_name = " 󰈚 Bufs  " },
                        { source = "git_status", display_name = " 󰊢 Git   " },
                    },
                },

                -- Buffers source config (the "vertical tab" panel)
                buffers = {
                    follow_current_file = {
                        enabled = true, -- auto-highlight the active buffer
                        leave_dirs_open = false,
                    },
                    group_empty_dirs = true,
                    show_unloaded = true,
                    window = {
                        mappings = {
                            ["d"] = "buffer_delete", -- close buffer from panel
                            ["bd"] = "buffer_delete",
                        },
                    },
                },
            })
        end,
    },
}
