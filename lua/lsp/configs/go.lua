return {
	"leoluz/nvim-dap-go",
	ft = "go",
	dependencies = {
		"mfussenegger/nvim-dap",
	},
	config = function()
		require("dap-go").setup({
			dap_configurations = {
				{
					type = "go",
					name = "Attach remote",
					mode = "remote",
					request = "attach",
				},
			},
			delve = {
				path = "dlv",
				initialize_timeout_sec = 20,
				port = "${port}",
				args = {},
				build_flags = "",
				detached = vim.fn.has("win32") == 0,
			},
		})

		local wk = require("which-key")
		wk.add({
			{ "<leader>dt", "<cmd>lua require('dap-go').debug_test()<cr>", desc = "[GO] Debug test under cursor" },
			{ "<leader>dT", "<cmd>lua require('dap-go').debug_last_test()<cr>", desc = "[GO] Debug last test" },
		})
	end,
}
