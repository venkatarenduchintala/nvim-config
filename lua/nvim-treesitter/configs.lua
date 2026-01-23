local M = {}

local config = require("nvim-treesitter.config")

function M.setup(...)
  return config.setup(...)
end

function M.get_available(...)
  return config.get_available(...)
end

function M.get_installed(...)
  return config.get_installed(...)
end

return M