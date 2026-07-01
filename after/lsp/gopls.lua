-- Merged into the gopls config resolved by vim.lsp (Neovim 0.11+ native API).
return {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
}
