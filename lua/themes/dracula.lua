return {
	"Mofiqul/dracula.nvim",
	config = function()
		local theme = require("dracula")
		theme.setup({})
		theme.load()
	end,
}
