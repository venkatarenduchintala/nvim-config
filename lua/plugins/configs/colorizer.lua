return {
	"NvChad/nvim-colorizer.lua",
	event = "BufReadPre",
	opts = {},
	config = function(_, opts)
		require("colorizer").setup(opts)
	end,
}
