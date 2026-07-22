-- Headless treesitter parser installer for CI.
-- Uses TSInstall! + vim.wait() polling parser .so files on disk.
-- Exit code 1 on timeout so the CI step fails visibly.
local langs = { 'go', 'terraform', 'hcl', 'yaml', 'bash', 'gotmpl', 'dockerfile', 'jsonnet', 'python', 'markdown', 'markdown_inline' }
-- On the nvim-treesitter `main` branch parsers install to the default
-- install_dir (stdpath('data')/site), not the old lazy plugin dir.
local parser_dir = vim.fn.stdpath('data') .. '/site/parser/'

local function installed(lang)
  return vim.fn.filereadable(parser_dir .. lang .. '.so') == 1
end

for _, lang in ipairs(langs) do
  if installed(lang) then
    print('SKIP [' .. lang .. ']: already compiled')
  else
    print('INST [' .. lang .. ']: installing...')
    pcall(vim.cmd, 'TSInstall! ' .. lang)
  end
end

local ok = vim.wait(300000, function()
  for _, lang in ipairs(langs) do
    if not installed(lang) then return false end
  end
  return true
end, 2000)

if not ok then
  for _, lang in ipairs(langs) do
    if not installed(lang) then
      io.stderr:write('FAIL [' .. lang .. ']: compile timed out\n')
    end
  end
  vim.cmd('cquit 1')
else
  for _, lang in ipairs(langs) do
    print('OK   [' .. lang .. ']: parser ready')
  end
end
