local api = vim.api

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
})

-- go to last loc when opening a buffer
api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- make zsh files recognized as sh for bash-ls & treesitter
vim.filetype.add({
	extension = {
		zsh = "sh",
		sh = "sh", -- force sh-files with zsh-shebang to still get sh as filetype
	},
	filename = {
		[".zshrc"] = "sh",
		["zshrc"] = "sh",
		[".zshenv"] = "sh",
	},
})

-- nvim-treesitter is incompatible with nvim 0.12's captures API for markdown
-- injections (TSNode[] vs TSNode mismatch in set-lang-from-info-string!),
-- causing crashes in both the highlighter and vim-matchup. Stop treesitter
-- for markdown until upstream fixes the predicate handler.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.treesitter.stop()
	end,
})

-- Disable cmp autocompletion for YAML — we want linting/diagnostics only
vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml",
  callback = function()
    require("cmp").setup.buffer({ enabled = false })
  end,
})

-- Disable automatic line breaks
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.textwidth = 0
    vim.opt_local.formatoptions:remove { "t", "c", "a", "r", "o" }
  end,
})

-- Large file handler: disable heavy features for files > 2 MiB
vim.api.nvim_create_autocmd("BufReadPre", {
  callback = function(args)
    local buf = args.buf
    local ok, stat = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
    if not (ok and stat and stat.size > 2 * 1024 * 1024) then
      return
    end

    vim.opt_local.swapfile = false
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.undolevels = -1
    vim.opt_local.undoreload = 0
    vim.opt_local.list = false

    if vim.fn.exists(":DoMatchParen") == 2 then
      vim.cmd("NoMatchParen")
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      buffer = buf,
      callback = function(lsp_args)
        vim.schedule(function()
          vim.lsp.buf_detach_client(buf, lsp_args.data.client_id)
        end)
      end,
    })

    pcall(vim.treesitter.stop, buf)
    pcall(function() require("illuminate.engine").stop_buf(buf) end)
    pcall(function() require("ibl").setup_buffer(buf, { enabled = false }) end)

    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(buf) then
        vim.bo[buf].syntax = "OFF"
        vim.bo[buf].filetype = ""
      end
    end)
  end,
})
