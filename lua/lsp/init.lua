local handlers = require("lsp.handlers")

-- Capabilities applied globally to every server; per-server settings live in after/lsp/<name>.lua
vim.lsp.config('*', {
  capabilities = handlers.capabilities,
})

-- Global on_attach via autocmd — survives any per-server on_attach overrides
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      handlers.on_attach(client, args.buf)
    end
  end,
})
