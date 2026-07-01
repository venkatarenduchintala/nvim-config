-- EslintFixAll on save, scoped to eslint-attached buffers only.
-- Registered as a side effect when this config file is sourced; the augroup's
-- clear = true keeps it idempotent if the file is sourced more than once.
local group = vim.api.nvim_create_augroup("EslintFixOnSave", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "eslint" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        command = "EslintFixAll",
      })
    end
  end,
})

return {
  settings = {
    packageManager = "npm",
  },
}
