-- Zenbones (dark) — built on lush.nvim with deliberately engineered contrast
-- ratios; warm and muted. Requires the lush.nvim dependency.
return {
	"mcchrish/zenbones.nvim",
	dependencies = { "rktjmp/lush.nvim" },
	config = function()
		vim.o.background = "dark"
		vim.g.zenbones_darkness = "warm" -- "" | warm | stark
		vim.g.zenbones_lighten_comments = 10
		vim.cmd.colorscheme("zenbones")
	end,
}
