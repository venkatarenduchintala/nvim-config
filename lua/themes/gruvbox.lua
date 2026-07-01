-- Gruvbox Material — high-contrast / hard background (original tuning).
return {
	"sainnhe/gruvbox-material",
	config = function()
		vim.g.gruvbox_material_enable_italic = true
		vim.cmd.colorscheme("gruvbox-material")
		vim.g.show_eob = 1
		vim.g.background = "dark"
		vim.g.gruvbox_material_background = "hard"
		vim.g.gruvbox_material_foreground = "material"
		vim.g.gruvbox_material_cursor = "auto"
		vim.g.gruvbox_material_show_eob = 0
		vim.g.gruvbox_material_ui_contrast = "high"
		vim.g.gruvbox_material_float_style = "bright"
		vim.g.gruvbox_material_transparent_background = 2
	end,
}
