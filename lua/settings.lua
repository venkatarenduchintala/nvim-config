local utils = require("utils")

local options = {
	autoindent = true,
	autoread = true,
	background = "dark",
	backup = false,
	breakindent = true, -- Enable break indent
	clipboard = "unnamed,unnamedplus", -- Use system clipboard
	cmdheight = 1,
	completeopt = "noinsert,menuone,noselect", -- Set completeopt to have a better completion experience
	confirm = true,
	cursorline = true,
	errorbells = false,
	expandtab = true,
	fileencoding = "utf-8",
	foldenable = true,
	foldexpr = "nvim_treesitter#foldexpr()",
	foldlevel = 99,
	foldlevelstart = 99,
	foldmethod = "expr",
	hidden = true,
	hlsearch = true, -- Set highlight on search
	ignorecase = true, -- Case insensitive searching UNLESS /C or capital in search
	incsearch = true,
	inccommand = "nosplit",
	laststatus = 3,
	mouse = "a", -- Enable mouse mode
	number = true, -- Make line numbers default
	numberwidth = 4,
	pumheight = 10,
	relativenumber = true,
	scrolloff = 5,
	shiftround = true,
	shiftwidth = 2,
	showmode = false,
	sidescrolloff = 5,
	signcolumn = "yes",
	smartcase = true,
	smartindent = true,
	softtabstop = 2,
	splitbelow = true,
	splitright = true,
	swapfile = false,
	tabstop = 2,
	termguicolors = true,
	-- Decrease update time
	timeoutlen = 1000,
	ttimeoutlen = 0,
	title = true,
	undodir = os.getenv("HOME") .. "/.vim/undodir",
	undofile = true, -- Save undo history
	updatetime = 100, -- Decrease update time
	wrap = true,
	wrapmargin = 120,
}

for key, value in pairs(options) do
	vim.opt[key] = value
end

vim.opt.shortmess:append "IsF"
-- vim.opt.shortmess:append "c"

vim.cmd [[set fcs=eob:\ ]]
vim.cmd([[
    filetype plugin indent on
    syntax on
]])

utils.set_indent_sizes {
  ["c"] = 4,
  ["cpp"] = 4,
  ["css"] = 2,
  ["go"] = 4,
  ["html"] = 2,
  ["java"] = 4,
  ["javascript"] = 2,
  ["json"] = 2,
  ["lua"] = 2,
  ["make"] = 4,
  ["markdown"] = 2,
  ["python"] = 4,
  ["rust"] = 4,
  ["sh"] = 2,
  ["typescript"] = 2,
  ["xml"] = 4,
  ["yaml"] = 2,
  ["*"] = 2,
}

-- Disable automatic line breaks
vim.opt.textwidth = 0
vim.opt.wrap = false
vim.opt.linebreak = false
vim.opt.formatoptions:remove({ "t", "c", "a", "r", "o" })

-- Space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- nvim-notify as default vim notification method
local _notify, notify = pcall(require, "notify")
if _notify then
	vim.notify = notify
end

-- UI theme
require("theme").set_active_theme("tokyonight")

-- Not apply background color when running inside tmux. My tmux config changes background color whether the pane is active or not, so I want to use that instead of neovim's background color.
if vim.env.TMUX then
	vim.schedule(function()
		local groups = { "Normal", "NormalNC", "EndOfBuffer", "SignColumn" }
		for _, g in ipairs(groups) do
			vim.api.nvim_set_hl(0, g, { bg = "none" })
		end
	end)
end
