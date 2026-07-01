return {
	"olimorris/onedarkpro.nvim",
	config = function()
		vim.o.background = "dark"
		require("onedarkpro").load()
	end,
}
