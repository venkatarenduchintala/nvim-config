-- Kanagawa — muted "ink painting" palette, warm, low contrast.
return {
	"rebelot/kanagawa.nvim",
	config = function()
		require("kanagawa").setup({
			theme = "wave", -- wave (balanced) | dragon (softer, lower contrast)
			background = { dark = "wave" },
			transparent = false,
			dimInactive = false,
			commentStyle = { italic = true },
		})
		vim.o.background = "dark"
		vim.cmd.colorscheme("kanagawa-wave")
	end,
}
