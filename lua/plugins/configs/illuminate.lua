return {
	"RRethy/vim-illuminate",
	event = { "BufReadPost", "BufNewFile" },
	lazy = false,
	config = function()
		require("illuminate").configure({
			providers = {
				"lsp",
				-- nvim-treesitter.locals is unstable here on Neovim 0.12; use regex fallback instead.
				"regex",
			},
			filetypes_denylist = {
				"NeoTree",
				"toggleterm",
				"TelescopePrompt",
			},

			-- delay: delay in milliseconds
			delay = 100,
			-- large_file_cutoff: number of lines at which to use large_file_config
			-- The `under_cursor` option is disabled when this cutoff is hit
			large_file_cutoff = 500,
			-- large_file_config: config to use for large files (based on large_file_cutoff).
			-- Supports the same keys passed to .configure
			-- If nil, vim-illuminate will be disabled for large files.
			large_file_overrides = nil,
		})

		-- Replaces the dropped nvim-treesitter-refactor goto_next/previous_usage
		-- (]] / [[) with illuminate's reference navigation.
		vim.keymap.set("n", "]]", function()
			require("illuminate").goto_next_reference(false)
		end, { desc = "Next reference/usage" })
		vim.keymap.set("n", "[[", function()
			require("illuminate").goto_prev_reference(false)
		end, { desc = "Previous reference/usage" })
	end,
}
