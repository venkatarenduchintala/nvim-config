return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
          "ansiblels",
          "awk_ls",
          "bashls",
          "clangd",
					"docker_compose_language_service",
					"dockerls",
					"dotls",
          "elixirls",
					"eslint",
          "gradle_ls",
          "groovyls",
					"html",
					"htmx",
          "jdtls",
          "jqls",
          "jsonls",
          "kotlin_language_server",
					"lua_ls",
          "matlab_ls",
          "pyright",
					"rust_analyzer",
					"tsp_server",
					"yamlls",
				},
				automatic_installation = true,
			})
		end,
	},
	{
		"williamboman/mason-nvim-dap.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
			"jay-babu/mason-nvim-dap.nvim",
		},
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = {
					"codelldb",
					"javatest",
					"javadbg",
				},
			})
		end,
	},
}
