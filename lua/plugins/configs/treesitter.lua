-- Parsers to install/keep updated. On the `main` branch these are compiled
-- locally via tree-sitter-cli + a C compiler (unlike the old `master` branch,
-- which downloaded prebuilt parsers).
local ensure_installed = {
	"java",
	"cpp",
	"rust",
	"python",
	"lua",
	"html",
	"json",
	"dockerfile",
	"yaml",
	"css",
	"javascript",
	"typescript",
	"vue",
	"toml",
	-- SRE
	"go",
	"terraform",
	"hcl",
	"bash",
	"gotmpl",
	"jsonnet",
	-- Markdown
	"markdown",
	"markdown_inline",
}

-- Treesitter indentation is experimental on `main`; keep it off for the
-- languages whose indent module misbehaved on the old branch.
local indent_disabled = { python = true, css = true, rust = true }

-- Text-object select maps: lhs -> { query, desc }
local select_maps = {
	aa = { "@parameter.outer", "Select outer part of an argument/parameter" },
	ia = { "@parameter.inner", "Select inner part of an argument/parameter" },
	ab = { "@block.outer", "Select outer part of a block" },
	ib = { "@block.inner", "Select inner part of a block" },
	am = { "@function.outer", "Select outer part of a method" },
	im = { "@function.inner", "Select inner part of a method" },
	ac = { "@class.outer", "Select outer part of a class" },
	ic = { "@class.inner", "Select inner part of a class" },
	ay = { "@conditional.outer", "Select outer part of a conditional" },
	iy = { "@conditional.inner", "Select inner part of a conditional" },
	al = { "@loop.outer", "Select outer part of a loop" },
	il = { "@loop.inner", "Select inner part of a loop" },
}

-- Move maps: { fn, lhs, query, desc } — fn is a nvim-treesitter-textobjects.move method.
local move_maps = {
	-- next start
	{ "goto_next_start", "]m", "@function.outer", "Next method start" },
	{ "goto_next_start", "]c", "@class.outer", "Next class start" },
	{ "goto_next_start", "]a", "@parameter.outer", "Next argument/parameter start" },
	{ "goto_next_start", "]b", "@block.outer", "Next block start" },
	{ "goto_next_start", "]y", "@conditional.outer", "Next conditional start" },
	{ "goto_next_start", "]l", "@loop.outer", "Next loop start" },
	-- next end
	{ "goto_next_end", "]M", "@function.outer", "Next method end" },
	{ "goto_next_end", "]C", "@class.outer", "Next class end" },
	{ "goto_next_end", "]A", "@parameter.inner", "Next argument/parameter end" },
	{ "goto_next_end", "]B", "@block.outer", "Next block end" },
	{ "goto_next_end", "]Y", "@conditional.outer", "Next conditional end" },
	{ "goto_next_end", "]L", "@loop.outer", "Next loop end" },
	-- previous start
	{ "goto_previous_start", "[m", "@function.outer", "Previous method start" },
	{ "goto_previous_start", "[c", "@class.outer", "Previous class start" },
	{ "goto_previous_start", "[a", "@parameter.outer", "Previous argument/parameter start" },
	{ "goto_previous_start", "[b", "@block.outer", "Previous block start" },
	{ "goto_previous_start", "[y", "@conditional.outer", "Previous conditional start" },
	{ "goto_previous_start", "[l", "@loop.outer", "Previous loop start" },
	-- previous end
	{ "goto_previous_end", "[M", "@function.outer", "Previous method end" },
	{ "goto_previous_end", "[C", "@class.outer", "Previous class end" },
	{ "goto_previous_end", "[A", "@parameter.inner", "Previous argument/parameter end" },
	{ "goto_previous_end", "[B", "@block.outer", "Previous block end" },
	{ "goto_previous_end", "[Y", "@conditional.outer", "Previous conditional end" },
	{ "goto_previous_end", "[L", "@loop.outer", "Previous loop end" },
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false, -- required: global default is lazy = true
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install(ensure_installed)

			-- Highlighting on `main` is Neovim-native: start it per buffer.
			-- markdown is intentionally excluded — autocmds.lua stops treesitter
			-- for markdown (nvim 0.12 predicate-handler crash).
			local group = vim.api.nvim_create_augroup("ts_main_highlight", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				callback = function(args)
					local ft = vim.bo[args.buf].filetype
					if ft == "markdown" then
						return
					end
					if not pcall(vim.treesitter.start, args.buf) then
						return
					end
					if not indent_disabled[ft] then
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		lazy = false,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = { lookahead = true },
				move = { set_jumps = true },
			})

			local select = require("nvim-treesitter-textobjects.select")
			for lhs, spec in pairs(select_maps) do
				vim.keymap.set({ "x", "o" }, lhs, function()
					select.select_textobject(spec[1], "textobjects")
				end, { desc = spec[2] })
			end

			local move = require("nvim-treesitter-textobjects.move")
			for _, m in ipairs(move_maps) do
				local fn, lhs, query, desc = m[1], m[2], m[3], m[4]
				vim.keymap.set({ "n", "x", "o" }, lhs, function()
					move[fn](query, "textobjects")
				end, { desc = desc })
			end

			-- vim way: ; repeats the last move in its direction, , the opposite.
			local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
		end,
	},
	{
		-- The `autotag` module no longer exists on treesitter `main`; the plugin
		-- is configured standalone.
		"windwp/nvim-ts-autotag",
		lazy = false,
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
}
