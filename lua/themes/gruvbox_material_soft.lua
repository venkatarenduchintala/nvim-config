-- Gruvbox Material, readability-tuned: medium background + low UI contrast +
-- no transparency to avoid halation. Low-eyestrain counterpart to "gruvbox".
return {
	"sainnhe/gruvbox-material",
	config = function()
		vim.o.background = "dark"
		vim.g.gruvbox_material_background = "medium" -- soft | medium | hard
		vim.g.gruvbox_material_foreground = "material"
		vim.g.gruvbox_material_ui_contrast = "low" -- low | high
		vim.g.gruvbox_material_enable_italic = true
		vim.g.gruvbox_material_better_performance = 1
		vim.g.gruvbox_material_transparent_background = 0
		vim.cmd.colorscheme("gruvbox-material")
	end,
}
