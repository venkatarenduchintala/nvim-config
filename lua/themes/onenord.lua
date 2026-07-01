return {
	"rmehri01/onenord.nvim",
	config = function()
		require("onenord").setup({
			borders = true,
			fade_nc = false,
			styles = {
				comments = "italic",
				strings = "NONE",
				keywords = "NONE",
				functions = "italic",
				variables = "bold",
				diagnostics = "underline",
			},
			disable = {
				background = false,
				cursorline = false,
				eob_lines = true,
			},
			colors = {},
		})
	end,
}
