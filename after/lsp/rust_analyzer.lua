return {
  settings = {
    ["rust-analyzer"] = {
      diagnostics = { enable = true },
      imports = {
        granularity = { group = "module" },
        prefix = "self",
      },
      cargo = { buildScripts = { enable = true } },
      procMacro = { enable = true },
    },
  },
}
