-- Verify that the LSP layer loads without errors:
-- global capabilities are set, and after/lsp/ configs are valid Lua.
local ok, err = pcall(require, "lsp")
if not ok then
  io.stderr:write("FAIL lsp module: " .. tostring(err) .. "\n")
  vim.cmd("cquit 1")
end

local global_cfg = vim.lsp.config["*"]
if not global_cfg or not global_cfg.capabilities then
  io.stderr:write("FAIL vim.lsp.config['*'] has no capabilities set\n")
  vim.cmd("cquit 1")
end

-- Spot-check that server-specific after/lsp overrides are present
local servers_with_settings = { "gopls", "lua_ls", "rust_analyzer", "yamlls", "helm_ls", "eslint", "ansiblels", "jsonnet_ls" }
for _, name in ipairs(servers_with_settings) do
  local cfg = vim.lsp.config[name]
  if not cfg or not cfg.settings then
    io.stderr:write("FAIL after/lsp/" .. name .. ".lua: settings not applied\n")
    vim.cmd("cquit 1")
  end
  print("OK   [" .. name .. "]: settings present")
end

print("OK   global capabilities set")
