# Neovim configuration for SRE, Java, Python, Rust and Lua

Personal Lua-based Neovim configuration used as a daily IDE for SRE/DevOps work and software development.

> **Disclaimer:** This configuration is based on and forked from [magidc/nvim-config](https://github.com/magidc/nvim-config). Credits to the original author for the foundational setup.

<br>

# Installation
## Manual Setup
0. Clone this repository into `~/.config/nvim`:
    ```
    git clone --depth 1 https://github.com/venkatarenduchintala/nvim-config.git ~/.config/nvim
    ```
1. Install latest [Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim) (0.11+).
2. Install [ripgrep](https://github.com/BurntSushi/ripgrep) — required by some [Telescope](https://github.com/nvim-telescope/telescope.nvim) search modes.
3. LSP servers, DAP adapters, linters and formatters are managed automatically by [mason.nvim](https://github.com/mason-org/mason.nvim) on first launch.

<br>

# UI Theme
Several UI themes are preconfigured. The active theme is set in `lua/settings.lua`.
Default: [Tokyonight](https://github.com/folke/tokyonight.nvim).

<br>

# Custom Mappings
Core mappings are defined in `lua/mappings.lua`. [WhichKey](https://github.com/folke/which-key.nvim) provides inline descriptions for all bindings.
Plugin-specific mappings live in `lua/plugins/configs/`. LSP mappings are defined in `lua/lsp/` and are only active when a language server is attached.

<br>

# Tests

The `test/` directory contains a headless CI suite that runs inside the devcontainer image. All steps are orchestrated by `test/ci_validate.sh`.

## Test scripts

- **`test/ci_install_plugins.lua`** — boots lazy.nvim in headless mode and runs `lazy.sync()`. Fails with exit code 1 if lazy.nvim is not loadable or the sync step errors.

- **`test/ci_validate_lsp.lua`** — verifies the native LSP layer loads without errors:
  - `require("lsp")` succeeds (global capabilities set via `vim.lsp.config('*', {...})`)
  - `vim.lsp.config["*"]` contains the expected capabilities table
  - Spot-checks that each `after/lsp/<name>.lua` file was sourced by asserting `vim.lsp.config[name].settings` is present for: `gopls`, `lua_ls`, `rust_analyzer`, `yamlls`, `helm_ls`, `eslint`, `ansiblels`, `jsonnet_ls`

- **`test/install_parsers.lua`** — installs all treesitter parsers via `TSInstall!` in headless mode, then polls until all `.so` files appear on disk (timeout: 5 min). Fails if any parser times out.
  - Parsers: `go`, `terraform`, `hcl`, `yaml`, `bash`, `gotmpl`, `dockerfile`, `jsonnet`, `python`, `markdown`, `markdown_inline`

- **`test/validate_treesitter.lua`** — loads each parser against a real source fixture and calls `parser:parse()`. Fails if any parser cannot be loaded or produces no parse trees.

## Test fixtures

| File | Parser(s) tested |
|------|-----------------|
| `fixtures/hello.go` | `go` |
| `fixtures/main.tf` | `terraform` |
| `fixtures/deployment.yaml` | `yaml` |
| `fixtures/script.sh` | `bash` |
| `fixtures/helm_deployment.yaml` | `gotmpl` |
| `fixtures/Dockerfile` | `dockerfile` |
| `fixtures/dashboard.jsonnet` | `jsonnet` |
| `fixtures/script.py` | `python` |
| `fixtures/README.md` | `markdown`, `markdown_inline` |

<br>

# Running the CI pipeline locally

The GitHub Actions workflow (`.github/workflows/validate.yml`) builds the devcontainer image and mounts the repo into it. You can reproduce this locally in two ways.

## Option 1 — Direct Docker (recommended for this config)

The most reliable local approach, since the workflow uses Docker-in-Docker internally:

```bash
# Build the devcontainer image
docker build -f .devcontainer/Dockerfile -t nvim-config:ci .

# Run the full validation suite
docker run --rm \
  -e CI=true \
  -v "$(pwd):/home/dev/.config/nvim:ro" \
  nvim-config:ci \
  bash /home/dev/.config/nvim/test/ci_validate.sh
```

The `-e CI=true` flag skips heavy binary downloads (LSP servers, DAP adapters) so the run completes in under 5 minutes.

## Option 2 — [act](https://github.com/nektos/act)

[act](https://github.com/nektos/act) runs GitHub Actions workflows locally using Docker. Install it via your package manager, then:

```bash
# Run the validate job (mirrors what GitHub runs on push/PR)
act push -j validate
```

> **Note:** Because the workflow itself uses `docker/build-push-action`, `act` requires Docker-in-Docker. If the build step fails, fall back to Option 1 above.

<br>

# Featured Plugins

## LSP — Core Infrastructure
*All roles*

- **[mason.nvim](https://github.com/mason-org/mason.nvim)** — automatic installation of LSP servers, DAP adapters, linters and formatters
- **[mason-lspconfig](https://github.com/mason-org/mason-lspconfig.nvim)** — bridges mason with Neovim's native LSP API; auto-enables all installed servers
- **[mason-nvim-lint](https://github.com/rshkarin/mason-nvim-lint)** — bridges mason with nvim-lint for automatic linter installation
- **Native LSP (Neovim 0.11+)** — `vim.lsp.config` / `vim.lsp.enable` API; global capabilities in `lua/lsp/init.lua`; per-server settings in `after/lsp/<name>.lua`
- **[lspsaga.nvim](https://github.com/nvimdev/lspsaga.nvim)** — enhanced LSP UI: code actions, hover docs, rename, breadcrumbs
- **[nvim-lint](https://github.com/mfussenegger/nvim-lint)** — async linting engine; triggers on save
- **[conform.nvim](https://github.com/stevearc/conform.nvim)** — formatting engine with per-filetype formatter chains

---

## SRE / DevOps
*Go · Terraform · Helm · Ansible · Bash · Dockerfile · YAML · Jsonnet · Python · Markdown*

### Language Servers
- **gopls** — Go LSP: unused params, shadow analysis, staticcheck, gofumpt formatting
- **terraformls + tflint** — Terraform/HCL LSP and linting
- **helm_ls** — Helm chart LSP with embedded yamlls for template files
- **ansiblels + ansible-lint** — Ansible playbook LSP with validation and linting
- **bashls + shellcheck + shfmt** — Bash LSP, linting and formatting
- **dockerls + docker_compose_language_service + hadolint** — Dockerfile/Compose LSP and linting
- **yamlls + yamllint + kube-linter** — YAML LSP (SchemaStore-backed), linting; Kubernetes manifest linting
- **jsonnet_ls** — Jsonnet/Grafonnet LSP for Grafana dashboards as code (Tanka support via `-t` flag)
- **pyright + ruff** — Python LSP; ruff for fast linting and formatting (replaces pylint + black)
- **marksman** — Markdown LSP: link resolution, wikilinks, references
- **actionlint** — GitHub Actions workflow linting

### Treesitter Parsers
`go` · `terraform` · `hcl` · `bash` · `gotmpl` · `dockerfile` · `jsonnet` · `python` · `markdown` · `markdown_inline` · `yaml`

---

## Development — Java
*Java · Spring Boot · Gradle · Maven*

- **[nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls)** — full jdtls lifecycle management: organize imports, super implementation, DAP integration
- **[nvim-dap](https://github.com/mfussenegger/nvim-dap)** + **mason-nvim-dap** — Debug Adapter Protocol; Java debug adapter + test runner via jdtls

---

## Development — Rust
*Rust · Cargo*

- **[rustaceanvim](https://github.com/mrcjkb/rustaceanvim)** — native LSP API Rust support: runnables, debuggables, hover actions; uses `after/lsp/rust_analyzer.lua` settings
- **[crates.nvim](https://github.com/saecki/crates.nvim)** — `Cargo.toml` dependency info and version management inline

---

## Development — Python
*Python · Jupyter*

- **pyright + ruff** — type-checked Python LSP with fast unified linting/formatting
- **[nvim-dap-python](https://github.com/mfussenegger/nvim-dap-python)** — Python debug adapter via debugpy
- **[nvim-jupyter-client](https://github.com/geg2102/nvim-jupyter-client)** — Jupyter notebook editing inside Neovim

---

## Development — Lua
*Neovim plugin development*

- **[lazydev.nvim](https://github.com/folke/lazydev.nvim)** — accurate Neovim API completions and type hints for `lua_ls`; replaces manual `workspace.library` setup
- **lua_ls** — Lua LSP with LuaJIT runtime and Neovim global awareness

---

## Development — Web / General
*JavaScript · TypeScript · HTML · CSS · JSON · Rust · C/C++ · LaTeX*

- **eslint** — JavaScript/TypeScript linting with auto-fix on save
- **html/cssls/jsonls/clangd/pyright** — LSP coverage for web and systems languages
- **[vimtex](https://github.com/lervag/vimtex)** — LaTeX editing with live compile and PDF preview

---

## Completion
*All roles*

- **[nvim-cmp](https://github.com/hrsh7th/nvim-cmp)** — completion engine with sources: LSP, Neovim API, buffer, path, luasnip, lazydev
- **[LuaSnip](https://github.com/L3MON4D3/LuaSnip)** — snippet engine with VSCode snippet support
- **[lspkind.nvim](https://github.com/onsails/lspkind.nvim)** — VSCode-style completion item kind icons

---

## Navigation
*All roles*

- **[Telescope](https://github.com/nvim-telescope/telescope.nvim)** — fuzzy finder over files, buffers, LSP symbols, git, diagnostics and more
- **[neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim)** — file explorer with git status integration
- **[aerial.nvim](https://github.com/stevearc/aerial.nvim)** — code outline window for symbols and quick navigation
- **[glance.nvim](https://github.com/dnlhc/glance.nvim)** — peek at definitions, references and implementations in a floating window
- **[leap.nvim](https://github.com/ggandor/leap.nvim)** + **[flash.nvim](https://github.com/folke/flash.nvim)** — fast cursor motion anywhere on screen
- **[nvim-spider](https://github.com/chrisgrieser/nvim-spider)** — CamelCase and snake_case word motions

---

## Editing
*All roles*

- **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)** — syntax highlighting, indentation and structural editing
- **[nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)** — semantic text objects: functions, classes, parameters, blocks, loops, conditionals
- **[nvim-autopairs](https://github.com/windwp/nvim-autopairs)** — auto-close brackets, quotes and tags
- **[nvim-surround](https://github.com/kylechui/nvim-surround)** — add, change and delete surrounding delimiters
- **[vim-visual-multi](https://github.com/mg979/vim-visual-multi)** — multiple cursors
- **[substitute.nvim](https://github.com/gbprod/substitute.nvim)** — replace motion target with register contents
- **[dial.nvim](https://github.com/monaqa/dial.nvim)** — extended increment/decrement for dates, booleans, hex, etc.
- **[comment.nvim](https://github.com/numToStr/Comment.nvim)** — smart line and block commenting
- **[splitjoin](https://github.com/Wansmer/treesj)** — split or join lists and argument blocks
- **[nvim-ufo](https://github.com/kevinhwang91/nvim-ufo)** — improved code folding with LSP/treesitter providers
- **[vim-matchup](https://github.com/andymass/vim-matchup)** — extended `%` matching for language keywords

---

## Git
*All roles*

- **[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)** — inline blame, hunk preview, stage/reset hunks in the gutter
- **[diffview.nvim](https://github.com/sindrets/diffview.nvim)** — side-by-side diff viewer and merge tool
- **[lazygit.nvim](https://github.com/kdheepak/lazygit.nvim)** — full LazyGit TUI inside Neovim

---

## AI
*All roles*

- **[claudecode.nvim](https://github.com/coder/claudecode.nvim)** — Claude Code integration: AI-assisted editing, code generation and explanation directly in the editor

---

## UI & Productivity
*All roles*

- **[bufferline.nvim](https://github.com/akinsho/bufferline.nvim)** — tab bar with buffer management
- **[lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)** — status line with LSP, git and diagnostics info
- **[trouble.nvim](https://github.com/folke/trouble.nvim)** — diagnostics panel: errors, warnings, LSP references, quickfix
- **[todo-comments.nvim](https://github.com/folke/todo-comments.nvim)** — highlight and search TODO/FIXME/NOTE/HACK comments
- **[which-key.nvim](https://github.com/folke/which-key.nvim)** — popup showing available key bindings as you type
- **[toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)** — floating, horizontal and vertical terminal panes
- **[neoclip.nvim](https://github.com/AckslD/nvim-neoclip.lua)** — clipboard history picker via Telescope
- **[nvim-notify](https://github.com/rcarriga/nvim-notify)** — animated popup notifications
- **[illuminate.nvim](https://github.com/RRethy/vim-illuminate)** — automatically highlight all occurrences of the word under the cursor
- **[nvim-colorizer](https://github.com/norcalli/nvim-colorizer.lua)** — inline color preview for hex codes and CSS colors
- **[undotree](https://github.com/mbbill/undotree)** — visual undo history tree
- **[project.nvim](https://github.com/ahmedkhalf/project.nvim)** — automatic project root detection and project switching
- **[bigfile.nvim](https://github.com/LunarVim/bigfile.nvim)** — disables heavy features for large files to maintain performance
- **[neoscroll.nvim](https://github.com/karb94/neoscroll.nvim)** — smooth scrolling animations
- **[vim-startify](https://github.com/mhinz/vim-startify)** — start screen with recent files and sessions
