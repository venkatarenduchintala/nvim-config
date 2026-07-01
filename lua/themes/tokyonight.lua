-- Tokyonight — 'night' style with near-black background (original tuning).
return {
	"folke/tokyonight.nvim",
	config = function()
		local theme = require("tokyonight")
		theme.setup({
			style = "night",
			on_colors = function(colors)
				colors.bg_dark = "#000000"
				colors.bg = "#11121D"
				-- colors.bg_visual = require("theme").colors.grey12
			end,
		})
		theme.load()
	end,
}
