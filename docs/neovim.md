# Neovim & Neovide Dotfiles

It's a safe assumption to assume you should be on the latest stable release of Neovim for these dotfiles.

## Configuration Structure

- `.config`
    - `nvim`
        - `init.lua` - Entry point for Neovim config
        - `lua`
            - `config`
                - `autocmds.lua` - Autocommand definitions
                - `keymaps.lua` - Key binding definitions
                - `lazy.lua` - Lazy.nvim bootstrap and setup
                - `options.lua` - Core Neovim options and settings
            - `plugins` - Plugin specifications
                - `init.lua` - General plugin configurations (git, colorscheme, etc.)
                - Plugin configurations are generally separated out into separate files.

## Dependencies

 - [ripgrep](https://github.com/burntsushi/ripgrep) - Recursive directory grep
 - [nerd-fonts](https://github.com/ryanoasis/nerd-fonts) - Glyph fonts for tons of stuff

## Neovim Plugins

### Color Scheme
- [RRethy/base16-nvim](https://github.com/RRethy/base16-nvim) - Base16 colorscheme collection

### Language Support
- [rust-lang/rust.vim](https://github.com/rust-lang/rust.vim) - Rust filetype support
- [leafgarland/typescript-vim](https://github.com/leafgarland/typescript-vim) - TypeScript syntax
- [udalov/kotlin-vim](https://github.com/udalov/kotlin-vim) - Kotlin syntax

### LSP & Completion
- [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configuration
- [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Completion engine
- [hrsh7th/cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) - LSP completion source
- [hrsh7th/cmp-buffer](https://github.com/hrsh7th/cmp-buffer) - Buffer completion source
- [hrsh7th/cmp-path](https://github.com/hrsh7th/cmp-path) - Path completion source
- [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip) - Snippet engine

### Formatting & Linting
- [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim) - Formatter dispatcher
- [mfussenegger/nvim-lint](https://github.com/mfussenegger/nvim-lint) - Linter integration

### Git
- [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive) - Git integration

### File Explorer
- [nvim-neo-tree/neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) - File tree (active)
- [nvim-tree/nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) - File tree (disabled)

### Fuzzy Finding
- [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder
- [2kabhishek/nerdy.nvim](https://github.com/2kabhishek/nerdy.nvim) - Nerd font icon picker (Telescope extension)

### UI
- [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - Status line
- [MeanderingProgrammer/render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) - Markdown rendering

### Editing
- [tpope/vim-surround](https://github.com/tpope/vim-surround) - Surround motions
- [numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim) - Comment toggling
- [andrewferrier/wrapping.nvim](https://github.com/andrewferrier/wrapping.nvim) - Soft/hard wrap toggling

### Session Management
- [rmagatti/auto-session](https://github.com/rmagatti/auto-session) - Automatic session save/restore

### Dependencies
- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim) - Lua utilities (required by neo-tree, telescope)
- [MunifTanjim/nui.nvim](https://github.com/MunifTanjim/nui.nvim) - UI component library (required by neo-tree)
- [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) - File type icons (required by multiple plugins)
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Treesitter (required by render-markdown)
- [BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep) - Ripgrep binary (recommended by telescope)

