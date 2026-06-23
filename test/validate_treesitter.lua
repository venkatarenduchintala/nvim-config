-- Headless treesitter validation script.
-- Exit code 1 on any failure so CI catches it.
local errors = {}

local function test_parser(lang, filepath)
  local lines = vim.fn.readfile(filepath)
  if #lines == 0 then
    table.insert(errors, string.format('[%s] fixture not found or empty: %s', lang, filepath))
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local ok, result = pcall(vim.treesitter.get_parser, buf, lang)
  if not ok or result == nil then
    table.insert(errors, string.format('[%s] parser load failed: %s', lang, tostring(result)))
    vim.api.nvim_buf_delete(buf, { force = true })
    return
  end

  local ok2, trees = pcall(function() return result:parse() end)
  if not ok2 then
    table.insert(errors, string.format('[%s] parse failed: %s', lang, tostring(trees)))
    vim.api.nvim_buf_delete(buf, { force = true })
    return
  end

  if not trees or #trees == 0 then
    table.insert(errors, string.format('[%s] no parse trees returned', lang))
    vim.api.nvim_buf_delete(buf, { force = true })
    return
  end

  vim.api.nvim_buf_delete(buf, { force = true })
  print(string.format('OK   [%s]: treesitter parser works', lang))
end

local cfg = '/home/dev/.config/nvim'
test_parser('go',         cfg .. '/test/fixtures/hello.go')
test_parser('terraform',  cfg .. '/test/fixtures/main.tf')
test_parser('yaml',       cfg .. '/test/fixtures/deployment.yaml')
test_parser('bash',       cfg .. '/test/fixtures/script.sh')
test_parser('gotmpl',     cfg .. '/test/fixtures/helm_deployment.yaml')
test_parser('dockerfile', cfg .. '/test/fixtures/Dockerfile')
test_parser('jsonnet',          cfg .. '/test/fixtures/dashboard.jsonnet')
test_parser('python',           cfg .. '/test/fixtures/script.py')
test_parser('markdown',         cfg .. '/test/fixtures/README.md')
test_parser('markdown_inline',  cfg .. '/test/fixtures/README.md')

if #errors > 0 then
  for _, err in ipairs(errors) do
    io.stderr:write('FAIL ' .. err .. '\n')
  end
  vim.cmd('cquit 1')
end
