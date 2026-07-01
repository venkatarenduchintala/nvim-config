-- Tokyonight 'moon' — softer than 'night', no forced near-black background.
return {
	"folke/tokyonight.nvim",
	config = function()
		local theme = require("tokyonight")
		theme.setup({
			style = "moon",
			styles = { comments = { italic = true } },
		})
		theme.load()
	end,
}
