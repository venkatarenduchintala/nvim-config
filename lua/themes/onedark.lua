return {
	"navarasu/onedark.nvim",
	config = function()
		local theme = require("onedark")
		theme.setup({
			style = "deep",
			transparent = false, -- Show/hide background
			code_style = {
				comments = "italic",
				keywords = "none",
				functions = "none",
				strings = "none",
				variables = "none",
			},
			lualine = {
				transparent = true, -- lualine center bar transparency
			},
		})
		theme.load()
	end,
}
