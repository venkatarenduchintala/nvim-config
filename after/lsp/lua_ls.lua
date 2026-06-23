vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      -- workspace.library is managed by lazydev.nvim
      telemetry = { enable = false },
    },
  },
})
