return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "andrewferrier/wrapping.nvim",
        "stevearc/overseer.nvim",
    },
    config = function()
        local function wrapMode()
            local mode = require("wrapping").get_current_mode()
            if mode == "soft" then
                return "󰴐"
            elseif mode == "hard" then
                return "󰴎"
            end

            return "󰴏"
        end

        local function show_cmake_targets()
            return package.loaded["cmake-tools"] ~= nil
                and #vim.lsp.get_clients({
                    bufnr = vim.api.nvim_get_current_buf(),
                    name = "clangd",
                }) > 0
                and require("cmake-tools").is_cmake_project()
        end

        require("lualine").setup({
            options = { theme = "base16" },
            sections = {
                lualine_b = {
                    "branch",
                    "diff",
                    {
                        function()
                            local target = require("cmake-tools").get_build_target()
                            return " " .. (target or "[unset]")
                        end,
                        cond = show_cmake_targets,
                        on_click = function()
                            vim.cmd("CMakeSelectBuildTarget")
                        end,
                    },
                    {
                        function()
                            local target = require("cmake-tools").get_launch_target()
                            return " " .. (target or "[unset]")
                        end,
                        cond = show_cmake_targets,
                        on_click = function()
                            vim.cmd("CMakeSelectBuildTarget")
                        end,
                    },
                    "overseer",
                    "diagnostics",
                },
                lualine_c = {
                    {
                        "filename",
                        path = 3,
                    },
                },
                lualine_x = {
                    wrapMode,
                    "encoding",
                    "fileformat",
                    "filetype",
                },
            },
        })
    end,
}
