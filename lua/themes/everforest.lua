-- Everforest — warm green-grey, muted, designed for low fatigue.
return {
	"sainnhe/everforest",
	config = function()
		vim.o.background = "dark"
		vim.g.everforest_background = "medium" -- hard | medium | soft
		vim.g.everforest_foreground = "material"
		vim.g.everforest_ui_contrast = "low"
		vim.g.everforest_enable_italic = true
		vim.g.everforest_better_performance = 1
		vim.g.everforest_transparent_background = 0
		vim.cmd.colorscheme("everforest")
	end,
}
