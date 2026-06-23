-- Headless lazy.nvim plugin installer for CI.
-- Exits 1 loudly if lazy.nvim is not loadable or sync fails.
local ok, lazy = pcall(require, 'lazy')
if not ok then
  io.stderr:write('FATAL: lazy.nvim not loadable: ' .. tostring(lazy) .. '\n')
  vim.cmd('cquit 1')
end

print('lazy.nvim loaded, starting sync...')
lazy.sync({ wait = true, show = false })
print('lazy.nvim sync complete')
