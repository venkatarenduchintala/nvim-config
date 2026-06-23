# Neovim configuration for Java, Python, Rust and Lua

Personal Lua-based Neovim configuration used as a daily IDE for Java, Python and Rust development.

> **Disclaimer:** This configuration is based on and forked from [magidc/nvim-config](https://github.com/magidc/nvim-config). Credits to the original author for the foundational setup.

<br>

# Installation
## Manual Setup
0. Clone this repository into `~/.config/nvim`:
    ```
    git clone --depth 1 https://github.com/venkatarenduchintala/nvim-config.git ~/.config/nvim
    ```
1. Install latest [Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim).
2. Install [ripgrep](https://github.com/BurntSushi/ripgrep) — required by some [Telescope](https://github.com/nvim-telescope/telescope.nvim) search modes.
3. LSP servers and DAP adapters (Java, Python, Rust, Lua) are managed automatically by [mason.nvim](https://github.com/mason-org/mason.nvim) on first launch.

<br>

# UI Theme
Several UI themes are preconfigured. The active theme is set in `lua/settings.lua`.
Default: [Tokyonight](https://github.com/folke/tokyonight.nvim).

<br>

# Custom Mappings
Core mappings are defined in `lua/mappings.lua`. [WhichKey](https://github.com/folke/which-key.nvim) provides inline descriptions for all bindings.
Plugin-specific mappings live in `lua/plugins/configs/`. LSP mappings are defined in `lua/lsp/` and are only active when a language server is attached.

<br>

# Featured Plugins
* [Telescope](https://github.com/nvim-telescope/telescope.nvim)
    > Highly extendable fuzzy finder over lists
* [Neotree](https://github.com/nvim-neo-tree/neo-tree.nvim)
    > Tree file explorer
* [Aerial](https://github.com/stevearc/aerial.nvim)
    > Code outline window for skimming and quick navigation
* [WhichKey](https://github.com/folke/which-key.nvim)
    > Displays a popup with possible key bindings of the command you started typing
* [Nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls)
    > Extensions for the built-in LSP support in Neovim for eclipse.jdt.ls
* [Nvim-dap](https://github.com/mfussenegger/nvim-dap)
    > Debug Adapter Protocol client implementation for Neovim
* Others...
