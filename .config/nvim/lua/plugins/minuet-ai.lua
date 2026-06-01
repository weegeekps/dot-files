return {
    "milanglacier/minuet-ai.nvim",
    config = function()
        require("minuet").setup({
            provider = "claude",
            provider_options = {
                model = "claude-sonnet-4.6",
            },
        })
    end,
}
