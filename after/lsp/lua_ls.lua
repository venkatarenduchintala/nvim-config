return {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      -- workspace.library is managed by lazydev.nvim
      telemetry = { enable = false },
    },
  },
}
