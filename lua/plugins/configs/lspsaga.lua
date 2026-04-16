return {
	"nvimdev/lspsaga.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",    -- optional
    "nvim-tree/nvim-web-devicons",    -- optional
  },
	config = function()
		require("lspsaga").setup({
			lightbulb = {
				enable = false,
				sign = true,
				debounce = 10,
				virtual_text = true,
				sign_priority = 40,
			},
			symbol_in_winbar = {
				enable = false,
				separator = " › ",
				hide_keyword = false,
				ignore_patterns = nil,
				show_file = true,
				folder_level = 1,
				color_mode = true,
				dely = 300,
			},
		})
	end,
}
