return {
	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				automatic_enable = false,
				ensure_installed = {
          "bashls",
          "clangd",
          "csharp_ls",
          "cmake",
					"dotls",
          "elixirls",
          "erlangls",
          "helm_ls",
          "gradle_ls",
          "groovyls",
          "jdtls",
          "jqls",
          "jsonls",
          "kotlin_language_server",
          "matlab_ls",
          "nginx_language_server",
          "pyright",
					"lemminx",
					"html",
					"tsp_server",
					"eslint",
					"rust_analyzer",
					"lua_ls",
					"bashls",
					"dockerls",
					"docker_compose_language_service",
					"yamlls",
				},
			})
		end,
	},
	{
		"williamboman/mason-nvim-dap.nvim",
		dependencies = {
			"mason-org/mason.nvim",
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
