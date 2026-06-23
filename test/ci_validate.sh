#!/bin/bash
set -e

echo "=== Bootstrapping lazy.nvim ==="
git clone --filter=blob:none \
  https://github.com/folke/lazy.nvim.git \
  --branch=stable \
  "$HOME/.local/share/nvim/lazy/lazy.nvim"

echo "=== Installing plugins via lazy.nvim ==="
nvim --headless \
  -c "luafile /home/dev/.config/nvim/test/ci_install_plugins.lua" \
  -c "qall"

echo "=== Validating Neovim startup with all plugins ==="
nvim --headless -c "qall"

echo "=== Installing treesitter parsers (Go, Terraform, HCL) ==="
nvim --headless \
  -c "luafile /home/dev/.config/nvim/test/install_parsers.lua" \
  -c "qall"

echo "=== Testing Go and Terraform treesitter parsers ==="
nvim --headless \
  -c "luafile /home/dev/.config/nvim/test/validate_treesitter.lua" \
  -c "qall"

echo "=== All validations passed! ==="
