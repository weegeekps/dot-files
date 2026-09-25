return {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
        { "L3MON4D3/LuaSnip", version = "v2.*" },
    },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = "super-tab",
        },
        snippets = { preset = "luasnip" },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },
        completion = {
            documentation = { auto_show = true, auto_show_delay_ms = 200 },
            menu = { draw = { treesitter = { "lsp" } } },
        },
        signature = { enabled = true },
        appearance = { nerd_font_variant = "mono" },
        fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
}
