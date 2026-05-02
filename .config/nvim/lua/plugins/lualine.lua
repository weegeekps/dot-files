return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "andrewferrier/wrapping.nvim" },
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
        require("lualine").setup({
            options = { theme = "base16" },
            sections = {
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
